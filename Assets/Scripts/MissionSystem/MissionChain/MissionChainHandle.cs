using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;

namespace YLT.MissionSystem
{
    public class MissionChainHandle
    {
        private readonly MissionChain chain;
        private readonly Dictionary<string, NodeMission> activeNodes = new Dictionary<string, NodeMission>();
        private readonly Queue<NodeMission> buffer = new Queue<NodeMission>();
        //子任务链
        private readonly Dictionary<string,SubMissionChain> subMissionChains = new Dictionary<string, SubMissionChain>();

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

        public void OnMissionChainComplete(string missionchainId, System.Action<string> deployer)
        {
            deployer(missionchainId);

            if (parentHandle == null||!parentHandle.subMissionChains.Remove(missionchainId, out var node)) return;

            foreach (var outConnection in node.outConnections.Where(c => ((ConnectionBase)c).IsAvailable && ((ConnectionBase)c).IsSequence))
            {
                ExecuteNode(outConnection.targetNode as NodeBase);
            }

            // 检测在此任务链结束后母任务链是否也结束了（处理嵌套任务链的情况）
            if (parentHandle.IsCompleted)
            {
                parentHandle.OnMissionChainComplete(parentHandle.chain.name, deployer);
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
                    if (chainNode.StartSubMission(this))
                        subMissionChains.Add(chainNode.subGraph.name, (SubMissionChain)node);
                    break;
            }

            foreach (var outConnection in node.outConnections.Where(c => ((ConnectionBase)c).IsAvailable && ((ConnectionBase)c).IsParallel))
                ExecuteNode(outConnection.targetNode as NodeBase);
        }
    }
}