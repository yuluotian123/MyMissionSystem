using UnityEngine;
using System.Collections.Generic;

public class ObjectPool<T> where T : Component
{
    private T prefab;
    private Transform parent;
    private Queue<T> pool;
    private List<T> activeObjects;

    public ObjectPool(T prefab, int initialSize, Transform parent = null)
    {
        this.prefab = prefab;
        this.parent = parent;
        pool = new Queue<T>();
        activeObjects = new List<T>();

        // 预实例化对象
        for (int i = 0; i < initialSize; i++)
        {
            CreateNewInstance();
        }
    }

    private void CreateNewInstance()
    {
        T obj = Object.Instantiate(prefab, parent);
        obj.gameObject.SetActive(false);
        pool.Enqueue(obj);
    }

    public T Spawn(Vector3 position, Quaternion rotation)
    {
        if (pool.Count == 0)
        {
            CreateNewInstance();
        }

        T obj = pool.Dequeue();
        obj.transform.position = position;
        obj.transform.rotation = rotation;
        obj.gameObject.SetActive(true);

        // 如果对象实现了IPoolable接口，调用OnSpawn
        if (obj is IPoolable poolable)
        {
            poolable.OnSpawn();
        }

        activeObjects.Add(obj);
        return obj;
    }

    public void Despawn(T obj)
    {
        if (!activeObjects.Contains(obj))
        {
            return;
        }

        // 如果对象实现了IPoolable接口，调用OnDespawn
        if (obj is IPoolable poolable)
        {
            poolable.OnDespawn();
        }

        obj.gameObject.SetActive(false);
        activeObjects.Remove(obj);
        pool.Enqueue(obj);
    }

    public void DespawnAll()
    {
        foreach (var obj in activeObjects.ToArray())
        {
            Despawn(obj);
        }
    }

    public void Clear()
    {
        DespawnAll();
        foreach (var obj in pool)
        {
            Object.Destroy(obj.gameObject);
        }
        pool.Clear();
        activeObjects.Clear();
    }

    public List<T> GetActiveObjects()
    {
        return new List<T>(activeObjects);
    }
} 