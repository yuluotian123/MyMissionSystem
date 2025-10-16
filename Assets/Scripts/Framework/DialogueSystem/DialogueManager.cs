using Framework.UI;
using NodeCanvas.DialogueTrees;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[Serializable]
public class DialogConfig 
{
    [Header("对话内容设置")]
    [SerializeField]
    public float _headerSize = 55f;
    [SerializeField]
    public float _fontSize = 45f;

    [Header("Layout设置")]
    [SerializeField]
    public float _contentSpacing = 1f;
    [SerializeField]
    public Vector4 _screenPadding = new Vector4(100f,100f,150f,200f);
    [SerializeField]
    public float _screenSpacing = 60f;
    [SerializeField]
    public float _choiceSpacing = 20f;


    [Header("延迟设置")]
    [SerializeField]
    public bool _isAuto = false;
    [SerializeField]
    public bool _isInstant = false;
    [SerializeField]
    public float _typingDelay = 0.05f;
    [SerializeField]
    public float _finalDelay = 0.5f;
    [SerializeField]
    public float _flipDelay = 1.0f;

    public DialogConfig(float headerSize = 55f, float fontSize = 45f, float contentSpacing = 1f, 
                     Vector4 screenPadding = default, float screenSpacing = 60f, float choiceSpacing = 20f,
                     bool autoPlay = false, bool instant = false, float typeDelay = 0.05f, 
                     float endDelay = 0.5f, float flipTime = 1.0f)
    {
        _headerSize = headerSize;
        _fontSize = fontSize;
        _contentSpacing = contentSpacing;
        _screenPadding = screenPadding == default ? new Vector4(100f, 100f, 150f, 200f) : screenPadding;
        _screenSpacing = screenSpacing;
        _choiceSpacing = choiceSpacing;
        _isAuto = autoPlay;
        _isInstant = instant; 
        _typingDelay = typeDelay;
        _finalDelay = endDelay;
        _flipDelay = flipTime;
    }

    public DialogConfig(DialogConfig dialogConfig)
    {
        _headerSize = dialogConfig._headerSize;
        _fontSize = dialogConfig._fontSize;
        _contentSpacing = dialogConfig._contentSpacing;
        _screenPadding = new Vector4(dialogConfig._screenPadding.x, dialogConfig._screenPadding.y, 
                                   dialogConfig._screenPadding.z, dialogConfig._screenPadding.w);
        _screenSpacing = dialogConfig._screenSpacing;
        _choiceSpacing = dialogConfig._choiceSpacing;
        _isAuto = dialogConfig._isAuto;
        _isInstant = dialogConfig._isInstant;
        _typingDelay = dialogConfig._typingDelay;
        _finalDelay = dialogConfig._finalDelay;
        _flipDelay = dialogConfig._flipDelay;
    }
}

[Serializable]
public class NodeConnectInform
{
    public int currentID;
    public int previousID;

    public NodeConnectInform()
    {
        currentID = -1;
        previousID = -1;
    }
    public NodeConnectInform(int _previousID, int _currentID)
    {
        this.currentID = _currentID;
        this.previousID = _previousID;
    }
}

public class DialogueManager : MonoSingleton<DialogueManager>
{
    [SerializeField]
    private DialogueTreeController dialogue;
    public DialogueTreeController dialogueTreeController => dialogue;
    [SerializeField]
    private RectTransform uiRoot;
    [SerializeField]
    private DialogConfig dialogSettings = new DialogConfig();

    private DialogueTree dialogueTree => DialogueTree.currentDialogue;
    private StoryPresenter storyPresenter = null;
    private bool skip = false;

    //保存数据（节点node信息，当前页面对应的分页信息）
    public Dictionary<string,List<NodeConnectInform>> pageNodesList = new Dictionary<string, List<NodeConnectInform>>();
    public int pageNode = 0;

    void Awake() 
    { 
        Subscribe();
    }
    void OnDestroy() 
    { 
        UnSubscribe();
    }
    void OnDisable() 
    { 
        UnSubscribe(); 
    }

    void Subscribe()
    {
        DialogueTree.OnDialogueStarted += OnDialogueStarted;
        DialogueTree.OnDialoguePaused += OnDialoguePaused;
        DialogueTree.OnDialogueFinished += OnDialogueFinished;
        DialogueTree.OnSubtitlesRequest += OnSubtitlesRequest;
        DialogueTree.OnMultipleChoiceRequest += OnMultipleChoiceRequest;
    }
    void UnSubscribe()
    {
        DialogueTree.OnDialogueStarted -= OnDialogueStarted;
        DialogueTree.OnDialoguePaused -= OnDialoguePaused;
        DialogueTree.OnDialogueFinished -= OnDialogueFinished;
        DialogueTree.OnSubtitlesRequest -= OnSubtitlesRequest;
        DialogueTree.OnMultipleChoiceRequest -= OnMultipleChoiceRequest;
    }

