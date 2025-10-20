# AI 子系统（NodeCanvas BehaviourTree + 模拟人生式“需求”驱动）

目标：
- 以 NodeCanvas 的 BehaviourTree 作为可视化与执行核心
- 参考“模拟人生”（The Sims）的需求系统（Hunger/Energy/Social/Fun/Bladder/Hygiene）
- 通过 AIManager 集中管理 NPC 的 Blackboard、BehaviourTreeOwner、以及需求随时间衰减与同步

依赖：
- 已集成 NodeCanvas（当前项目 Assets/Addons/ParadoxNotion/NodeCanvas 已存在）
- 行为树资源需放在 Resources 可加载路径下（默认：Resources/Graph/BehaviorTree）

文件：
- Assets/Scripts/Framework/AI/AIManager.cs：AI 管理器（已创建）
- 本 README：使用说明与最佳实践
- 建议新增（后续将补充）：
  - Assets/Scripts/Framework/AI/Tasks/ConditionNeedBelow.cs
  - Assets/Scripts/Framework/AI/Tasks/ConditionNeedAbove.cs
  - Assets/Scripts/Framework/AI/Tasks/ActionAdjustNeed.cs
  - Assets/Scripts/Framework/AI/AIInitializer.cs

一、AIManager 概览
- 单例（DontDestroyOnLoad），集中注册/管理所有 NPC 的 Blackboard 与 BehaviourTreeOwner
- 维护 NPC 的“需求”数值，并按秒衰减，同时同步到 Blackboard
- 提供便捷接口：
  - RegisterNPC(GameObject npc) / RegisterAndStart(GameObject npc, string graphName)
  - AssignBehaviourTree(GameObject npc, string graphName)
  - StartAI/StopAI/PauseAI/ResumeAI/StartAll/StopAll
  - AdjustNeed(GameObject npc, string needName, float delta)

Blackboard 变量（float 0-100）：
- Hunger, Energy, Social, Fun, Bladder, Hygiene
- 行为树中可直接读取这些变量做条件判断（例如：Hunger > 70 → 吃饭分支）

二、如何创建并放置 BehaviourTree 资源
1) 在 Project 面板中右键创建一个 NodeCanvas BehaviourTree（也可在空物体上添加 BehaviourTreeOwner 并新建图）
2) 打开 BehaviourTree 编辑器，设计你的树（见“示例结构”）
3) 将该图保存为资源文件并放置于：
   - Assets/Resources/Graph/BehaviorTree/YourTreeName.asset
   - 注意 Resources/… 路径用于运行时 Resources.Load
4) 在代码中通过 AIManager.AssignBehaviourTree(npc, "YourTreeName") 分配
   - 内部会使用 Resources.Load<BehaviourTree>("Graph/BehaviorTree/YourTreeName")

三、示例：最小接入流程
- 在场景创建一个空物体“AIManager”，挂载 AIManager.cs（或在运行时首次使用时自动生成）
- 创建一个 NPC 物体（任意 GameObject）
- 在 Start/Awake 中注册并分配行为树：
  ```csharp
  void Start(){
      var npc = GameObject.Find("Citizen01");
      AIManager.Instance.RegisterAndStart(npc, "Citizen"); // 对应 Resources/Graph/BehaviorTree/Citizen.asset
  }
  ```
- 或者手动：
  ```csharp
  var agent = AIManager.Instance.RegisterNPC(npcGo);
  AIManager.Instance.AssignBehaviourTree(npcGo, "Citizen");
  AIManager.Instance.StartAI(npcGo);
  ```

四、建议的行为树“模拟人生式”结构（示例）
- Root（Selector，高优先级在上）
  - Condition: Bladder < 20 → 子树：寻找厕所 → 前往 → 使用 → ActionAdjustNeed("Bladder", +60)
  - Condition: Hunger < 30 → 子树：寻找食物 → 前往 → 进食 → ActionAdjustNeed("Hunger", +60)
  - Condition: Energy < 25 → 子树：寻找床 → 睡眠 → ActionAdjustNeed("Energy", +80)
  - Condition: Hygiene < 35 → 子树：寻找淋浴 → 清洁 → ActionAdjustNeed("Hygiene", +60)
  - Condition: Social < 40 → 子树：寻找社交对象 → 聊天/互动 → ActionAdjustNeed("Social", +50)
  - Condition: Fun < 40 → 子树：寻找娱乐 → 玩耍/看电视 → ActionAdjustNeed("Fun", +50)
  - Fallback：巡逻/闲逛/待机（Idle）

说明：
- 条件可直接使用 Blackboard 条件（变量阈值判断），或使用自定义 ConditionNeedBelow/Above 任务
- “前往/寻找”可结合你的移动系统/NavMesh 实现（可作为自定义 ActionTask）
- 完成后调用 ActionAdjustNeed 提升相应需求

五、自定义任务（推荐，后续将提供脚本）
- ConditionNeedBelow(string needName, float threshold)
  - 读取 AIManager 中该 NPC 的当前 need 值，返回是否低于阈值
- ConditionNeedAbove(string needName, float threshold)
  - 返回是否高于阈值
- ActionAdjustNeed(string needName, float delta)
  - 完成行为后调用 AIManager.AdjustNeed 增减需求
- 这些任务将显示在 NodeCanvas 的任务列表中（带分类与说明），拖拽入树即可使用

六、NPC 接入最佳实践
- 每个 NPC 身上自动挂 Blackboard 与 BehaviourTreeOwner（RegisterNPC 时自动补齐）
- NPC 的“定位/移动/动画触发”逻辑，可以在具体 ActionTask 里驱动（确保与 AIManager 解耦）
- 行为树高层以 Selector 管理“动机”（最低需求优先），子树中封装具体交互流程

七、常见问题
- 无法加载行为树资源：
  - 确认资源位于 Resources/Graph/BehaviorTree 下
  - 确保 AIManager.behaviourTreeResourceRoot 与你的路径一致（默认 "Graph/BehaviorTree"）
  - 通过 Resources.Load<BehaviourTree>("Graph/BehaviorTree/YourName") 能否返回非空
- Blackboard 变量未刷新：
  - AIManager 每帧会同步需求到 Blackboard，确保 AIManager 存在且处于激活状态
- 多 NPC 管理：
  - 逐一 RegisterNPC 并 AssignBehaviourTree，或统一 StartAll/StopAll

八、扩展建议
- 在 NodeCanvas 自定义 Action/Condition 中触发 AIManager.OnBehaviourEvent 做全局协调（资源占用、广播等）
- 将“寻找目标对象”（如可用的食物/厕所/床）的选择器抽象成 Utility 函数或全局服务
- 将需求配置（初始值、衰减速度、阈值）抽成 ScriptableObject，便于不同职业/性格 NPC 混合搭配

附：Blackboard 变量一览（默认）
- Hunger, Energy, Social, Fun, Bladder, Hygiene（float 0-100）

放置路径建议：
- 行为树：Assets/Resources/Graph/BehaviorTree/...
- 自定义任务脚本：Assets/Scripts/Framework/AI/Tasks/
- 运行时组件/初始化：Assets/Scripts/Framework/AI/
