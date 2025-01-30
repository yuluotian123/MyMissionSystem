using System;
using ParadoxNotion.Design;
using UnityEngine;
using NodeCanvas.Framework;
using System.Collections.Generic;



#if UNITY_EDITOR
using UnityEditor;
#endif


namespace YLT.MissionSystem
{
    public enum ConditionExecuteMode
    {
        Sequence,
        Parallel
    }

    public enum ConditionUseMode
    {
        And,
        Or
    }


    /// <summary>base class for all mission graph conditions</summary>
    public abstract class ConditionBase: MissionChainObject
    {
        public abstract bool IsConditionMet { get; }


#if UNITY_EDITOR
        protected override GenericMenu GetContextMenu()
        {
            var menu = new GenericMenu();
            menu.AddItem(new GUIContent("Open Script"), false, () => EditorUtils.OpenScriptOfType(this.GetType()));
            menu.AddItem(new GUIContent("Copy"), false, () => { CopyBuffer.SetCache(this); });
            if (CopyBuffer.TryGetCache<ConditionBase>(out var copiedCondition) &&
                this.GetType().IsInstanceOfType(copiedCondition))
                menu.AddItem(new GUIContent("Paste"), false, () =>
                {
                    Utils.CopyObjectFrom(this, copiedCondition);
                });
            menu.AddItem(new GUIContent("Reset"), false, () =>
            {
                Reset();
            });
            menu.AddSeparator("/");
            return OnCreateContextMenu(menu);
        }

        protected virtual GenericMenu OnCreateContextMenu(GenericMenu menu) => menu;
    }
#endif
}