using System;
using UnityEngine;

using ParadoxNotion;
using NodeCanvas.Framework;
using System.Collections.Generic;

namespace YLT.MissionSystem
{
    
    [GraphInfo(
        packageName = "NodeCanvas",
        docsURL = "https://nodecanvas.paradoxnotion.com/documentation/",
        resourcesURL = "https://nodecanvas.paradoxnotion.com/downloads/",
        forumsURL = "https://nodecanvas.paradoxnotion.com/forums-page/"
    )]
    [CreateAssetMenu(menuName = "MissionSystem/MissionChain", fileName = "New MissionChain")]
    public class MissionChain : Graph
    {
        public override Type baseNodeType => typeof(NodeBase);
        public override bool requiresAgent => false;
        public override bool requiresPrimeNode => true;
        public override bool isTree => true;
        public override PlanarDirection flowDirection => PlanarDirection.Horizontal;
        public override bool allowBlackboardOverrides => false;
        public override bool canAcceptVariableDrops => false;

        protected override void OnGraphObjectEnable()
        {
            if (primeNode == null)
                primeNode = AddNode<NodeStart>();

            base.OnGraphObjectEnable();
        }

        public NodeMission FindNodeMissionByMissionID(string missionID)
        {
            var graphID = missionID.Split('.')[0];
            if(graphID != name)
                return null;

            var nodeMissionList = GetAllNodesOfType<NodeMission>();

            foreach ( var nodeMission in nodeMissionList)
            {
                if(nodeMission.MissionId == missionID) 
                    return nodeMission;
            }

            return null;
        }

        public SubMissionChain FindSubMissionChainBySubGraphName(string subGraphName)
        {
            var SubNodeList = GetAllNodesOfType<SubMissionChain>();

            foreach ( var subNode in SubNodeList)
            {
                if(subGraphName == subNode.subGraph.name)
                    return subNode;
            }

            return null;
        }
    }
}