using UnityEngine;

//Mono������
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
            Destroy(gameObject);
            return;
        }

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