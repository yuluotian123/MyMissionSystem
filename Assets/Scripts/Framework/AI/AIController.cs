using NodeCanvas.BehaviourTrees;
using NodeCanvas.Framework;
using UnityEngine;

/// <summary>
/// AIController - 挂在 NPC 身上的轻量组件。
/// 作用：在 Awake 阶段自动将本 NPC 注册到 AIManager，
/// 可选分配 NodeCanvas BehaviourTree（通过 Resources 路径名），并启动行为树。
///
/// 用法：
/// - 将本脚本添加到任意 NPC（GameObject）上
/// - 设置 graphName（例如 "Citizen"，对应 Resources/Graph/BehaviorTree/Citizen.asset）
/// - 勾选 registerOnAwake/startOnStart 以控制自动注册与启动
///
/// 注意：
/// - 若场景中不存在 AIManager，且 autoCreateManagerIfMissing 为 true，则会自动创建一个全局对象并挂载 AIManager（DontDestroyOnLoad）
/// - 可与 AIManager 的 RegisterAndStart / AssignBehaviourTree 等接口配合使用
/// </summary>
[DisallowMultipleComponent]
public class AIController : MonoBehaviour
{
    [Header("行为树资源名（Resources/Graph/BehaviorTree 下的资产名）")]
    [Tooltip("例如 \"Citizen\" 对应 Resources/Graph/BehaviorTree/Citizen.asset")]
    public string graphName;

    [Header("自动流程")]
    [Tooltip("在 Awake 阶段自动注册到 AIManager")]
    public bool autoRegister = true;

    [Tooltip("是否直接启用行为树")]
    public bool startOnRegister = true;

    [Header("管理器创建")]
    [Tooltip("若场景中不存在 AIManager 实例，是否自动创建一个全局 AIManager 对象")]
    public bool autoCreateManagerIfMissing = true;

    private void Awake()
    {
        EnsureManager();

        if (autoRegister && AIManager.instance != null)
        {
            AIManager.instance.RegisterNPC(gameObject);
            if (!string.IsNullOrWhiteSpace(graphName))
            {
                AIManager.instance.AssignBehaviourTree(gameObject, graphName);
            }
        }

    }

    private void Start()
    {
        
        if (AIManager.instance == null)
        {
            Debug.LogWarning("AIInitializer: AIManager.Instance 为空，无法自动启动。");
            return;
        }

        if (startOnRegister)
            AIManager.instance.StartAI(gameObject);

    }

    private void OnDisable()
    {
        // 可选：禁用时暂停 AI（避免不必要的更新）
        if (AIManager.instance != null)
        {
            AIManager.instance.PauseAI(gameObject);
        }
    }

    private void OnDestroy()
    {
        // 可选：销毁时停止 AI。注意：未做反注册，AIManager 内部以 InstanceID 索引并在下一帧失效。
        if (AIManager.instance != null)
        {
            AIManager.instance.StopAI(gameObject);
        }
    }

    /// <summary>
    /// 若 AIManager 不存在则创建一个全局对象并挂载（DontDestroyOnLoad）
    /// </summary>
    private void EnsureManager()
    {
        if (AIManager.instance == null && autoCreateManagerIfMissing)
        {
            var go = new GameObject("AIManager");
            go.AddComponent<AIManager>();
        }
    }

    // 便捷手动调用（可在其它脚本中调用）
    public void RegisterAndStartNow(string overrideGraphName = null)
    {
        EnsureManager();
        if (AIManager.instance == null) return;

        var nameToUse = string.IsNullOrWhiteSpace(overrideGraphName) ? graphName : overrideGraphName;

        var agent = AIManager.instance.RegisterNPC(gameObject);
        if (!string.IsNullOrWhiteSpace(nameToUse))
        {
            AIManager.instance.AssignBehaviourTree(agent, AIManager.instance.LoadBehaviourTree(nameToUse));
        }
        AIManager.instance.StartAI(gameObject);
    }
}
