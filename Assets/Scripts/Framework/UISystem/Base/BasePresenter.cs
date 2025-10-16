namespace Framework.UI
{
    public abstract class BasePresenter<TView> : IPresenter where TView : IView
    {
        public readonly TView View;

        protected BasePresenter(TView view)
        {
            View = view;
        }

        public virtual void Initialize()
        {
        }

        public virtual void Show()
        {
            View.Show();
        }

        public virtual void Hide()
        {
            View.Hide();
        }

        public virtual void Close()
        {
            View.Close();
        }
    }
} 