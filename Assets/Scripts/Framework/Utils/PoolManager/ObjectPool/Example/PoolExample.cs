using UnityEngine;

public class PoolExample : MonoBehaviour
{
    public PoolableObject prefab;
    private ObjectPool<PoolableObject> pool;

    void Start()
    {
        // 创建对象池
        pool = PoolManager.instance.CreatePool(prefab, 10);
    }

    void Update()
    {
        // 示例：按空格键生成对象
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Vector3 randomPosition = Random.insideUnitSphere * 5f;
            PoolableObject obj = pool.Spawn(randomPosition, Quaternion.identity);
            
            // 示例：3秒后回收对象
            StartCoroutine(DespawnAfterDelay(obj, 3f));
        }
    }

    private System.Collections.IEnumerator DespawnAfterDelay(PoolableObject obj, float delay)
    {
        yield return new WaitForSeconds(delay);
        pool.Despawn(obj);
    }
} 