using System;
using UnityEngine;

using ParadoxNotion;
using NodeCanvas.Framework;

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
    }
}