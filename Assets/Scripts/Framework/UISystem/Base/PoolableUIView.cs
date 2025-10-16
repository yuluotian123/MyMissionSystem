using UnityEngine;

namespace Framework.UI
{
    public abstract class PoolableUIView : BaseView, IPoolable
    {
        public virtual void OnSpawn()
        {
            Show();
        }

        public virtual void OnDespawn()
        {
            Hide();
            // 重置UI状态
            ResetState();
        }

        protected virtual void ResetState()
        {
            // 子类可以重写此方法来重置特定的UI状态
        }
    }
} 