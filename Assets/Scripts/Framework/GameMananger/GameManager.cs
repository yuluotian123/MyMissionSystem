using UnityEngine;
using UnityEngine.SceneManagement;
using YLT.MissionSystem;
using Framework.UI;
using Framework.GamePlay;
using System.Linq;


[DisallowMultipleComponent]
[AddComponentMenu("PlayerSystem/GameManager")]
public class GameManager : MonoSingleton<GameManager>
{
    public MissionManager<object> missionManager;

    // 场景与出生点管理
    [SerializeField]
    private bool useGlobalDefaultSpawn = false;
    [SerializeField]
    private Vector3 globalDefaultSpawn;
    private bool isLoadingScene = false;

    protected override void OnInit()
    {
        Debug.Log("Start Chain");
        missionManager = MissionManager<object>.StartMissionManager();
        Debug.Log("StartDialogueSystem");
        DialogueManager.instance.StartDialogueSystem();
    }

    /// <summary>
    /// 按名称切换场景（异步）
    /// </summary>
    public void LoadSceneByName(string sceneName)
    {
        if (isLoadingScene) return;
        isLoadingScene = true;

        var op = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Single);
        if (op != null)
        {
            op.completed += _ => { isLoadingScene = false; };
        }
        else
        {
            isLoadingScene = false;
            Debug.LogError($"LoadSceneAsync failed for {sceneName}");
        }
    }

    /// <summary>
    /// 重载当前场景
    /// </summary>
    public void ReloadCurrentScene()
    {
        var current = SceneManager.GetActiveScene();
        LoadSceneByName(current.name);
    }

    /// <summary>
    /// 通过 BuildIndex 切换场景
    /// </summary>
    public void LoadSceneByIndex(int buildIndex)
    {
        var sceneName = SceneManager.GetSceneByBuildIndex(buildIndex).name;
        if (string.IsNullOrEmpty(sceneName))
        {
            Debug.LogError($"Invalid buildIndex {buildIndex}");
            return;
        }
        LoadSceneByName(sceneName);
    }

    /// <summary>
    /// 切换到下一个场景（根据 BuildIndex）
    /// </summary>
    public void LoadNextScene()
    {
        var current = SceneManager.GetActiveScene();
        var nextIndex = current.buildIndex + 1;
        var next = SceneManager.GetSceneByBuildIndex(nextIndex);
        if (!next.IsValid())
        {
            Debug.LogWarning("Next scene not valid");
            return;
        }
        LoadSceneByName(next.name);
    }

    /// <summary>
    /// 场景加载回调：设置玩家出生点
    /// </summary>
    protected override void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        // 查找玩家
        var player = FindFirstObjectByType<PlayerController>();
        Debug.Log(FindObjectsByType<PlayerController>(FindObjectsSortMode.None).Count());
        if (player == null)
        {
            Debug.LogWarning("玩家未找到，无法设置出生点。");
            return;
        }

        // 计算出生点
        Vector3 spawnPos;
        // 尝试查找场景中的 SpawnPoint 组件
        if (useGlobalDefaultSpawn)
        {
            spawnPos = globalDefaultSpawn;
        }
        else
        {
            var spawn = FindFirstObjectByType<SpawnPoint>();
            if (spawn != null)
            {
                spawnPos = spawn.GetSpawnPosition();
            }
            else
            {
                // 使用玩家当前所在位置作为回退
                spawnPos = player.transform.position;
                Debug.LogWarning($"场景 {scene.name} 未注册出生点且未找到 SpawnPoint，使用玩家当前位置作为出生点。");
            }
        }


        // 设置玩家位置
        player.SetPosition(spawnPos);
    }

    /*void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log("MSG: A");
            GameAPI.Broadcast(new GameMessage(GameEventType.A));
        }

        if (Input.GetKeyDown(KeyCode.B))
        {
            Debug.Log("MSG: B");
            GameAPI.Broadcast(new GameMessage(GameEventType.B));
        }

        if (Input.GetKeyDown(KeyCode.C))
        {
            Debug.Log("MSG: C");
            GameAPI.Broadcast(new GameMessage(GameEventType.C));
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            Debug.Log("MSG: D");
            GameAPI.Broadcast(new GameMessage(GameEventType.D));
        }

        if (Input.GetKeyDown(KeyCode.E))
        {
            Debug.Log("MSG: E");
            GameAPI.Broadcast(new GameMessage(GameEventType.E));
        }

        if (Input.GetKeyDown(KeyCode.F))
        {
            Debug.Log("MSG: F");
            DialogueManager.instance.StartDialogueTree();
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            Debug.Log("Save");
            GameAPI.Save();
        }

    }*/

    public void Update()
    {
        if (Input.GetKeyDown(KeyCode.S))
        {
            Debug.Log("Save");
            GameAPI.Save();
        }
    }
}
