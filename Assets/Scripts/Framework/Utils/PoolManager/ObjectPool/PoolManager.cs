using UnityEngine;
using System.Collections.Generic;

[DisallowMultipleComponent]
[AddComponentMenu("Utils/PoolManager")]
public class PoolManager : MonoSingleton<PoolManager>
{
    private Dictionary<string, object> pools = new Dictionary<string, object>();

    private Transform poolRoot;

    public ObjectPool<T> CreatePool<T>(T prefab, int initialSize, Transform root = null) where T : Component
    {
        string key = typeof(T).Name + prefab.name;

        if (pools.ContainsKey(key))
        {
            return pools[key] as ObjectPool<T>;
        }

        // 为该类型的对象创建一个新的父物体
        if (root == null)
            root = poolRoot;
        Transform poolParent = new GameObject($"Pool_{prefab.name}").transform;
        poolParent.SetParent(root);

        ObjectPool<T> newPool = new ObjectPool<T>(prefab, initialSize, poolParent);
        pools.Add(key, newPool);
        return newPool;
    }

    public ObjectPool<T> GetPool<T>(T prefab) where T : Component
    {
        string key = typeof(T).Name + prefab.name;
        if (pools.TryGetValue(key, out object pool))
        {
            return pool as ObjectPool<T>;
        }
        return null;
    }

    public void ClearPool<T>(T prefab) where T : Component
    {
        string key = typeof(T).Name + prefab.name;
        if (pools.TryGetValue(key, out object pool))
        {
            (pool as ObjectPool<T>)?.Clear();
            pools.Remove(key);
        }
    }

    public void ClearAllPools()
    {
        foreach (var pool in pools.Values)
        {
            if (pool is ObjectPool<Component> componentPool)
            {
                componentPool.Clear();
            }
        }
        pools.Clear();
    }
} 