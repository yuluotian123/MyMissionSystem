using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[DisallowMultipleComponent]
[AddComponentMenu("Utils/CoroutineManager")]
public class CoroutineManager : MonoSingleton<CoroutineManager>
{
    private class TrackedRoutine
    {
        public IEnumerator original;
        public IEnumerator wrapper;
    }


    private Dictionary<MonoBehaviour, List<TrackedRoutine>> coroutineList = new Dictionary<MonoBehaviour, List<TrackedRoutine>>();

    // 外部调用此方法来启动持久协程
    public Coroutine StartPersistentCoroutine(MonoBehaviour owner, IEnumerator coroutine)
    {
        // 参数健壮性检查，避免空引用或空键进入字典
        if (owner == null || coroutine == null)
        {
            Debug.LogWarning("[CoroutineManager] StartPersistentCoroutine 参数为空。", this);
            return null;
        }

        var wrapper = RunAndTrack(owner, coroutine);

        if (coroutineList.ContainsKey(owner))
        {
            var value = coroutineList[owner];
            value.Add(new TrackedRoutine { original = coroutine, wrapper = wrapper });
        }
        else
        {
            var list = new List<TrackedRoutine>
            {
                new TrackedRoutine { original = coroutine, wrapper = wrapper }
            };
            coroutineList.Add(owner, list);
        }

        Debug.Log("开启携程：" + coroutine);
        return StartCoroutine(wrapper);
    }

    // 包装协程以便自然结束时自动从映射中清理
    private IEnumerator RunAndTrack(MonoBehaviour owner, IEnumerator coroutine)
    {
        yield return coroutine;
        // 协程自然结束后的清理
        if (owner != null && coroutineList.TryGetValue(owner, out var list))
        {
            list.RemoveAll(e => e != null && (e.original == coroutine));
            if (list.Count == 0)
            {
                coroutineList.Remove(owner);
            }
        }
    }

    public void StopPersistentCoroutine(IEnumerator coroutine)
    {
        if (coroutine == null) return;

        MonoBehaviour ownerToUpdate = null;
        TrackedRoutine entryToStop = null;

        foreach (var kv in coroutineList)
        {
            var list = kv.Value;
            if (list == null) continue;

            for (int i = 0; i < list.Count; i++)
            {
                var entry = list[i];
                if (entry != null && entry.original == coroutine)
                {
                    ownerToUpdate = kv.Key;
                    entryToStop = entry;
                    break;
                }
            }

            if (ownerToUpdate != null) break;
        }

        if (ownerToUpdate != null && entryToStop != null)
        {
            // 停止实际运行的包装协程
            if (entryToStop.wrapper != null)
            {
                Debug.Log("正在停止携程：" + entryToStop.wrapper);
                StopCoroutine(entryToStop.wrapper);
            }

            var list = coroutineList[ownerToUpdate];
            list.Remove(entryToStop);
            if (list.Count == 0)
            {
                coroutineList.Remove(ownerToUpdate);
            }
        }
    }

    public void StopPersistentCoroutine(Coroutine coroutineWrapper)
    {
        if (coroutineWrapper != null)
        {
            Debug.Log("正在停止携程Coroutine：" + coroutineWrapper);
            StopCoroutine(coroutineWrapper);
        }
    }

    public void StopPersistentCoroutineAll(MonoBehaviour owner)
    {
        if (owner == null) return;
        if (!coroutineList.ContainsKey(owner)) return;

        if (coroutineList.TryGetValue(owner, out var value))
        {
            foreach (var v in value)
            {
                if (v != null && v.wrapper != null)
                {
                    Debug.Log("正在停止携程：" + v.wrapper);
                    StopCoroutine(v.wrapper);
                }
            }

            coroutineList.Remove(owner);
        }
    }


    private void OnDestroy()
    {
        // 先停止所有协程，再清理映射，避免潜在的状态不一致
        StopAllCoroutines();
        coroutineList.Clear();
    }
}
