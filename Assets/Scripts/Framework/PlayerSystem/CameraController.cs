using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.SceneManagement;
using System.Linq;

namespace Framework.GamePlay
{
    /// <summary>
    /// CameraController
    /// - 作为 Cinemachine 的相机管理脚本（管理/切换/震动/目标绑定）
    /// - 支持在 Inspector 中预设虚拟相机清单，也支持运行时注册/反注册
    /// - 通过设置虚拟相机 Priority 实现相机切换与平滑过渡（由 CinemachineBrain 控制混合）
    ///
    /// 常用用法：
    /// 1) 挂载在MainCamera上
    /// 2) 将需要管理的 CinemachineVirtualCamera 拖到 cameras 列表中，并设置唯一 key
    /// 3) 在代码中调用：
    ///    - GetComponent<CameraController>.SwitchTo("FollowCam");               // 切换到指定相机
    ///    - GetComponent<CameraController>.Instance.SetFollowLookAt(player, playerHead); // 设置跟随与注视目标
    ///    - GetComponent<CameraController>.Instance.Shake(2f, 1.5f, 0.25f);              // 进行短暂相机震动
    ///    - GetComponent<CameraController>.Instance.RegisterVcam(vcam, "TempCam");       // 运行时注册临时相机
    ///    - GetComponent<CameraController>.Instance.UnregisterVcam("TempCam");           // 运行时卸载
    ///
    /// 注意：
    /// - 需项目已安装 Cinemachine 包（本项目已包含 Samples）
    /// - 相机混合曲线与默认混合时间由场景中的 CinemachineBrain 决定（通常挂在主摄像机上）
    /// </summary>
    [DisallowMultipleComponent]
    [AddComponentMenu("PlayerSystem/CameraController")]
    public class CameraController : MonoBehaviour
    {
        [System.Serializable]
        public class CameraEntry
        {
            [Tooltip("此虚拟相机的唯一标识 Key，用于代码切换（大小写敏感，建议唯一且稳定）。")]
            public string key;

            [Tooltip("需要管理的 Cinemachine 虚拟相机。")]
            public CinemachineVirtualCamera vcam;
        }
        [Header("默认相机")]
        public string DefaultKey;

        [Header("相机清单（Inspector 预设）")]
        public List<CameraEntry> cameras = new List<CameraEntry>();

        [Header("默认优先级设置")]
        [Tooltip("非激活相机的基础优先级。")]
        public int basePriority = 10;

        [Tooltip("激活相机的优先级（应高于 basePriority）。")]
        public int activePriority = 100;

        [Header("默认跟随/注视目标（在切换场景后有可能为空，此时使用playerCotroller的transform）")]
        public Transform defaultFollow;
        public Transform defaultLookAt;

        public string CurrentKey { get; private set; }
        public CinemachineVirtualCamera CurrentVcam { get; private set; }

        CinemachineBrain _brain;
        readonly Dictionary<string, CinemachineVirtualCamera> _map = new Dictionary<string, CinemachineVirtualCamera>();

        Coroutine _shakeRoutine;

        void Start()
        {
            // 查找 CinemachineBrain（通常在主摄像机上）
            var mainCam = Camera.main;
            if (mainCam != null)
            {
                _brain = mainCam.GetComponent<CinemachineBrain>();
            }
            if (_brain == null)
            {
                _brain = FindFirstObjectByType<CinemachineBrain>();
            }
            
            if(cameras.Count == 0)
            {
                var cameraList = FindObjectsByType<CinemachineVirtualCamera>(FindObjectsSortMode.InstanceID);
                foreach(var c in cameraList)
                {
                    var entry = new CameraEntry();
                    entry.key = c.Name;
                    entry.vcam = c;
                    cameras.Add(entry);
                }              
            }

            BuildMapFromList();
            NormalizePriorities();

            // 如果已设置默认相机，则切过去
            if (!string.IsNullOrEmpty(DefaultKey) && TryGetVcam(DefaultKey, out var initVcam))
            {
                SwitchTo(initVcam);
            }
            else
            {
                // 如果列表中存在第一个，则默认激活第一个
                if (cameras.Count > 0 && cameras[0].vcam != null)
                {
                    SwitchTo(cameras[0].vcam, cameras[0].key);
                }
            }

            // 应用默认目标（如果有）
            if (defaultFollow != null || defaultLookAt != null)
            {
                Debug.Log(defaultFollow.name);
                SetFollowLookAt(defaultFollow, defaultLookAt);
            }
            else
            {
                defaultFollow = FindFirstObjectByType<PlayerController>().transform;
                defaultLookAt = FindFirstObjectByType<PlayerController>().transform;
                SetFollowLookAt(defaultFollow, defaultLookAt);
            }
        }

