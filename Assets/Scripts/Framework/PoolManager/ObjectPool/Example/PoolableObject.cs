using UnityEngine;

public class PoolableObject : MonoBehaviour, IPoolable
{
    public void OnSpawn()
    {
        // 对象被启用时的初始化逻辑
        Debug.Log($"{gameObject.name} spawned");
    }

    public void OnDespawn()
    {
        // 对象被回收时的清理逻辑
        Debug.Log($"{gameObject.name} despawned");
    }
} 