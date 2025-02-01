using System.Collections.Generic;
using UnityEngine;

namespace YLT.MissionSystem
{
    /// <summary>
    /// 任务链管理器是一种组件，会监听任务的开始和结束
    /// </summary>
    public class MissionChainManager : IMissionSystemComponent<object>
    {
        private readonly MissionManager<object> missionManager;
        private readonly Dictionary<string, MissionChainHandle> handles = new Dictionary<string, MissionChainHandle>();

        public MissionChainManager(MissionManager<object> missionManager)
        {
            this.missionManager = missionManager;
        }

        public MissionChainHandle StartChain(MissionChain chain)
        {
            if (chain == null) return null;

            if (handles.TryGetValue(chain.name, out var existHandle))
                return existHandle;

            var handle = new MissionChainHandle(chain);
            handle.FlushBuffer(t => missionManager.StartMission(t));
            if (!handle.IsCompleted)
                handles.Add(chain.name, handle);

            return handle;
        }

        public void OnMissionStarted(Mission<object> mission) { }

        public void OnMissionRemoved(Mission<object> mission, bool isFinished)
        {
            // Get the mission chain handle
            var missionChainId = mission.id.Split('.')[0];
            if (!handles.TryGetValue(missionChainId, out var handle)) return;

            // Notify the handle that the mission is completed
            handle.OnMissionComplete(mission.id, isFinished);
            handle.FlushBuffer(t => missionManager.StartMission(t));

            // Remove the handle if the mission is finished
            if (handle.IsCompleted)
            {
                handle.OnMissionChainComplete(missionChainId, t =>
                {
                    Debug.Log("IsComplete" + t + " HandleCount:" + handles.Count);
                    handles.Remove(t);
                    Debug.Log("AfterRemove:" + handles.Count);
                });
            }
        }

        public void OnMissionStatusChanged(Mission<object> mission, bool isFinished) { }
    }
}