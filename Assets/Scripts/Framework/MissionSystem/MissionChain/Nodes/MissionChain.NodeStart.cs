//using System;
using NodeCanvas.Framework;
using ParadoxNotion;
using ParadoxNotion.Design;

namespace YLT.MissionSystem
{
    [DoNotList]
    [ProtectedSingleton]
    [ParadoxNotion.Design.Icon("Sequencer"), Color("FF0909"), Name("Start")]
    public class NodeStart : NodeBase
    {
        public override bool allowAsPrime => true;

        public override int maxInConnections => 0;
    }
}