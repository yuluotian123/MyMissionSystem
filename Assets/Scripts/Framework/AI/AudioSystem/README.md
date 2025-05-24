# 音频管理系统使用说明

## 系统设置
1. 在Unity编辑器中创建音频混音器(Audio Mixer):
   - 在Project窗口右键 -> Create -> Audio Mixer
   - 命名为"MainMixer"
   - 在MainMixer中创建两个组："Music"和"SFX"

2. 创建PoolableAudioSource预制体:
   - 创建一个空GameObject
   - 添加PoolableAudioSource脚本组件
   - 将GameObject保存为预制体

3. 设置AudioManager预制体:
   - 创建一个空GameObject，命名为"AudioManager"
   - 添加AudioManager脚本组件
   - 将MainMixer中的Music组分配给musicMixerGroup
   - 将MainMixer中的SFX组分配给sfxMixerGroup
   - 将PoolableAudioSource预制体分配给audioSourcePrefab
   - 设置需要的音频剪辑(Sound数组)
   - 将GameObject保存为预制体

## 使用方法
```csharp
// 播放音频
AudioManager.instance.PlaySound("音频名称");

// 停止音频
AudioManager.instance.StopSound("音频名称");

// 暂停音频
AudioManager.instance.PauseSound("音频名称");

// 设置音量(0-1)
AudioManager.instance.SetVolume("音频名称", 0.5f);

// 设置音高(0.1-3)
AudioManager.instance.SetPitch("音频名称", 1.5f);

// 检查音频是否正在播放
bool isPlaying = AudioManager.instance.IsPlaying("音频名称");

// 获取正在播放的实例数量（对象池）
int playingCount = AudioManager.instance.GetPlayingCount("音频名称");
```

## 音频配置
在AudioManager的Inspector中：
1. 设置Sounds数组大小
2. 为每个Sound设置：
   - name: 音频的唯一标识名称
   - clip: 音频文件
   - volume: 音量(0-1)
   - pitch: 音高(0.1-3)
   - loop: 是否循环播放
   - usePool: 是否使用对象池（适用于频繁播放的音效）
   - poolSize: 对象池初始大小（仅在usePool为true时有效）

## 对象池说明
1. 对象池功能主要用于优化频繁播放的音效，比如：
   - 射击音效
   - 脚步声
   - 收集物品音效
   - 点击音效等

2. 对象池工作机制：
   - 使用项目内置的通用对象池系统
   - 初始化时会创建指定数量(poolSize)的PoolableAudioSource
   - 播放音效时优先使用未在播放的PoolableAudioSource
   - 非循环音频会在播放完成后自动回收到对象池
   - 对于循环音频（如背景音乐），建议不使用对象池(usePool = false)

3. 性能优化：
   - 避免频繁创建和销毁GameObject
   - 减少内存碎片
   - 提高音效播放响应速度
   - 自动管理音频实例的生命周期

## 注意事项
1. 确保音频文件已正确导入到项目中
2. 循环音频(如背景音乐)会自动使用Music混音组
3. 非循环音频(如音效)会自动使用SFX混音组
4. 每个音频名称必须唯一
5. AudioManager是单例模式，可以在任何地方通过AudioManager.instance访问
6. 合理设置对象池大小，避免内存浪费
7. 对于不频繁播放的音频，建议不使用对象池
8. 使用对象池的音频会在播放完成后自动回收，无需手动管理 