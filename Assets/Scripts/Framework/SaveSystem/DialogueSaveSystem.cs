using System;
using System.Collections.Generic;
using UnityEngine;
using NodeCanvas.DialogueTrees;
using NodeCanvas.Framework;
using Framework.UI;
using System.Linq;

[Serializable]
public class S_DialogueSystemData
{
    public List<S_DialogueTreeData> dialogueTrees;
    public S_DialogueSystemData()
    {
        dialogueTrees = new List<S_DialogueTreeData>();
    }
}
[Serializable]
public class S_DialogueTreeData
{
    public string controllerName; //对话树使用的controller
    public string dialogueTreePath; // 对话树资源路径
    public List<S_NodeVariable> currentNodes;//当前页面的NodeList
    public int pageNode;//当前页面的首节点
    public bool isDialogueActive;   // 对话是否激活
    public bool isCurrentDialogue;//是否是正在进行中的DialogueTree

    public S_DialogueTreeData()
    {
        controllerName = "";
        dialogueTreePath = "";
        currentNodes = new List<S_NodeVariable>();
        isDialogueActive = false;
        pageNode = 0;
        isCurrentDialogue = false;
    }
}

[Serializable]
public class S_NodeVariable
{
    public int ID;
    public int PreviousID;

    public S_NodeVariable()
    {
        ID = -1;
        PreviousID = -1;
    }
}
public partial class SerializedSystem
{
    /// <summary>
    /// 序列化对话树状态
    /// </summary>
    /// <param name="controller">对话树控制器</param>
    public static void SerializeDialogueTree(string jsonPath)
    {
        var controller = DialogueManager.instance.dialogueTreeController;

        if (controller == null || controller.behaviour == null)
            return;
        var dialogueSystemData = new S_DialogueSystemData();
        var dialogueDataList = new List<S_DialogueTreeData>();

        foreach (var dialogueTreeData in DialogueManager.instance.pageNodesList)
        {
            if (DialogueManager.instance.graphSkipList.TryGetValue(dialogueTreeData.Key, out var skipData))
            {
                //如果当前对话为完成状态，则不保存此对话树
                if (skipData.isFinished)
                    continue;

                var data = new S_DialogueTreeData();

                //如果此对话树为当前正在使用的对话树，则其在储存内容中标识为正在进行的对话树，以便于反序列化时可以快速定位
                if (skipData.isCurrentDialogue && skipData.contollerName == controller.name)
                {
                    data.dialogueTreePath = controller.graphIsBound ? "Bound" : DialogueTreePath + controller.behaviour.name;
                    data.isCurrentDialogue = true;
                    data.isDialogueActive = controller.behaviour.isRunning && !controller.behaviour.isPaused;
                }
                else
                {
                    data.dialogueTreePath = DialogueTreePath + dialogueTreeData.Key;
                    data.isCurrentDialogue = false;
                    data.isDialogueActive = false;
                }

                //储存节点信息，目前还很简陋，需要后续拓展
                foreach (var node in dialogueTreeData.Value)
                {
                    var dialogNode = new S_NodeVariable();
                    dialogNode.ID = node.currentID;
                    dialogNode.PreviousID = node.previousID;
                    data.currentNodes.Add(dialogNode);
                }

                //储存当前进行到的分页（决定反序列化或者重新加载时从哪个节点开始对话树）以及当前对话树使用的controller（目前没什么用处）
                data.pageNode = skipData.pageNode;
                data.controllerName = skipData.contollerName;

                dialogueDataList.Add(data);
            }

        }

        dialogueSystemData.dialogueTrees = dialogueDataList;
        SaveJson(dialogueSystemData, jsonPath);
    }

    /// <summary>
    /// 反序列化对话树状态:如果没有存档，则调用controller目前所有的dialoguetree
    /// </summary>
    /// <returns>是否成功加载</returns>
    public static bool DeserializeDialogueSystem(string jsonPath, out bool isRunning)
    {
        string json = ReadJson(jsonPath);
        isRunning = false;

        //如果没有读到json或者json为null，则返回，不执行反序列化操作
        if (string.IsNullOrEmpty(json)) return false;

        var dialogueDataList = JsonUtility.FromJson<S_DialogueSystemData>(json).dialogueTrees;

        if (dialogueDataList.Count == 0) return false;

        foreach (var data in dialogueDataList)
        {
            //找到graphPath对应的Graph的名称（仅限于从硬盘中读取的对话树）
            string graphName = data.dialogueTreePath.Remove(0, DialogueTreePath.Count());

            //从存档中检测是否为当前正在进行的对话树
            if (data.isCurrentDialogue)
            {
                isRunning = data.isDialogueActive;

                //获取存档中当前正在使用的dialogueController
                var controller = GameObject.Find(data.controllerName).GetComponent<DialogueTreeController>();
                if (controller == null)
                {
                    Debug.LogError("无法获取当前的Controller：" + data.controllerName);
                    return false;
                }
                DialogueManager.instance.dialogueTreeController = controller;

                //获取存档中当前正在使用的dialogueTree
                DialogueTree dialogueTree = null;

                if (data.dialogueTreePath == "Bound" && controller.graphIsBound)
                    dialogueTree = controller.behaviour;
                else
                    dialogueTree = Resources.Load<DialogueTree>(data.dialogueTreePath);

                if (dialogueTree == null)
                {
                    Debug.LogError("无法获取指定的dialogueTree：" + data.dialogueTreePath + "绑定：" + controller.graphIsBound);
                    return false;
                }

                controller.behaviour = dialogueTree;
                graphName = dialogueTree.name;
            }

            var skipData = new DialogueManager.SkipData(data.pageNode, data.isCurrentDialogue, false, data.controllerName);
            var listData = new List<NodeConnectInform>();

            for (int i = 0; i < data.currentNodes.Count; i++)
            {
                var node = data.currentNodes[i];
                listData.Add(new NodeConnectInform(node.PreviousID, node.ID));
            }

            DialogueManager.instance.graphSkipList.Add(graphName, skipData);
            DialogueManager.instance.pageNodesList.Add(graphName, listData);

        }

        return true;
    }
}