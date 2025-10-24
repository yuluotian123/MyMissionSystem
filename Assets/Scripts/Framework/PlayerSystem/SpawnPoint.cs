using UnityEngine;

namespace Framework.GamePlay
{
    /// <summary>
    /// 场景出生点组件：挂在任意场景物体上，供 GameManager 在场景加载时定位玩家出生位置。
    /// - 默认使用自身 Transform 位置作为出生点
    /// - 可选偏移/自定义位置/是否使用旋转（当前 GameManager 仅使用位置）
    /// - 提供可视化 Gizmos 便于在场景中查看出生点
    /// </summary>
    [DisallowMultipleComponent]
    [AddComponentMenu("PlayerSystem/SpawnPoint")]
    public class SpawnPoint : MonoBehaviour
    {
        [Header("出生点设置")]
        [Tooltip("是否使用自定义位置而非物体 Transform 位置")]
        public bool overridePosition = false;

        [Tooltip("当启用自定义位置时生效")]
        public Vector3 customPosition;

        [Tooltip("在出生点基础上叠加偏移")]
        public Vector3 offset;

        [Header("旋转设置（可选，目前未被 GameManager 使用）")]
        [Tooltip("是否在出生时使用该物体的旋转")]
        public bool useRotation = false;

        [Header("Gizmos 可视化")]
        public Color gizmoColor = Color.green;
        [Min(0.01f)] public float gizmoRadius = 0.3f;

        /// <summary>
        /// 获取最终出生位置（含可选偏移与自定义位置）
        /// </summary>
        public Vector3 GetSpawnPosition()
        {
            var basePos = overridePosition ? customPosition : transform.position;
            return basePos + offset;
        }

        /// <summary>
        /// 获取出生旋转（当前未被 GameManager 使用）
        /// </summary>
        public Quaternion GetSpawnRotation()
        {
            return useRotation ? transform.rotation : Quaternion.identity;
        }

        private void OnDrawGizmos()
        {
            Gizmos.color = gizmoColor;
            var p = GetSpawnPosition();
            Gizmos.DrawSphere(p, gizmoRadius);
            Gizmos.DrawLine(p, p + Vector3.up * 0.5f);
        }
    }
}

