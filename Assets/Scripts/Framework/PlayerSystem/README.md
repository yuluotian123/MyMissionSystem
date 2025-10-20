# PlayerController 使用说明

## 概述

这个PlayerController系统使用Unity的Input System来处理玩家输入，支持左右移动、行走和奔跑功能。

## 文件结构

- `PlayerController.cs` - 主要的玩家控制器脚本
- `PlayerInputActions.inputactions` - Input System的输入动作配置文件
- `PlayerInputActions.cs` - 自动生成的输入动作C#类

## 设置步骤

### 1. 准备GameObject

1. 创建一个空的GameObject作为玩家对象
2. 添加以下组件：
   - `CharacterController` - 用于角色移动
   - `PlayerInput` - Unity Input System组件
   - `PlayerController` - 我们的自定义控制器脚本

### 2. 配置CharacterController

在CharacterController组件中设置：
- **Center**: (0, 1, 0) - 胶囊体中心
- **Radius**: 0.5 - 胶囊体半径
- **Height**: 2 - 胶囊体高度

### 3. 配置PlayerInput

在PlayerInput组件中：
- **Actions**: 拖拽 `PlayerInputActions.inputactions` 文件到这里
- **Default Map**: 选择 "Player"
- **Behavior**: 设置为 "Invoke Unity Events" 或 "Send Messages"

### 4. 配置PlayerController

在PlayerController组件中可以调整：

#### 移动设置
- **Walk Speed**: 行走速度 (默认: 3)
- **Run Speed**: 奔跑速度 (默认: 6)
- **Acceleration**: 加速度 (默认: 10)
- **Deceleration**: 减速度 (默认: 10)

#### 重力设置
- **Gravity**: 重力值 (默认: -9.81)
- **Ground Check Distance**: 地面检测距离 (默认: 0.1)
- **Ground Layer Mask**: 地面图层遮罩

#### 动画设置
- **Animator**: 角色动画控制器 (可选)

## 输入控制

### 键盘控制
- **WASD** 或 **方向键**: 移动
- **左Shift**: 奔跑 (按住)

### 支持的输入
- 移动输入返回Vector2值，支持8方向移动
- 奔跑是按钮输入，按住时启用奔跑模式

## 动画参数

如果使用Animator，PlayerController会自动设置以下参数：

- `Speed` (float): 当前速度百分比 (0-1)
- `IsRunning` (bool): 是否正在奔跑
- `IsGrounded` (bool): 是否在地面上

### 动画控制器设置示例

在Animator Controller中创建以下参数：
```
Speed (Float) - 控制移动动画的播放速度
IsRunning (Bool) - 切换行走/奔跑动画
IsGrounded (Bool) - 控制跳跃/落地动画
```

## 公共方法

PlayerController提供以下公共方法：

```csharp
// 设置玩家位置
playerController.SetPosition(new Vector3(0, 0, 0));

// 获取当前移动速度
float speed = playerController.GetCurrentSpeed();

// 检查是否在奔跑
bool isRunning = playerController.IsRunning();

// 检查是否在移动
bool isMoving = playerController.IsMoving();

// 检查是否在地面上
bool isGrounded = playerController.IsGrounded();

// 启用/禁用玩家控制
playerController.SetControlEnabled(false);
```

## 调试功能

在Scene视图中选择玩家对象时，会显示：
- 绿色射线：地面检测 (在地面上)
- 红色射线：地面检测 (不在地面上)
- 蓝色射线：当前移动方向

## 扩展功能

### 添加跳跃功能

可以在PlayerInputActions.inputactions中添加跳跃动作：

```json
{
    "name": "Jump",
    "type": "Button",
    "expectedControlType": "Button",
    "bindings": [
        {
            "path": "<Keyboard>/space"
        }
    ]
}
```

然后在PlayerController中添加跳跃逻辑。

### 添加相机跟随

可以创建一个简单的相机跟随脚本：

```csharp
public class CameraFollow : MonoBehaviour
{
    public Transform target;
    public Vector3 offset = new Vector3(0, 5, -10);
    
    void LateUpdate()
    {
        if (target != null)
        {
            transform.position = target.position + offset;
        }
    }
}
```

## 注意事项

1. 确保项目中已安装Input System包
2. 如果修改了PlayerInputActions.inputactions文件，需要重新生成C#类
3. CharacterController组件是必需的，不能用Rigidbody替代
4. 地面检测依赖于正确的Layer设置

## 故障排除

### 常见问题

1. **角色不移动**
   - 检查PlayerInput组件是否正确配置
   - 确认Actions字段已分配PlayerInputActions.inputactions文件

2. **动画不播放**
   - 检查Animator组件是否已分配
   - 确认Animator Controller中有对应的参数

3. **角色穿透地面**
   - 调整CharacterController的参数
   - 检查Ground Layer Mask设置

4. **输入延迟**
   - 调整Acceleration和Deceleration值
   - 检查帧率是否稳定
