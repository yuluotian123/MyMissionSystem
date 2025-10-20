using System.Collections.Generic;
using UnityEngine;
using NodeCanvas.Framework;
using NodeCanvas.BehaviourTrees;
using Unity.VisualScripting;

/// <summary>
/// AIManager - 用于集中管理NPC的AI行为，参考“模拟人生”风格的需求驱动，
/// 采用 NodeCanvas 的 BehaviourTree 作为可视化图形与执行引擎。
/// 职责：
/// 1. 注册/管理 NPC 的 Blackboard 与 BehaviourTreeOwner 组件
/// 2. 从 Resources 加载并分配 BehaviourTree 资产
/// 3. 维护 NPC 的“需求”(Hunger/Energy/Social/Fun/Bladder/Hygiene)并随时间衰减
/// 4. 将需求同步到 Blackboard 供行为树决策
/// 5. 提供全局启动/停止/暂停/恢复等控制接口
/// 使用：
/// - 将本脚本挂到一个全局对象上（如“AIManager”），建议 DontDestroyOnLoad
/// - 为每个 NPC 调用 RegisterNPC/AssignBehaviourTree/StartAI
/// - 将行为树资产放在 Resources/Graph/BehaviorTree/ 下（或修改 behaviourTreeResourceRoot）
///
/// 示例：
/// var agent = AIManager.Instance.RegisterNPC(npcGameObject);
/// AIManager.Instance.AssignBehaviourTree(npcGameObject, "Citizen");
//  AIManager.Instance.StartAI(npcGameObject);
///
/// 在 NodeCanvas 行为树里直接读取 Blackboard 变量：
/// - Hunger, Energy, Social, Fun, Bladder, Hygiene（float 0-100）
/// 例如条件节点：Hunger > 70 时选择“寻找食物”支路。
///
/// 扩展建议：
/// - 在 BehaviourTree 的自定义任务(Task)中调用 AIManager.Instance.OnBehaviourEvent(...)做全局协调
/// - 基于需求阈值设计“动机”(Motivation)并在树中切换高层行为
/// - 通过 AdjustNeed 在任务完成后提升相应需求数值（如吃饭+Hunger）
/// </summary>
public class AIManager : MonoSingleton<AIManager>
{
    [System.Serializable]
    public class NeedDefinition
    {
        public string name;
        [Range(0, 100)] public float startValue = 100f;
        public float min = 0f;
        public float max = 100f;
    }

    [Header("默认需求配置")]
    public List<NeedDefinition> defaultNeeds = new List<NeedDefinition> {
        new NeedDefinition{ name = "Hunger",  startValue = 100f, min = 0f, max = 100f },
        new NeedDefinition{ name = "Energy",  startValue = 100f,  min = 0f, max = 100f },
        new NeedDefinition{ name = "Social",  startValue = 100f,  min = 0f, max = 100f },
        new NeedDefinition{ name = "Fun",     startValue = 100f,  min = 0f, max = 100f },
        new NeedDefinition{ name = "Bladder", startValue =  50f, min = 0f, max = 100f },
        new NeedDefinition{ name = "Hygiene", startValue = 100f, min = 0f, max = 100f },
    };

    public class NPCAgent
    {
        public GameObject gameObject;
        public Blackboard blackboard;
        public BehaviourTreeOwner btOwner;
        public BehaviourTree currentTree;
        public Dictionary<string, float> needs = new Dictionary<string, float>();
    }

    private readonly Dictionary<int, NPCAgent> agents = new Dictionary<int, NPCAgent>();

    /// <summary>
    /// 注册NPC，确保其拥有 Blackboard 与 BehaviourTreeOwner，并初始化默认需求。
    /// 可选地分配默认行为树。
    /// </summary>
    public NPCAgent RegisterNPC(GameObject npc, BehaviourTree defaultTree = null)
    {
        if (npc == null)
        {
            Debug.LogError("AIManager.RegisterNPC: npc 为空");
            return null;
        }

        var id = npc.GetInstanceID();
        if (!agents.TryGetValue(id, out var agent))
        {
            agent = new NPCAgent { gameObject = npc };

            // Blackboard
            var bb = npc.GetComponent<Blackboard>();
            if (bb == null) bb = npc.AddComponent<Blackboard>();
            agent.blackboard = bb;

            // 行为树 Owner
            var owner = npc.GetComponent<BehaviourTreeOwner>();
            if (owner == null)
            {
                owner = npc.AddComponent<BehaviourTreeOwner>();
                owner.repeat = true; // 循环执行
            }

            agent.btOwner = owner;
            owner.blackboard = bb;

            // 初始化需求并同步到黑板
            foreach (var def in defaultNeeds)
            {
                var start = Mathf.Clamp(def.startValue, def.min, def.max);
                agent.needs[def.name] = start;
                SetBlackboardFloat(agent, def.name, start);
            }

            agents[id] = agent;
        }

        if (agent.btOwner.behaviour != null)
            agent.currentTree = agent.btOwner.behaviour;

        if (defaultTree != null)
        {
            AssignBehaviourTree(agent, defaultTree);
        }

        return agent;
    }

