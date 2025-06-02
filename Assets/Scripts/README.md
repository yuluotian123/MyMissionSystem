# 项目脚本结构概览

本文档旨在概述 `Assets/Scripts` 文件夹下的项目结构及其主要模块功能。

## 顶级目录结构

- **DialogueSystem**: 包含与对话系统相关的所有脚本。
- **Framework**: 包含项目的基础框架代码，如存档系统、AI、游戏管理器和通用工具。
- **CustomExtension**: 包含自定义扩展功能。
- **MissionSystem**: 包含任务系统的核心逻辑和实现。
- **UnUsed**: 包含当前未使用或已废弃的脚本（目前为空）。

## 各模块详解

### 1. DialogueSystem

管理游戏中的对话流程和显示。

-   `DialogueManager.cs`: 对话系统的核心管理器。
-   **Dialog/**
    -   `DialogView.cs`: 处理对话界面的显示逻辑。
    -   `StoryPresenter.cs`: 对话剧情的表示逻辑。
    -   `StoryView.cs`: 剧情相关的视图逻辑。

### 2. Framework

提供项目运行所需的基础架构支持。

-   **AI/**
    -   **ObjectPool/**: 对象池实现，用于优化对象创建和销毁。
        -   `IPoolable.cs`: 可池化对象的接口。
        -   `ObjectPool.cs`: 对象池类。
        -   `PoolManager.cs`: 对象池管理器。
        -   **Example/**: 对象池使用示例。
            -   `PoolableObject.cs`: 可池化对象示例。
            -   `PoolExample.cs`: 对象池使用场景示例。
    -   **UISystem/**: UI管理系统。
        -   `UIManager.cs`: UI管理器的核心类。
        -   **Base/**: UI系统的基础类。
            -   `BasePresenter.cs`: Presenter 基类。
            -   `BaseView.cs`: View 基类。
            -   `IPresenter.cs`: Presenter 接口。
            -   `IView.cs`: View 接口。
            -   `PoolableUIView.cs`: 可池化的UI视图。
-   **GameMananger/**
    -   `GameManager.cs`: 游戏主管理器，控制游戏整体流程。
-   **SaveSystem/**: 存档和读档系统。
    -   `DialogueSaveSystem.cs`: 对话数据的存档和读档。
    -   `MissionSaveSystem.cs`: 任务数据的存档和读档。
    -   **Utils/**: 存档相关的工具类。
        -   `SerializeUtilitys.cs`: 序列化工具。
        -   **Editors/**: 编辑器下的存档工具。
            -   `JsonFilesCleaner.cs`: 用于清理JSON存档文件的编辑器脚本。
-   **Utils/**: 通用工具类。
    -   `GameAPI.cs`: 提供游戏相关的API接口。
    -   `GameMessage.cs`: 游戏消息定义。
    -   `MonoSingleton.cs`: MonoBehaviour 单例基类。

### 3. CustomExtension

包含项目自定义的扩展功能。

-   **RequireTemplates/**
    -   `MissionRequireWithConditionTemplate.cs`: 带条件的任务需求模板。

### 4. MissionSystem

实现游戏的任务逻辑。

-   `Core.cs`: 任务系统的核心实现。
-   **MissionChain/**: 任务链相关逻辑。
    -   `MissionChain.cs`: 任务链定义。
    -   `MissionChainHandle.cs`: 任务链处理器。
    -   `MissionChainManager.cs`: 任务链管理器。
    -   `MissionChainObject.cs`: 任务链的 ScriptableObject 定义。
    -   `Utils.cs`: 任务链相关的工具类。
    -   **Actions/**: 任务链中的动作定义。
        -   `ActionBase.cs`: 动作基类。
        -   `ActionGroup.cs`: 动作组。
        -   **Utils/**
            -   `DebugLog.cs`: 用于调试输出的动作。
    -   **Conditions/**: 任务链中的条件定义。
        -   `ConditionBase.cs`: 条件基类。
        -   **Utils/**
            -   `Dice.cs` 和 `Dice1.cs`: 骰子相关的条件（可能用于随机判定）。
    -   **Connections/**
        -   `MissionChain.ConnectionBase.cs`: 任务链连接基类。
    -   **Helper/**: 编辑器辅助工具。
        -   `DropdownMenu.cs`: 下拉菜单实现。
        -   `EditorUtils.cs`: 编辑器通用工具。
    -   **MissionRequireTemplates/**
        -   `MissionRequireTemplate.cs`: 任务需求模板。
    -   **Nodes/**: 任务链中的节点定义。
        -   `MissionChain.NodeAction.cs`: 动作节点。
        -   `MissionChain.NodeBase.cs`: 节点基类。
        -   `MissionChain.NodeMission.cs`: 任务节点。
        -   `MissionChain.NodeNested.cs`: 嵌套任务链节点。
        -   `MissionChain.NodeStart.cs`: 开始节点。
        -   `MissionChain.SubMissionChain.cs`: 子任务链节点。

---

此文档根据 `Assets/Scripts` 文件夹的当前结构生成。随着项目的迭代，本文档也需要同步更新。 