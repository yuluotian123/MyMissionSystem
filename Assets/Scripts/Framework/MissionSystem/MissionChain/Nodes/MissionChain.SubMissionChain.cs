using System;
using System.Collections.Generic;
using System.Linq;
using NodeCanvas.BehaviourTrees;
using NodeCanvas.DialogueTrees;
using NodeCanvas.Framework;
using NodeCanvas.Framework.Internal;
using ParadoxNotion;
using ParadoxNotion.Design;
using ParadoxNotion.Serialization.FullSerializer;
using UnityEngine;

namespace YLT.MissionSystem
{
    [Name("Sub Mission Chain")]
    [Description("子图节点，使用nodecanvas的Editor功能。")]
    [DropReferenceType(typeof(MissionChain))]
    [ParadoxNotion.Design.Icon("Action")]
    public class SubMissionChain : NodeNested<MissionChain>
    {
        [SerializeField, ExposeField]
        private BBParameter<MissionChain> _subChain = null;
        public override MissionChain subGraph { get { return _subChain.value; } set { _subChain.value = value; } }

        //注意，这块用不了nodecanvas自带的parameter的功能
        public override BBParameter subGraphParameter => _subChain;

        //人为规定：子图后不会再连接其他内容（既不方便阅读又不方便使用）
        //public override int maxOutConnections => 0;


        /// <summary>
        /// 当执行到子图节点时，需要往任务链管理器中新增一个任务链
        /// </summary>
        public bool StartSubMission(MissionChainHandle parent)
        {
            if (subGraph == null || subGraph.primeNode == null)
                return false;

            if(subGraph.GetAllNodesOfType<NodeMission>().Count() == 0 && subGraph.GetAllNodesOfType<SubMissionChain>().Count() == 0)
                throw new Exception(subGraph.name + "子图节点内部没有任务节点或子图节点");

            //启动子任务链并进行初始化(后续如果要同时使用多个chainManager的话此处需要拓展)
            var subHandle = ((MissionChainManager)GameManager.instance.missionManager.components[0]).StartChain(subGraph);
            subHandle.parentHandle = parent;

            return true;
        }

    }

}