    /// <summary>
    /// 从 Resources 加载 BehaviourTree 资产。
    /// 例如 graphName = "Citizen" 将尝试加载 Resources/Graph/BehaviorTree/Citizen.asset
    /// </summary>
    public BehaviourTree LoadBehaviourTree(string graphName)
    {
        if (string.IsNullOrWhiteSpace(graphName))
        {
            Debug.LogError("LoadBehaviourTree: graphName 为空");
            return null;
        }
        var root = string.IsNullOrWhiteSpace(SerializedSystem.BehaviorTreePath) ? "" : SerializedSystem.BehaviorTreePath.TrimEnd('/');
        var path = string.IsNullOrEmpty(root) ? graphName : (root + "/" + graphName);
        var tree = Resources.Load<BehaviourTree>(path);
        if (tree == null)
        {
            Debug.LogError($"未能在 Resources/{path} 加载 BehaviourTree。请确认资源存在并放在 Resources 目录下。");
        }
        return tree;
    }

    /// <summary>
    /// 为已注册的Agent分配行为树
    /// </summary>
    public void AssignBehaviourTree(NPCAgent agent, BehaviourTree tree)
    {
        if (agent == null || agent.btOwner == null)
        {
            Debug.LogError("AssignBehaviourTree: agent 或 btOwner 为空");
            return;
        }
        if(agent.btOwner.behaviour!= null&& agent.btOwner.behaviour.name == tree.name)
        {
            Debug.LogWarning("AssignBehaviourTree: 已经绑定了相同的BehaviorTree");
            return;
        }

        agent.currentTree = tree;
        agent.btOwner.graph = tree;
    }

    /// <summary>
    /// 为指定NPC通过资源名分配行为树
    /// </summary>
    public void AssignBehaviourTree(GameObject npc, string graphName)
    {
        var agent = GetAgent(npc);
        if (agent == null) agent = RegisterNPC(npc);
        var tree = LoadBehaviourTree(graphName);
        if (tree != null) AssignBehaviourTree(agent, tree);
    }

    /// <summary>
    /// 获取已注册的Agent
    /// </summary>
    public NPCAgent GetAgent(GameObject npc)
    {
        if (npc == null) return null;
        agents.TryGetValue(npc.GetInstanceID(), out var agent);
        return agent;
    }

    /// <summary>
    /// 启动指定NPC的行为树
    /// </summary>
    public void StartAI(GameObject npc)
    {
        var agent = GetAgent(npc);
        if (agent == null)
        {
            agent = RegisterNPC(npc);
        }
        if (agent.btOwner != null)
        {
            agent.btOwner.StartBehaviour();
        }
    }

    /// <summary>
    /// 停止指定NPC的行为树
    /// </summary>
    public void StopAI(GameObject npc)
    {
        var agent = GetAgent(npc);
        if (agent?.btOwner != null)
        {
            Debug.Log("Stop");
            agent.btOwner.StopBehaviour();
        }
    }

    /// <summary>
    /// 暂停指定NPC的行为树
    /// </summary>
    public void PauseAI(GameObject npc)
    {
        var agent = GetAgent(npc);
        if (agent?.btOwner != null)
        {
            agent.btOwner.PauseBehaviour();
        }
    }

    /// <summary>
    /// 恢复指定NPC的行为树
    /// </summary>
    public void ResumeAI(GameObject npc)
    {
        var agent = GetAgent(npc);
        if (agent?.btOwner != null)
        {
            agent.btOwner.RestartBehaviour();
        }
    }

    /// <summary>
    /// 每帧更新需求衰减并同步到黑板
    /// </summary>
    private void Update()
    {
        /*float dt = Time.deltaTime;
        foreach (var kv in agents) {
            var agent = kv.Value;
            for (int i = 0; i < defaultNeeds.Count; i++) {
                var def = defaultNeeds[i];
                float current = agent.needs.TryGetValue(def.name, out var val) ? val : def.startValue;
                current = Mathf.Clamp(current - def.decayPerSecond * dt, def.min, def.max);
                agent.needs[def.name] = current;
                SetBlackboardFloat(agent, def.name, current);
            }
        }*/
    }

    /// <summary>
    /// 将数值同步到Blackboard变量（不存在则创建）
    /// </summary>
    private void SetBlackboardFloat(NPCAgent agent, string varName, float value)
    {
        if (agent?.blackboard == null) return;

        agent.blackboard.SetVariableValue(varName, value);

    }

    /// <summary>
    /// 行为事件钩子：可由自定义任务调用，做全局协调
    /// </summary>
    public void OnBehaviourEvent(GameObject npc, string eventName, object data = null)
    {
        Debug.Log($"NPC [{npc?.name}] 触发行为事件: {eventName}, data: {data}");
        // 在此处可做全局协调，例如避免多个NPC争抢同一资源、广播状态变化等
    }

    /// <summary>
    /// 批量控制：启动所有已注册NPC
    /// </summary>
    public void StartAll()
    {
        foreach (var agent in agents.Values)
        {
            if (agent.btOwner != null) agent.btOwner.StartBehaviour();
        }
    }

    /// <summary>
    /// 批量控制：停止所有已注册NPC
    /// </summary>
    public void StopAll()
    {
        foreach (var agent in agents.Values)
        {
            if (agent.btOwner != null) agent.btOwner.StopBehaviour();
        }
    }

    /// <summary>
    /// 便捷方法：注册并立即启动，可选按名称分配行为树
    /// </summary>
    public NPCAgent RegisterAndStart(GameObject npc, string graphName = null)
    {
        var agent = RegisterNPC(npc, null);
        if (!string.IsNullOrWhiteSpace(graphName))
        {
            var tree = LoadBehaviourTree(graphName);
            if (tree != null) AssignBehaviourTree(agent, tree);
        }
        StartAI(npc);
        return agent;
    }
}
