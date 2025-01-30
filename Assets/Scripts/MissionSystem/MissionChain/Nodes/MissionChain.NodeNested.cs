using System;
using System.Collections.Generic;
using NodeCanvas.Framework;
using NodeCanvas.Framework.Internal;
using ParadoxNotion;

namespace YLT.MissionSystem
{
    public abstract class NodeNested<T> : NodeBase, IGraphAssignable<T> where T : Graph
    {
        public T subGraph { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public T currentInstance { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public Dictionary<Graph, Graph> instances { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public BBParameter subGraphParameter => throw new NotImplementedException();

        public List<BBMappingParameter> variablesMap { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        Graph IGraphAssignable.subGraph { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        Graph IGraphAssignable.currentInstance { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
    }
}