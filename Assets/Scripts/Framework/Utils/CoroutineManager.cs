using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoroutineManager : MonoSingleton<CoroutineManager>
{

    private Dictionary<MonoBehaviour, List<IEnumerator>> coroutineList = new Dictionary<MonoBehaviour, List<IEnumerator>>();

   // 外部调用此方法来启动持久协程
    public Coroutine StartPersistentCoroutine(MonoBehaviour owner,IEnumerator coroutine)
    {
        if ( coroutineList.ContainsKey(owner))
        {
            var value = coroutineList[owner];
            value.Add(coroutine);
        }
        else
        {
            var list = new List<IEnumerator>
            {
                coroutine
            };
            coroutineList.Add(owner, list);
        }

        return StartCoroutine(coroutine);
    }

    public void StopPersistentCoroutine(IEnumerator coroutine)
    {
        if (coroutine != null)
        {
            StopCoroutine(coroutine);

            foreach (var pair in coroutineList)
            {
                if (pair.Value.Contains(coroutine))
                {
                    pair.Value.Remove(coroutine);

                    if (pair.Value.Count == 0)
                        coroutineList.Remove(pair.Key);
                }
            }
        }
    }

    public void StopPersistentCoroutineAll(MonoBehaviour owner)
    {
        if (!coroutineList.ContainsKey(owner)) return;

        if (coroutineList.TryGetValue(owner, out var value))
        {
            foreach (var v in value)
            {
                StopCoroutine(v);
            }

            coroutineList.Remove(owner);
        }
    }
    
    private void OnDestroy()
    {
        coroutineList.Clear();
        StopAllCoroutines();
    }
}