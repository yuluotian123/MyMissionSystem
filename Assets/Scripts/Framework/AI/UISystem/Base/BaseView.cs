using UnityEngine;

namespace Framework.UI
{
    public abstract class BaseView : MonoBehaviour, IView
    {
        protected GameObject _gameObject;
        protected RectTransform _rectTransform;
        protected Canvas _canvas;

        protected virtual void Awake()
        {
            _gameObject = gameObject;
            _rectTransform = GetComponent<RectTransform>();
            _canvas = GetComponent<Canvas>();
        }

        public virtual void Show()
        {
            gameObject.SetActive(true);
        }

        public virtual void Hide()
        {
            gameObject.SetActive(false);
        }

        public virtual void Close()
        {
            Hide();
            Destroy(gameObject);
        }

        public GameObject GetGameObject()
        {
            return _gameObject;
        }
    }
} 