        void OnValidate()
        {
            // 保持 key 的唯一性和映射表的同步
            BuildMapFromList();
        }

        // 将 Inspector 列表构建为字典映射
        void BuildMapFromList()
        {
            _map.Clear();

            if (cameras == null) return;

            foreach (var entry in cameras)
            {
                if (entry == null || entry.vcam == null) continue;

                var key = (entry.key ?? string.Empty).Trim();
                if (string.IsNullOrEmpty(key))
                {
                    Debug.LogWarning("[CameraManager] 存在未命名的相机条目，已忽略。", this);
                    continue;
                }

                if (_map.ContainsKey(key))
                {
                    Debug.LogWarning($"[CameraManager] 重复的相机 Key: {key}，后者将覆盖前者。", this);
                    _map[key] = entry.vcam;
                }
                else
                {
                    _map.Add(key, entry.vcam);
                }
            }
        }

        // 将所有已知相机优先级重置到 basePriority
        void NormalizePriorities()
        {
            foreach (var kv in _map)
            {
                if (kv.Value != null)
                    kv.Value.Priority = basePriority;
            }
        }

        public bool TryGetVcam(string key, out CinemachineVirtualCamera vcam)
        {
            vcam = null;
            if (string.IsNullOrEmpty(key)) return false;
            return _map.TryGetValue(key, out vcam) && vcam != null;
        }

        public void RegisterVcam(CinemachineVirtualCamera vcam, string key)
        {
            if (vcam == null)
            {
                Debug.LogWarning("[CameraManager] RegisterVcam 失败：传入的 vcam 为 null。", this);
                return;
            }

            key = (key ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(key))
            {
                Debug.LogWarning("[CameraManager] RegisterVcam 失败：key 为空。", this);
                return;
            }

            _map[key] = vcam;
            // 同步到 Inspector 列表（可选）
            if (cameras.FindIndex(c => c != null && c.key == key) < 0)
            {
                cameras.Add(new CameraEntry { key = key, vcam = vcam });
            }

            // 注册后，默认将其优先级设置为基础优先级
            vcam.Priority = basePriority;
        }

        public void UnregisterVcam(string key)
        {
            if (string.IsNullOrEmpty(key)) return;

            if (_map.TryGetValue(key, out var vcam))
            {
                // 如果正在使用此相机，先降级当前引用
                if (CurrentVcam == vcam)
                {
                    CurrentVcam = null;
                    CurrentKey = null;
                }

                _map.Remove(key);
            }

            // 同步移除 Inspector 列表条目（可选）
            int idx = cameras.FindIndex(c => c != null && c.key == key);
            if (idx >= 0)
            {
                cameras.RemoveAt(idx);
            }
        }

        /// <summary>
        /// 切换到指定 key 对应的相机（通过优先级控制，Cinemachine 自动混合）。
        /// </summary>
        public void SwitchTo(string key)
        {
            if (!TryGetVcam(key, out var vcam))
            {
                Debug.LogWarning($"[CameraManager] SwitchTo 失败：未找到相机 Key = {key}", this);
                return;
            }
            SwitchTo(vcam, key);
        }

        /// <summary>
        /// 切换到指定虚拟相机（通过优先级控制，Cinemachine 自动混合）。
        /// 可选指定 key（如果此前未注册，会临时注册）。
        /// </summary>
        public void SwitchTo(CinemachineVirtualCamera vcam, string keyIfUnregistered = null)
        {
            if (vcam == null)
            {
                Debug.LogWarning("[CameraManager] SwitchTo 失败：vcam 为 null。", this);
                return;
            }

            // 保证在 map 中
            if (!string.IsNullOrEmpty(keyIfUnregistered))
            {
                if (!_map.ContainsValue(vcam))
                {
                    RegisterVcam(vcam, keyIfUnregistered);
                }
            }

            // 统一先重置
            NormalizePriorities();

            // 提升目标相机优先级
            vcam.Priority = activePriority;

            CurrentVcam = vcam;
            CurrentKey = null;

            // 尝试反查 key（仅用于展示/保存当前 key）
            foreach (var kv in _map)
            {
                if (kv.Value == vcam)
                {
                    CurrentKey = kv.Key;
                    break;
                }
            }
        }

