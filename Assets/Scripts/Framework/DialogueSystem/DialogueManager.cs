using NodeCanvas.DialogueTrees;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace Framework.UI
{
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
        public Vector4 _screenPadding = new Vector4(100f, 100f, 150f, 200f);
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


    [DisallowMultipleComponent]
    [AddComponentMenu("DialogueSystem/DialogueManager")]
    public class DialogueManager : MonoSingleton<DialogueManager>
    {
        [Header("初始化设置")]
        [SerializeField]
        public DialogueTreeController dialogueTreeController;
        [SerializeField]
        public RectTransform uiRoot;
        public bool Hide
        {
            set
            {
                SetDialogueViewHide(value);
                hide = value;
            }
            get
            {
                return hide;
            }

        }


        [SerializeField, SetProperty("Hide")]
        private bool hide = false;

        [Header("对话项设置")]
        [SerializeField]
        private DialogConfig dialogSettings = new DialogConfig();

        [Header("UI预制体加载根路径")]
        [SerializeField]
        private string prefabPath = "Art/prefabs/Dialogue/";


        private DialogueTree currentDialogueTree => DialogueTree.currentDialogue;
        private StoryPresenter storyPresenter = null;

        [Serializable]
        public class SkipData
        {
            public string contollerName;
            public int pageNode;
            public bool isCurrentDialogue;
            public bool isFinished;

            public SkipData()
            {
                contollerName = "";
                pageNode = 0;
                isCurrentDialogue = false;
                isFinished = false;
            }

            public SkipData(int _pageNode, bool _isCurrentDialogue, bool _isFinished, string _controllerName)
            {
                contollerName = _controllerName;
                pageNode = _pageNode;
                isCurrentDialogue = _isCurrentDialogue;
                isFinished = _isFinished;
            }
        }

        //保存数据（节点node信息，当前页面对应的分页信息,当前进行中的任务图信息,下属两个list为一一对应的）
        public Dictionary<string, List<NodeConnectInform>> pageNodesList = new Dictionary<string, List<NodeConnectInform>>();
        public Dictionary<string, SkipData> graphSkipList = new Dictionary<string, SkipData>();
        private bool skip = false;

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
            Debug.Log("OnDialogueStart: " + dlg.name);

            //清空现有的对话UI并重新生成
            UIManager.instance.CloseUI<StoryPresenter>();
            storyPresenter = UIManager.instance.ShowUI<StoryPresenter>(prefabPath + "Story", uiRoot, false);
            skip = false;

            //初始化存储数据(处理中途切换graph的问题)
            foreach (var data in graphSkipList)
                data.Value.isCurrentDialogue = false;

            //如果当前对话有相关数据，则进行对应操作
            if (graphSkipList.TryGetValue(dlg.name, out var skipData))
            {
                if (pageNodesList[dlg.name].Count > 0)
                {
                    skip = true;
                    skipData.isCurrentDialogue = true;

                    //设置任务图开始节点
                    var controllerGraph = dlg;
                    var firstNode = (DTNode)controllerGraph.GetNodeWithID(skipData.pageNode);
                    controllerGraph.SetCurrentNode(firstNode);
                }
            }
            else
            {
                graphSkipList.Add(dlg.name, new SkipData(0, true, false, dialogueTreeController.name));
                pageNodesList.Add(dlg.name, new List<NodeConnectInform>());
            }
        }
        void OnDialoguePaused(DialogueTree dlg)
        {
            UIManager.instance.HideUI<StoryPresenter>();
        }
        void OnDialogueFinished(DialogueTree dlg)
        {
            if (graphSkipList.TryGetValue(dlg.name, out var skipData))
            {
                skipData.isFinished = true;
                skipData.isCurrentDialogue = false;
            }

            UIManager.instance.CloseUI<StoryPresenter>();
        }
        void OnSubtitlesRequest(SubtitlesRequestInfo info)
        {
            if (storyPresenter != null)
            {
                //跳过或者加载存档
                if (skip)
                {
                    var skipSettings = new DialogConfig(dialogSettings);
                    skipSettings._isAuto = true;
                    skipSettings._isInstant = true;
                    skipSettings._finalDelay = 0f;
                    skipSettings._typingDelay = 0f;

                    if (pageNodesList[currentDialogueTree.name][pageNodesList[currentDialogueTree.name].Count - 1].currentID == currentDialogueTree.currentNode.ID)
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
                        if (graphSkipList.TryGetValue(currentDialogueTree.name, out var skipData))
                            skipData.pageNode = currentDialogueTree.currentNode.ID;

                    if (pageNodesList[currentDialogueTree.name].Count > 0)
                    {
                        var priviousNodeID = pageNodesList[currentDialogueTree.name][pageNodesList[currentDialogueTree.name].Count - 1].currentID;
                        pageNodesList[currentDialogueTree.name].Add(new NodeConnectInform(priviousNodeID, currentDialogueTree.currentNode.ID));
                    }
                    else
                        pageNodesList[currentDialogueTree.name].Add(new NodeConnectInform(-1, currentDialogueTree.currentNode.ID));
                }
            }
        }
        void OnMultipleChoiceRequest(MultipleChoiceRequestInfo info)
        {
            if (storyPresenter != null)
            {

                var index = -1;
                var nodeList = pageNodesList[currentDialogueTree.name];
                //查询后续对应节点，如没有查询到则为-1
                foreach (var node in nodeList)
                {
                    if (node.previousID == currentDialogueTree.currentNode.ID)
                    {
                        var nextNode = currentDialogueTree.GetNodeWithID(node.currentID);

                        for (int i = 0; i < currentDialogueTree.currentNode.outConnections.Count; i++)
                        {
                            if (currentDialogueTree.currentNode.outConnections[i].targetNode == nextNode)
                            {
                                index = i;
                                break;
                            }
                        }

                        break;
                    }
                }

                if (storyPresenter.ShowMultiChoices(info, dialogSettings, skip, index))
                    if (graphSkipList.TryGetValue(currentDialogueTree.name, out var skipData))
                        skipData.pageNode = currentDialogueTree.currentNode.ID;

                //如果不是保存或skip模式，则储存对应信息
                if (!skip)
                {
                    if (pageNodesList[currentDialogueTree.name].Count > 0)
                    {
                        var priviousNode = pageNodesList[currentDialogueTree.name][pageNodesList[currentDialogueTree.name].Count - 1].currentID;
                        pageNodesList[currentDialogueTree.name].Add(new NodeConnectInform(priviousNode, currentDialogueTree.currentNode.ID));
                    }
                    else
                        pageNodesList[currentDialogueTree.name].Add(new NodeConnectInform(-1, currentDialogueTree.currentNode.ID));
                }
                //到达最新未读时取消skip
                else
                {
                    if (pageNodesList[currentDialogueTree.name][pageNodesList[currentDialogueTree.name].Count - 1].currentID == currentDialogueTree.currentNode.ID)
                        skip = false;
                }

            }

            Debug.Log(skip);

        }
        void SetDialogueViewHide(bool isHide)
        {
            if (isHide)
                UIManager.instance.HideUI<StoryPresenter>();
            else
                storyPresenter = UIManager.instance.ShowUI<StoryPresenter>(prefabPath + "Story", uiRoot, false);
        }

        public DialogView GetOrCreateDialogueUIView(Transform _parent)
        {
            var prefab = UIManager.instance.LoadUIPrefab(prefabPath + "DialogueView");
            return (DialogView)UIManager.instance.GetOrCreateUIPoolView(prefab, _parent);
        }
        public ObjectPool<PoolableUIView> GetDialogueUIPool()
        {
            return UIManager.instance.GetUIPool(prefabPath + "DialogueView");
        }
        public void ClearDialogueUIPool()
        {
            UIManager.instance.ClearUIPool(prefabPath + "DialogueView");
        }
        /// <summary>
        /// 从 Resources 加载 BehaviourTree 资产。
        /// 例如 graphName = "Citizen" 将尝试加载 Resources/Graph/BehaviorTree/Citizen.asset
        /// </summary>
        public DialogueTree LoadDialogueTree(string graphName)
        {
            if (string.IsNullOrWhiteSpace(graphName))
            {
                Debug.LogError("LoadDialogueTree: graphName 为空");
                return null;
            }
            var root = string.IsNullOrWhiteSpace(SerializedSystem.DialogueTreePath) ? "" : SerializedSystem.DialogueTreePath.TrimEnd('/');
            var path = string.IsNullOrEmpty(root) ? graphName : (root + "/" + graphName);
            var tree = Resources.Load<DialogueTree>(path);
            if (tree == null)
            {
                Debug.LogError($"未能在 Resources/{path} 加载 DialogueTree。请确认资源存在并放在 Resources 目录下。");
            }
            return tree;
        }
        //启动DialogueSystem并进行检查
        public void StartDialogueSystem(bool start = false)
        {
            if (uiRoot == null)
                uiRoot = FindFirstObjectByType<Canvas>().GetComponent<RectTransform>();
            if (dialogueTreeController == null)
                dialogueTreeController = FindFirstObjectByType<DialogueTreeController>();

            //这个函数设置了controller的dialoguetree
            if (SerializedSystem.DeserializeDialogueSystem(SerializedSystem.JsonPathTest2, out bool isRunning))
            {
                Debug.Log("从存档中获取数据");
                if (start && isRunning) dialogueTreeController.StartBehaviour();
            }
        }

        public void SwitchDialogueTree(string graphName,bool start= true)
        {
            var dialogueTree = LoadDialogueTree(graphName);

            if(dialogueTree && dialogueTreeController)
            {
                dialogueTreeController.StopBehaviour();
                dialogueTreeController.behaviour = dialogueTree;

                if (start)
                    dialogueTreeController.StartBehaviour();
            }
            

        }
        public void SwitchDialogueController(string characterName,string graphName = "",bool start= true)
        {
            var controller = GameObject.Find(characterName).GetComponentInChildren<DialogueTreeController>(true);

            if(controller)
            {
                dialogueTreeController = controller;

                if (graphName == "")
                {
                    if (controller.behaviour == null)
                    {
                        Debug.LogWarning($"当前DialogueTreeController:{characterName}没有DialogueTree");
                        return;
                    }

                    if (start) controller.StartBehaviour();
                    return;
                }
                
                SwitchDialogueTree(graphName, start);                           
            }
        }
    }
}