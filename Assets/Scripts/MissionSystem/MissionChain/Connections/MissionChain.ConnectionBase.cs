using UnityEngine;
using NodeCanvas.Framework;
using System;
using ParadoxNotion.Design;
using System.Collections.Generic;


#if UNITY_EDITOR
using UnityEditor;
#endif

namespace YLT.MissionSystem
{
    public class ConnectionBase : Connection 
    { 
        [SerializeField] private bool hasCondition;
        [SerializeField] private ConditionExecuteMode _executeMode;
        [SerializeField] private ConditionUseMode _useMode;
        [SerializeField] private readonly List<ConditionBase> _conditions = new List<ConditionBase>();

        public bool IsAvailable
        {
            get
            {
                if (!isActive) return false;
                if (!hasCondition ||_conditions.Count == 0) return true;

                switch (_useMode)
                {
                    case ConditionUseMode.And:
                        foreach (var condition in _conditions)
                            if (!condition.IsConditionMet)
                                return false;

                        return true;

                    case ConditionUseMode.Or:
                        foreach (var condition in _conditions)
                            if (condition.IsConditionMet)
                                return true;

                        return false;
                }

                return true;
            }
        }
        public bool IsSequence
        {
            get
            {
                return _executeMode == ConditionExecuteMode.Sequence;
            }
        }
        public bool IsParallel
        {
            get
            {
                return _executeMode == ConditionExecuteMode.Parallel;
            }
        }


#if UNITY_EDITOR
        /// <summary>remove given require from current list</summary>
        public void DeleteCondition(ConditionBase condition)
        {
            /* do safe check before record undo action */
            if (_conditions.Contains(condition))
            {
                UndoUtility.RecordObject(graph, "Condition Deleted");
                _conditions.Remove(condition);
            }
        }

        /// <summary>add new require to current list</summary>
        public void AddCondition(ConditionBase condition)
        {
            if (condition is null || _conditions.Contains(condition)) return;

            UndoUtility.RecordObject(graph, "Condition Added");
            _conditions.Add(condition);
        }

        protected override string GetConnectionInfo()
        {
            string _outstring = "";

            switch (_executeMode)
            {
                case ConditionExecuteMode.Parallel:
                    _outstring += "<size=12>并行</size>" + "\n";
                    break;
                case ConditionExecuteMode.Sequence:
                    _outstring += "<size=12>序列</size>" + "\n";
                    break;
            }

            if ((!hasCondition || _conditions.Count == 0))
                if (_executeMode == ConditionExecuteMode.Sequence)
                    return string.Empty;
                else
                    return _outstring;


            switch (_useMode)
            {
                case ConditionUseMode.And:
                    _outstring += "<size=12><b>同时达成以下条件：</b></size>" + "\n";
                    break;

                case ConditionUseMode.Or:
                    _outstring += "<size=12><b>达成以下任意条件：</b></size>" + "\n";
                    break;
            }

            foreach (var condition in _conditions)
            {
                _outstring += $"<size=12>if{condition.Summary}</size>\n";
            }
                
            return _outstring;
        }

        protected override void OnConnectionInspectorGUI()
        {
            base.OnConnectionInspectorGUI();

            _executeMode = (ConditionExecuteMode)UnityEditor.EditorGUILayout.EnumPopup("ExcuteMode", _executeMode);
            hasCondition = UnityEditor.EditorGUILayout.Toggle("Has Condition", hasCondition);

            if (!hasCondition) return;

            GUILayout.Label("<color=#fffde3><size=12><b>Condition List</b></size></color>");
            GUILayout.BeginVertical("box");

            EditorUtils.ReorderableList(_conditions, (index, picked) =>
            {
                var condition = _conditions[index];
                condition.DrawInspector();

                GUI.color = Color.white.WithAlpha(0.8f);
                if (GUILayout.Button("Delete Condition"))
                {
                    DeleteCondition(condition);
                }
            });

            if (_conditions.Count > 1)
            {
                _useMode = (ConditionUseMode)EditorGUILayout.EnumPopup("Use Mode", _useMode);
            }

            GUILayout.EndVertical();

            /* add new condition */
            GUI.backgroundColor = Colors.lightBlue;
            if (GUILayout.Button("Add Condition"))
            {
                Action<Type> OnTypeSelected = type =>
                {
                    var condition = (ConditionBase)Activator.CreateInstance(type);
                    AddCondition(condition);
                };

                var menu = EditorUtils.GetTypeSelectionMenu(typeof(ConditionBase), OnTypeSelected);
                if (CopyBuffer.TryGetCache<ConditionBase>(out var cache))
                {
                    menu.AddSeparator("/");
                    menu.AddItem(new GUIContent($"Paste {cache.Title}"), false, () => { AddCondition(Utils.CopyObject(cache));});
                }

                menu.ShowAsBrowser("Select Condition", typeof(ConditionBase));
            }

            GUI.backgroundColor = Color.white;
        }
#endif
    }
}