        /// <summary>
        /// 批量给所有被管理相机设置 Follow / LookAt（任何一个为 null 则跳过该字段）。
        /// 常用于初始化绑定到玩家或者目标点。
        /// </summary>
        public void SetFollowLookAt(Transform follow, Transform lookAt)
        {
            foreach (var kv in _map)
            {
                var cam = kv.Value;
                if (cam == null) continue;

                if (follow != null) cam.Follow = follow;
                if (lookAt != null) cam.LookAt = lookAt;
            }

            if (follow != null) defaultFollow = follow;
            if (lookAt != null) defaultLookAt = lookAt;
        }

        /// <summary>
        /// 对当前激活相机进行一次简单的噪声震动（基于 CinemachineBasicMultiChannelPerlin）。
        /// amplitude: 震动强度；frequency: 震动频率；duration: 时长（秒）。
        /// </summary>
        public void Shake(float amplitude, float frequency, float duration)
        {
            var vcam = CurrentVcam;
            if (vcam == null)
            {
                Debug.LogWarning("[CameraManager] Shake 失败：当前没有激活的相机。", this);
                return;
            }

            var perlin = EnsureNoiseComponent(vcam);
            if (perlin.m_NoiseProfile == null)
            {
                Debug.LogWarning("[CameraManager] 未能获取到 NoiseProfile 组件。", this);
                return;
            }

            if (_shakeRoutine != null)
            {
                CoroutineManager.instance.StopPersistentCoroutine(_shakeRoutine);
            }
            _shakeRoutine = CoroutineManager.instance.StartPersistentCoroutine(this,DoShake(perlin, amplitude, frequency, duration));
        }

        /// <summary>
        /// 立即停止当前震动（并将噪声幅度恢复为 0）。
        /// </summary>
        public void StopShake()
        {
            if (_shakeRoutine != null)
            {
                CoroutineManager.instance.StopPersistentCoroutine(_shakeRoutine);
                _shakeRoutine = null;
            }

            var vcam = CurrentVcam;
            if (vcam != null)
            {
                var perlin = vcam.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
                if (perlin != null)
                {
                    perlin.m_AmplitudeGain = 0f;
                }
            }
        }

        IEnumerator DoShake(CinemachineBasicMultiChannelPerlin perlin, float amplitude, float frequency, float duration)
        {
            float orgAmp = perlin.m_AmplitudeGain;
            float orgFreq = perlin.m_FrequencyGain;

            perlin.m_AmplitudeGain = amplitude;
            perlin.m_FrequencyGain = frequency;

            float t = 0f;
            while (t < duration)
            {
                t += Time.deltaTime;
                yield return null;
            }

            perlin.m_AmplitudeGain = orgAmp;
            perlin.m_FrequencyGain = orgFreq;
            _shakeRoutine = null;
        }

        CinemachineBasicMultiChannelPerlin EnsureNoiseComponent(CinemachineVirtualCamera vcam)
        {
            if (vcam == null) return null;

            var perlin = vcam.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
            if (perlin == null)
            {
                // 如果缺少，则在相机上添加 Noise 组件
                perlin = vcam.AddCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
                // 给出默认参数
                perlin.m_AmplitudeGain = 0f;
                perlin.m_FrequencyGain = 0.5f;
            }
            return perlin;
        }

        /// <summary>
        /// 临时聚焦到目标（为所有相机设置 Follow/LookAt），在 duration 秒后恢复默认 Follow/LookAt。
        /// 如果未设置默认，则只在本次生效。
        /// </summary>
        public void FocusOn(Transform focusFollow, Transform focusLookAt, float duration)
        {
            CoroutineManager.instance.StartCoroutine(DoFocusOn(focusFollow, focusLookAt, duration));
        }

        IEnumerator DoFocusOn(Transform focusFollow, Transform focusLookAt, float duration)
        {
            var oldFollow = defaultFollow;
            var oldLookAt = defaultLookAt;

            SetFollowLookAt(focusFollow, focusLookAt);

            yield return new WaitForSeconds(duration);

            // 恢复默认
            SetFollowLookAt(oldFollow, oldLookAt);
        }

#if UNITY_EDITOR
        void Reset()
        {
            // 尝试自动抓取 Brain
            var mainCam = Camera.main;
            if (mainCam != null)
            {
                _brain = mainCam.GetComponent<CinemachineBrain>();
            }
        }
#endif
    }
}
