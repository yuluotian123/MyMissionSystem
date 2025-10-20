using UnityEngine;


public abstract class MonoSingleton<T> : MonoBehaviour where T : MonoSingleton<T>
{
    protected static T m_instance = null;

    public static T instance
    {
        get
        {
            if (m_instance == null)
            {
                m_instance = (T)FindFirstObjectByType<T>();
            }

            return m_instance;
        }
    }

    private void Awake()
    {
        if (instance != null && instance != this.gameObject.GetComponent<T>())
        {
            Debug.LogWarning("场景中存在多个实例，自动销毁重复实例。");
            Destroy(gameObject);
            return;
        }


        //如果为根节点，则设置为不可销毁
        if (transform.root == transform)
            DontDestroyOnLoad(gameObject);


        m_instance = gameObject.GetComponent<T>();

        OnInit();
    }

    protected virtual void OnInit() { }

    protected void OnApplicationQuit()
    {
        m_instance = null;
    }
}