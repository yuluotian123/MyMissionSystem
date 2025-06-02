using System.Collections.Generic;
using UnityEngine;

namespace Framework.UI
{
    public class UIManager : MonoSingleton<UIManager>
    {
        private Dictionary<string, IPresenter> _presenters = new Dictionary<string, IPresenter>();
        private Dictionary<string, GameObject> _prefabCache = new Dictionary<string, GameObject>();

        public ObjectPool<PoolableUIView> GetUIPool(string prefabPath)
        {
            GameObject prefab = LoadUIPrefab(prefabPath);
            if (prefab == null)
            {
                Debug.LogError($"Failed to load UI prefab: {prefabPath}");
                return null;
            }

            var poolableView = prefab.GetComponent<PoolableUIView>();
            return PoolManager.instance.GetPool(poolableView);
        }
        public PoolableUIView GetOrCreateUIPoolView(GameObject prefab, Transform parent)
        {
            var poolableView = prefab.GetComponent<PoolableUIView>();
            var pool = PoolManager.instance.GetPool(poolableView);
            
            if (pool == null)
            {
                // 创建新的对象池
                pool = PoolManager.instance.CreatePool(poolableView, 1, parent);
            }

            return pool.Spawn(Vector3.zero, Quaternion.identity);
        }
        public GameObject LoadUIPrefab(string path)
        {
            if (_prefabCache.TryGetValue(path, out GameObject prefab))
            {
                return prefab;
            }

            prefab = Resources.Load<GameObject>(path);
            if (prefab != null)
            {
                _prefabCache.Add(path, prefab);
            }

            return prefab;
        }

        public T ShowUI<T>(string prefabPath, Transform parent, bool usePool = true) where T : IPresenter
        {
            string key = typeof(T).Name;

            if (_presenters.TryGetValue(key, out IPresenter presenter))
            {
                presenter.Show();
                return (T)presenter;
            }

            GameObject prefab = LoadUIPrefab(prefabPath);
            if (prefab == null)
            {
                Debug.LogError($"Failed to load UI prefab: {prefabPath}");
                return default;
            }

            GameObject instance;
            IView view;

            if (usePool && prefab.GetComponent<PoolableUIView>() != null)
            {
                // 使用对象池
                var poolableView = GetOrCreateUIPoolView(prefab, parent);
                instance = poolableView.gameObject;
                view = poolableView;
            }
            else
            {
                // 不使用对象池
                instance = Instantiate(prefab, parent);
                view = instance.GetComponent<IView>();
            }

            if (view == null)
            {
                Debug.LogError($"UI prefab does not have an IView component: {prefabPath}");
                Destroy(instance);
                return default;
            }

            T newPresenter = (T)System.Activator.CreateInstance(typeof(T), view);
            _presenters.Add(key, newPresenter);

            newPresenter.Initialize();
            newPresenter.Show();

            return newPresenter;
        }
        public void HideUI<T>() where T : IPresenter
        {
            string key = typeof(T).Name;
            if (_presenters.TryGetValue(key, out IPresenter presenter))
            {
                presenter.Hide();
            }
        }

        public void CloseUI<T>() where T : IPresenter
        {
            string key = typeof(T).Name;
            if (_presenters.TryGetValue(key, out IPresenter presenter))
            {
                var view = (presenter as BasePresenter<IView>)?.View;
                
                if (view is PoolableUIView poolableView)
                {
                    // 如果是池化的UI，返回到对象池
                    var pool = PoolManager.instance.GetPool(poolableView);
                    if (pool != null)
                    {
                        pool.Despawn(poolableView);
                    }
                }
                else
                {
                    // 如果不是池化的UI，直接销毁
                    presenter.Close();
                }
                
                _presenters.Remove(key);
            }
        }

        private void OnDestroy()
        {
            _prefabCache.Clear();
            _presenters.Clear();
        }
    }
} 