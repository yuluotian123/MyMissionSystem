using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;

namespace YLT.MissionSystem
{
    //本质是管理一个任务链，也就是任务图对象，会对内部的任务节点和子任务链进行管理操作
    public class MissionChainHandle
    {
        public readonly MissionChain chain;

        //任务缓冲区
        public readonly Queue<NodeMission> buffer = new Queue<NodeMission>();

        
        //内部进行中任务
        public readonly Dictionary<string, NodeMission> activeNodes = new Dictionary<string, NodeMission>();
        //内部进行中子任务链，注意子任务链是没有缓冲区的，它类似action，会即刻执行内部操作
        public readonly Dictionary<string,SubMissionChain> subMissionChains = new Dictionary<string, SubMissionChain>();

        //该任务链父对象
        public MissionChainHandle parentHandle = null;


        public bool IsCompleted
        {
            get 
            {
                return activeNodes.Count == 0 && subMissionChains.Count == 0;
            }
        }


        public MissionChainHandle(MissionChain chain)
        {
            this.chain = chain;
            /* execute prime node */
            if (chain.primeNode != null)
            {
                ExecuteNode(chain.primeNode as NodeBase);
            }
        }

        public MissionChainHandle(MissionChain chain,List<NodeMission> missionNodes,List<SubMissionChain> subMissions,bool isSaving)
        {
            this.chain = chain;

            /* execute prime node */
            if (!isSaving||missionNodes == null)
            {
                if (chain.primeNode != null)
                {
                    ExecuteNode(chain.primeNode as NodeBase);
                    return;
                }
            }

            for(int i = 0;i< missionNodes.Count;i++)
            {
                buffer.Enqueue(missionNodes[i]);
            }
            for(int i = 0; i< subMissions.Count; i++)
            {
                subMissionChains.Add(subMissions[i].subGraph.name,subMissions[i]);
            }
        }


        //刷新任务缓冲区
        public void FlushBuffer(System.Action<MissionPrototype<object>> deployer)
        {
            if (buffer.Count == 0) return;
            while (buffer.Count > 0)
            {
                var node = buffer.Dequeue();
                var missionProto = node.MissionProto;
                activeNodes.Add(missionProto.id, node);
                deployer(missionProto);               
            }
        }

        public void OnMissionComplete(string missionId, bool continues)
        {
            if (!activeNodes.Remove(missionId, out var node)) return;
            
            /* execute all available output connections */
            if (continues)
            {
                foreach (var outConnection in node.outConnections.Where(c => ((ConnectionBase)c).IsAvailable && ((ConnectionBase)c).IsSequence))
                {
                    ExecuteNode(outConnection.targetNode as NodeBase);
                }
            }
        }

        public void OnMissionChainComplete(string missionchainId,MissionManager<object> missionManager,System.Action<string> deployer)
        {
            deployer(missionchainId);

            if (parentHandle == null||!parentHandle.subMissionChains.Remove(missionchainId, out var node)) return;

            //处理母任务链的后续链接
            foreach (var outConnection in node.outConnections.Where(c => ((ConnectionBase)c).IsAvailable && ((ConnectionBase)c).IsSequence))
            {
                parentHandle.ExecuteNode(outConnection.targetNode as NodeBase);
            }
            //如果后续任务链有任务则会自动刷新缓冲区
            parentHandle.FlushBuffer(t => missionManager.StartMission(t));

            // 检测在此任务链结束后母任务链是否也结束了（处理嵌套任务链的情况）
            if (parentHandle.IsCompleted)
            {
                parentHandle.OnMissionChainComplete(parentHandle.chain.name, missionManager, deployer);
            }
        }

        /// <summary>execute given node</summary>
        public void ExecuteNode(NodeBase node)
        {   
            if (node is null) return;

            switch (node)
            {
                /* execute action node */
                case NodeAction actionNode:
                    actionNode.Execute();
                    break;
                
                /* execute mission node, add output prototype to buffer queue */
                case NodeMission missionNode:
                    if (activeNodes.ContainsKey(missionNode.MissionId)) return;
                    buffer.Enqueue(missionNode);

                    break;

                case NodeStart startNode:
                    foreach (var outConnection in node.outConnections.Where(c => ((ConnectionBase)c).IsAvailable && ((ConnectionBase)c).IsSequence))
                        ExecuteNode(outConnection.targetNode as NodeBase);
                    break;

                case SubMissionChain chainNode:
                    if (subMissionChains.ContainsKey(chainNode.subGraph.name)) return;
                    if (chainNode.StartSubMission(this))
                        subMissionChains.Add(chainNode.subGraph.name, (SubMissionChain)node);
                    break;
            }

            foreach (var outConnection in node.outConnections.Where(c => ((ConnectionBase)c).IsAvailable && ((ConnectionBase)c).IsParallel))
                ExecuteNode(outConnection.targetNode as NodeBase);
        }
    }
}