    void OnDialogueStarted(DialogueTree dlg)
    {
        //nothing special...
    }
    void OnDialoguePaused(DialogueTree dlg)
    {
        UIManager.instance.HideUI<StoryPresenter>();
    }
    void OnDialogueFinished(DialogueTree dlg)
    {
        UIManager.instance.CloseUI<StoryPresenter>();
    }
    void OnSubtitlesRequest(SubtitlesRequestInfo info)
    {
        if(storyPresenter != null)
        {
            //跳过或者加载存档
            if (skip)
            {
                var skipSettings = new DialogConfig(dialogSettings);
                skipSettings._isAuto = true;
                skipSettings._isInstant = true;
                skipSettings._finalDelay = 0f;
                skipSettings._typingDelay = 0f;
 
                if (pageNodesList[dialogueTree.name][pageNodesList[dialogueTree.name].Count - 1].currentID == dialogueTree.currentNode.ID)
                {
                    skip = false;
                    skipSettings._isAuto = false;
                    skipSettings._finalDelay = dialogSettings._finalDelay;
                    skipSettings._typingDelay = dialogSettings._typingDelay;

                }

                storyPresenter.ShowDialog(info, skipSettings);

                return;
            }
            //显示对话并储存相关数据
            else
            {
                if (storyPresenter.ShowDialog(info, dialogSettings))
                    pageNode = dialogueTree.currentNode.ID;

                if (pageNodesList[dialogueTree.name].Count > 0)
                {
                    var priviousNode = pageNodesList[dialogueTree.name][pageNodesList[dialogueTree.name].Count - 1].currentID;
                    pageNodesList[dialogueTree.name].Add(new NodeConnectInform(priviousNode, dialogueTree.currentNode.ID));
                }
                else
                    pageNodesList[dialogueTree.name].Add(new NodeConnectInform(-1 , dialogueTree.currentNode.ID));
            }
        }
    }
    private void OnMultipleChoiceRequest(MultipleChoiceRequestInfo info)
    {
        if (storyPresenter != null)
        {
            
            var index = -1;
            var nodeList = pageNodesList[dialogueTree.name];
            //查询后续对应节点，如没有查询到则为-1
            foreach(var node in nodeList)
            {
                if(node.previousID == dialogueTree.currentNode.ID)
                {
                    var nextNode = dialogueTree.GetNodeWithID(node.currentID);

                    for(int i = 0; i < dialogueTree.currentNode.outConnections.Count; i++)
                    {
                        if (dialogueTree.currentNode.outConnections[i].targetNode == nextNode)
                        {
                            index = i;
                            break;
                        }
                    }

                    break;
                }
            }

            if (storyPresenter.ShowMultiChoices(info, dialogSettings,skip,index))
                pageNode = dialogueTree.currentNode.ID;

            //如果不是保存或skip模式，则储存对应信息
            if (!skip)
            {
                if (pageNodesList[dialogueTree.name].Count > 0)
                {
                    var priviousNode = pageNodesList[dialogueTree.name][pageNodesList[dialogueTree.name].Count - 1].currentID;
                    pageNodesList[dialogueTree.name].Add(new NodeConnectInform(priviousNode, dialogueTree.currentNode.ID));
                }
                else
                    pageNodesList[dialogueTree.name].Add(new NodeConnectInform(-1, dialogueTree.currentNode.ID));
            }
            //到达最新未读时取消skip
            else
            {
                if (pageNodesList[dialogueTree.name][pageNodesList[dialogueTree.name].Count - 1].currentID == dialogueTree.currentNode.ID)
                    skip = false;
            }

        }

        Debug.Log(skip);

    }

    private readonly string prefabPath = "Art/prefabs/Dialogue/";
    public DialogView GetOrCreateDialogueUIView(Transform parent)
    {
        var prefab = UIManager.instance.LoadUIPrefab(prefabPath + "DialogueView");
        return (DialogView)UIManager.instance.GetOrCreateUIPoolView(prefab, parent);
    }
    public ObjectPool<PoolableUIView> GetDialogueUIPool()
    {
        return UIManager.instance.GetUIPool(prefabPath + "DialogueView");
    }

    public void StartDialogueTree()
    {
        if(SerializedSystem.DeserializeDialogueTree(SerializedSystem.JsonPathTest2,out var dialogueData))
        {
            skip = true;
            pageNode = dialogueData.pageNode;
            pageNodesList.Add(dialogueTree.name, new List<NodeConnectInform>());

            for (int i = 0; i < dialogueData.currentNodes.Count; i++ )
            {
                var node = dialogueData.currentNodes[i];
                pageNodesList[dialogueTree.name].Add(new NodeConnectInform(node.PreviousID, node.ID));
            }
                
        }
        else
        {
            skip = false;
            pageNodesList.Add(dialogueTree.name, new List<NodeConnectInform>());
        }

        storyPresenter = UIManager.instance.ShowUI<StoryPresenter>(prefabPath + "Story", uiRoot, false);
    }
}
