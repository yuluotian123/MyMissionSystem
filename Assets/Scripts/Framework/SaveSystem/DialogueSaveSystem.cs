using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using NodeCanvas.DialogueTrees;
using NodeCanvas.Framework;

[Serializable]
public class S_DialogueTreeData
{
    public string dialogueTreePath; // 对话树资源路径
    public List<int> currentNodes;//当前页面的NodeList
    public bool isDialogueActive;   // 对话是否激活
    public List<S_DialogueVariable> variables; // 黑板变量列表

    public S_DialogueTreeData()
    {
        dialogueTreePath = "";
        currentNodes = new List<int>();
        isDialogueActive = false;
        variables = new List<S_DialogueVariable>();
    }
}

[Serializable]
public class S_DialogueVariable
{
    public string name;
    public string value;
    public string type;

    public S_DialogueVariable(string name, object value, Type type)
    {
        this.name = name;
        this.value = value?.ToString() ?? "";
        this.type = type.FullName;
    }
}

public static partial class SerializedSystem
{
    /// <summary>
    /// 序列化对话树状态
    /// </summary>
    /// <param name="controller">对话树控制器</param>
    public static void SerializeDialogueTree(string jsonPath)
    {
        var controller = DialogueManager.instance.dialogueTreeController;

        if (controller == null || controller.graph == null)
            return;

        var dialogueData = new S_DialogueTreeData();
        var dialogueTree = DialogueTree.currentDialogue;
        
        // 保存对话树资源路径
        dialogueData.dialogueTreePath = controller.graphIsBound?"Bound":GraphPath + controller.graph.name;

        // 保存当前节点ID和运行状态
        if (dialogueTree != null && dialogueTree.currentNode != null)
        {
            dialogueData.currentNodes = DialogueManager.instance.currentNodesList;
            dialogueData.isDialogueActive = dialogueTree.isRunning;
        }

        // 保存黑板变量
        if (controller.blackboard != null)
        {
            foreach (var variable in controller.blackboard.variables)
            {
                if (variable.Value != null)
                {
                    dialogueData.variables.Add(new S_DialogueVariable(
                        variable.Key,
                        variable.Value.value,
                        variable.Value.varType
                    ));
                }
            }
        }

        SaveJson(dialogueData, jsonPath);
    }

    /// <summary>
    /// 反序列化对话树状态
    /// </summary>
    /// <returns>是否成功加载</returns>
    public static bool DeserializeDialogueTree(string jsonPath, string mainGraphPath = "Graph/DialogueTree")
    {
        string json = ReadJson(jsonPath);
        var controller = DialogueManager.instance.dialogueTreeController;
        if (string.IsNullOrEmpty(json))
        {
            var dialogueTree = Resources.Load<DialogueTree>(mainGraphPath);
            controller.StartBehaviour(dialogueTree);
            return true;
        }

        DTNode firstNode = null;

        var dialogueData = JsonUtility.FromJson<S_DialogueTreeData>(json);
        
        // 加载对话树资源
        if (!string.IsNullOrEmpty(dialogueData.dialogueTreePath))
        {
            DialogueTree dialogueTree = null;
            if (dialogueData.dialogueTreePath == "Bound")
            {
                if (controller.graphIsBound)
                    dialogueTree = controller.behaviour;
            }
            else
                dialogueTree = Resources.Load<DialogueTree>(dialogueData.dialogueTreePath);

            if (dialogueTree != null)
            {
                // 恢复黑板变量
                if (controller.blackboard != null)
                {
                    foreach (var varData in dialogueData.variables)
                    {
                        try
                        {
                            Type varType = Type.GetType(varData.type);
                            if (varType != null)
                            {
                                object value = Convert.ChangeType(varData.value, varType);
                                controller.blackboard.SetVariableValue(varData.name, value);
                            }
                        }
                        catch (Exception e)
                        {
                            Debug.LogWarning($"Failed to restore variable {varData.name}: {e.Message}");
                        }
                    }
                }

                // 如果对话是激活状态，重新启动对话树
                if (dialogueData.isDialogueActive)
                {
                    
                    controller.StartBehaviour(dialogueTree);
                    var currentRunningGraph = DialogueTree.currentDialogue;
                    // 恢复当前节点
                    if (dialogueData.currentNodes.Count > 0)
                    {
                        firstNode = (DTNode)currentRunningGraph.GetNodeWithID(dialogueData.currentNodes[0]);

                    }

                    currentRunningGraph.SetCurrentNode(firstNode);
                    DialogueManager.instance.MoveToCurrentStep(dialogueData.currentNodes);

                }

                return true;
            }

            return false;
        }
        else
        {
            var dialogueTree = Resources.Load<DialogueTree>(mainGraphPath);
            controller.StartBehaviour(dialogueTree);
            return true;
        }

    }
} 