using UnityEngine;

//Monoµ¥ÀýÀà
public abstract class MonoSingleton<T> : MonoBehaviour where T : MonoSingleton<T>
{
    protected static T m_instance = null;

    public static T instance
    {
        get
        {
            if (m_instance == null)
            {
                m_instance = (T)FindObjectOfType<T>();
            }

            return m_instance;
        }
    }

    private void Awake()
    {
        if (instance != null && instance != this.gameObject.GetComponent<T>())
        {
            Destroy(this.gameObject);
            return;
        }

        DontDestroyOnLoad(this.gameObject);
        m_instance = gameObject.GetComponent<T>();

        this.OnInit();
    }

    protected virtual void OnInit() { }

    protected void OnApplicationQuit()
    {
        m_instance = null;
    }
}