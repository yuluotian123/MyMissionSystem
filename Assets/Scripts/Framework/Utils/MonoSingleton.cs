using System;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.SceneManagement;


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
        if (instance != null && instance != gameObject.GetComponent<T>())
        {
            Debug.LogWarning("场景中存在多个实例，自动销毁重复实例。");
            DestroyImmediate(gameObject);
            return;
        }


        //如果为根节点，则设置为不可销毁
        if (transform.root == transform)
            DontDestroyOnLoad(gameObject);


        m_instance = gameObject.GetComponent<T>();
        SceneManager.sceneLoaded += OnSceneLoaded;
        SceneManager.sceneUnloaded += OnSceneUnloaded;

        OnInit();
    }

    private void OnDestroy()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
        SceneManager.sceneUnloaded -= OnSceneUnloaded;

        OnRemove();
    }

    protected virtual void OnSceneUnloaded(Scene arg0){     }

    protected virtual void OnSceneLoaded(Scene arg0, LoadSceneMode arg1){}

    protected virtual void OnInit() { }
    protected virtual void OnRemove(){}

    protected void OnApplicationQuit()
    {
        m_instance = null;
        SceneManager.sceneLoaded -= OnSceneLoaded;
        SceneManager.sceneUnloaded -= OnSceneUnloaded;
    }
}