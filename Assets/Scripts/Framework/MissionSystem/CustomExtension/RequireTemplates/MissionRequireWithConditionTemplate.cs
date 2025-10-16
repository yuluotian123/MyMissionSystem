using System;
using ParadoxNotion.Design;
using YLT.Editor;
using YLT.MissionSystem;
using UnityEngine;
using System.Collections.Generic;
using UnityEditor;

[Name("通用任务"), Description("条件任务模板")]
public class MissionRequireWithConditionTemplate : MissionRequireTemplate
{
    [SerializeField] private string eventType;
    [SerializeField] private int count;
    [SerializeField] private bool useMessage;

    //条件相关内容
    [SerializeField] private bool hasCondition;
    [SerializeField] private ConditionUseMode _useMode;
    [SerializeField] private readonly List<ConditionBase> _conditions = new List<ConditionBase>();

    public override bool CheckMessage(object message)
    {
        if (message is not GameMessage gameMessage) return false;

        if (!hasCondition)
            return gameMessage.type.ToString() == eventType;
        else
        {
            if(gameMessage.type.ToString() != eventType) return false;

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

    public class Handle : MissionRequireTemplateHandle
    {
        private readonly MissionRequireWithConditionTemplate require;
        private int count;

        public Handle(MissionRequireWithConditionTemplate require) : base(require)
        {
            this.require = require;
        }
        protected override bool UseMessage(object message)
        {
            var g = (GameMessage)message;

            if (require.useMessage)
            {
                if (g.hasUsed) return false;
                else
                {
                    g.Use();
                    return ++count == require.count;
                }
            }
            else
                return ++count == require.count;
        }
    }

#if UNITY_EDITOR
    /// <summary>remove given require from current list</summary>
    public void DeleteCondition(ConditionBase condition)
    {
        /* do safe check before record undo action */
        if (_conditions.Contains(condition))
        {
            _conditions.Remove(condition);
        }
    }
    /// <summary>add new require to current list</summary>
    public void AddCondition(ConditionBase condition)
    {
        if (condition is null || _conditions.Contains(condition)) return;

        _conditions.Add(condition);
    }

    public override string Summary
    {
        get
        {
            string _outstring = "";
            if (hasCondition&&_conditions.Count > 0)
            {
                switch (_useMode)
                {
                    case ConditionUseMode.And:
                        _outstring += "<size=12><b>\n同时达成以下条件：</b></size>" + "\n";
                        break;

                    case ConditionUseMode.Or:
                        _outstring += "<size=12><b>\n达成以下任意条件：</b></size>" + "\n";
                        break;
                }
                foreach (var condition in _conditions)
                {
                    _outstring += $"<size=12>if{condition.Summary}</size>\n";
                }
            }

            return $"监听<b><size=12><color=#fffde3> \"{eventType}\" </color></size></b>事件<size=12>{_outstring}触发 <b><color=#b1d480>{count} </color></b></size>次";
        }
    }

    protected override void OnInspectorGUI()
    {
        DropdownMenu.MakeMenu("事件类型", eventType, Enum.GetNames(typeof(GameEventType)), result => eventType = result);
        count = UnityEditor.EditorGUILayout.IntField("数量", count);
        count = Mathf.Max(1, count);

        useMessage = UnityEditor.EditorGUILayout.Toggle("是否独占该信息",useMessage);
        hasCondition = UnityEditor.EditorGUILayout.Toggle("是否具有附加条件", hasCondition);
        if (!hasCondition)
            return;

        GUILayout.Label("<color=#fffde3><size=12><b>Condition List</b></size></color>");
        GUILayout.BeginVertical("box");

        EditorUtils.ReorderableList(_conditions, (index, picked) =>
        {
            var condition = _conditions[index];
            condition.DrawInspector();

            GUI.color = Color.white.WithAlpha(0.8f);
            if (GUILayout.Button("Delete Condition")) DeleteCondition(condition);
        });

        if (_conditions.Count > 1)
        {
            _useMode = (ConditionUseMode)EditorGUILayout.EnumPopup("Use Mode", _useMode);
        }

        GUILayout.EndVertical();

        /* add new condition */
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
                menu.AddItem(new GUIContent($"Paste {cache.Title}"), false, () => { AddCondition(Utils.CopyObject(cache)); });
            }

            menu.ShowAsBrowser("Select Condition", typeof(ConditionBase));
        }

    }
#endif
}