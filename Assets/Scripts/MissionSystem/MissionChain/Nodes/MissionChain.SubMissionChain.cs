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
        public override BBParameter subGraphParameter => _subChain;


        /// <summary>
        /// 当执行到子图节点时，需要往任务链管理器中新增一个任务链
        /// </summary>
        public bool StartSubMission(MissionChainHandle parent)
        {
            if (subGraph == null || subGraph.primeNode == null)
                return false;

            if(subGraph.GetAllNodesOfType<NodeMission>().Count() == 0 && subGraph.GetAllNodesOfType<SubMissionChain>().Count() == 0)
            {
                Debug.LogError(subGraph.name + "子图节点内部没有任务节点或子图节点");
                return false;
            }
                

            var subHandle = GameAPI.MissionChainManager.StartChain(subGraph);
            subHandle.parentHandle = parent;

            return true;
        }

    }

}