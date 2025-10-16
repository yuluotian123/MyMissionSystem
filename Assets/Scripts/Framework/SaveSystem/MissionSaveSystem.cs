using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEngine;
using YLT.MissionSystem;

/// <summary>
/// 对应数据：
///1.启用任务，任务进行情况（MissionManager:Mission）:S_MissionManagerData
///2.任务流程情况（MissionChainManager：MissionChainHandle的List）:S_MissionChainManagerData
///3.任务链内部数据进行情况（MissionChainHandle对应的MissionChain，父任务链，进行中的任务节点，进行中的子任务链节点）:S_ChainHandleData
/// </summary>
[Serializable]
public class S_MissionManagerData
{
    public List<string> missionids;
    public List<S_MissionChainManagerData> missionChainManagerDatas;

    public S_MissionManagerData()
    {
        missionids = new List<string>();
        missionChainManagerDatas = new List<S_MissionChainManagerData>();
    }

}
/// <summary>
/// 储存任务内部的完成情况
/// </summary>
[Serializable]
public class S_MissionData
{
    
}


[Serializable]
public class S_MissionChainManagerData
{
    public List<S_ChainHandleData> missionChainHanleDatas;

    public S_MissionChainManagerData() 
    {
        missionChainHanleDatas = new List<S_ChainHandleData>();
    }
}
[Serializable]
public class S_ChainHandleData 
{
    public string missionChainData;
    public string parentHandleData;
    public List<string> activeMissionDatas;
    public List<string> activeSubMissionChainDatas;

    public S_ChainHandleData()
    {

        activeMissionDatas = new List<string>();
        activeSubMissionChainDatas = new List<string>();
        missionChainData = "";
        parentHandleData = "";
    }
}


/// <summary>
/// 序列化系统（静态类）
/// 包含一系列序列化函数
/// </summary>
public static partial class SerializedSystem
{

    /// <summary>
    /// 序列化任务系统（保存时启用）
    /// </summary>
    public static void SerializeMissionSystem(string jsonPath)
    {
        var missionManager = GameManager.instance.missionManager;
        if (missionManager == null)
            return;

        var missionManagerData = new S_MissionManagerData();

        //获取当前进行中的missionid（后续还要储存条件）
        foreach(var mission in missionManager.allMissions)
        {
            missionManagerData.missionids.Add(mission.Key);
        }
        //获取当前运行中的graphid(chainHandle)
        foreach(var missionChainComponent in missionManager.components)
        {
            var missionchainManager = (MissionChainManager)missionChainComponent;
            var missionChainManagerData = new S_MissionChainManagerData();

            //填充图数据
            foreach(var handlepair in missionchainManager.handles)
            {
                var handleData = new S_ChainHandleData();
                var handle =handlepair.Value;
               
                foreach(var a in handle.activeNodes)
                {
                    handleData.activeMissionDatas.Add(a.Key); 
                }

                foreach(var s in handle.subMissionChains)
                {
                    handleData.activeSubMissionChainDatas.Add(s.Key);
                }

                handleData.missionChainData = handle.chain.name;

                if (handle.parentHandle != null)
                {
                    handleData.parentHandleData = handle.parentHandle.chain.name;
                }
                else
                    handleData.parentHandleData = "";

                missionChainManagerData.missionChainHanleDatas.Add(handleData);
            }

            missionManagerData.missionChainManagerDatas.Add(missionChainManagerData);
        }

        SaveJson(missionManagerData,jsonPath);
    }

    /// <summary>
    /// 反序列化任务系统，读取存档
    /// </summary>
    /// <param name="mainGraphPath"></param>
    /// <returns></returns>
    public static MissionManager<object> DeSerializeMissionSystem(string jsonPath,string mainGraphPath = "Graph/Main")
    {
        var missionManager = new MissionManager<object>();
        string json = ReadJson(jsonPath);
        if (json == null || json == "")
        {
            missionManager = new MissionManager<object>();
            var missionChainManager = new MissionChainManager(missionManager);
            missionManager.AddComponent(missionChainManager);
            missionChainManager.StartChain(Resources.Load<MissionChain>(mainGraphPath));

            return missionManager;
        }

        var missionManagerData = JsonUtility.FromJson<S_MissionManagerData>(json);

        for (int i = 0; i < missionManagerData.missionChainManagerDatas.Count; i++)
        {
            var missionChainManager = new MissionChainManager(missionManager);
            var handleDic = new Dictionary<string, MissionChainHandle>();
            foreach(var handleData in missionManagerData.missionChainManagerDatas[i].missionChainHanleDatas)
            {
                //获取任务图信息
                var graphname = handleData.missionChainData;
                var chain = Resources.Load<MissionChain>(GraphPath + graphname);

                //获取对应的任务
                var missionNodeList = new List<NodeMission>();
                for(int j = 0;j < handleData.activeMissionDatas.Count; j++)
                {
                    var missionName = handleData.activeMissionDatas[j];
                    missionNodeList.Add(chain.FindNodeMissionByMissionID(missionName));
                }

                var subNodeList = new List<SubMissionChain>();
                if (handleData.activeSubMissionChainDatas.Count > 0)
                {
                    for (int j = 0; j < handleData.activeSubMissionChainDatas.Count; j++)
                    {
                        var subMissionName = handleData.activeSubMissionChainDatas[j];
                        subNodeList.Add(chain.FindSubMissionChainBySubGraphName(subMissionName));
                    }
                }

                var handle = missionChainManager.StartChain_fromData(chain, missionNodeList,subNodeList);
                
                handleDic.Add(graphname, handle);
            }

            //挂接父对象
            foreach(var handleData in missionManagerData.missionChainManagerDatas[i].missionChainHanleDatas)
            {
                var handle = handleDic[handleData.missionChainData];
                var parentGraphName = handleData.parentHandleData;
                if(parentGraphName != "")
                {
                    var parentHandle = handleDic[parentGraphName];
                    handle.parentHandle = parentHandle;
                }
            }

            missionChainManager.handles = handleDic;
            missionManager.AddComponent(missionChainManager);
        }

        return missionManager;
    }
}