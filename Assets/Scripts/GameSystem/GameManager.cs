﻿using UnityEngine;
using YLT.MissionSystem;

public class GameManager : MonoSingleton<GameManager>
{
    [SerializeField] private MissionChain chain;
    public MissionManager<object> MissionManager;

    protected override void OnInit()
    {
        StartMissionSystem();
    }

    private void StartMissionSystem()
    {
        Debug.Log("Start Chain");
        this.MissionManager = SerializedSystem.NonSerializeMissionSystem("Graph/Main");
    }

    void Update()
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

        if (Input.GetKeyDown(KeyCode.S))
        {
            Debug.Log("Save");
            GameAPI.Save();
        }

    }
}