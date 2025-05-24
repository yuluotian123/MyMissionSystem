using Framework.UI;
using NodeCanvas.DialogueTrees;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class DialogConfig 
{
    [Header("对话内容设置")]
    [SerializeField]
    public float headerSize = 55f;

    [Header("Layout设置")]
    [SerializeField]
    public float _contentSpacing = 1f;
    [SerializeField]
    public Vector4 ScreenPadding = new Vector4(100f,100f,150f,200f);
    [SerializeField]
    public float ScreenSpacing = 60f;


    [Header("延迟设置")]
    [SerializeField]
    public bool isAuto = false;
    [SerializeField]
    public bool isInstant = false;
    [SerializeField]
    public float typingDelay = 0.05f;
    [SerializeField]
    public float finalDelay = 0.5f;
    [SerializeField]
    public float flipDelay = 1.0f;

    public DialogConfig(float contentSpacing = 1f, Vector4 screenPadding = default, float screenSpacing = 60f, 
                     bool autoPlay = false, bool instant = false, float typeDelay = 0.05f, 
                     float endDelay = 0.5f, float flipTime = 1.0f)
    {
        _contentSpacing = contentSpacing;
        ScreenPadding = screenPadding == default ? new Vector4(100f, 100f, 150f, 200f) : screenPadding;
        ScreenSpacing = screenSpacing;
        isAuto = autoPlay;
        isInstant = instant; 
        typingDelay = typeDelay;
        finalDelay = endDelay;
        flipDelay = flipTime;
    }

    public DialogConfig(DialogConfig dialogConfig)
    {
        _contentSpacing= dialogConfig._contentSpacing;
        ScreenPadding = new Vector4(dialogConfig.ScreenPadding.x, dialogConfig.ScreenPadding.y, dialogConfig.ScreenPadding.z, dialogConfig.ScreenPadding.w);
        ScreenSpacing = dialogConfig.ScreenSpacing;
        isAuto = dialogConfig.isAuto;
        isInstant = dialogConfig.isInstant;
        typingDelay = dialogConfig.typingDelay;
        finalDelay = dialogConfig.finalDelay;
        flipDelay = dialogConfig.flipDelay;
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
    private DialogConfig dialogSettings;

    private DialogueTree dialogueTree => DialogueTree.currentDialogue;
    public List<int> currentNodesList = new List<int>();
    private StoryPresenter storyPresenter = null;
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
        //nothing special...
    }
    void OnDialoguePaused(DialogueTree dlg)
    {
        
    }
    void OnDialogueFinished(DialogueTree dlg)
    {
        UIManager.instance.CloseUI<StoryPresenter>();
    }
    void OnSubtitlesRequest(SubtitlesRequestInfo info)
    {
        if(storyPresenter != null)
        {
            if (skip)
            {
                var skipSettings = new DialogConfig(dialogSettings);
                skipSettings.isAuto = true;
                skipSettings.isInstant = true;
                skipSettings.finalDelay = 0f;
                skipSettings.typingDelay = 0f;
                if (currentNodesList[currentNodesList.Count - 1] == dialogueTree.currentNode.ID)
                {
                    skip = false;
                    skipSettings.isAuto = false;
                    skipSettings.finalDelay = dialogSettings.finalDelay;
                    skipSettings.typingDelay = dialogSettings.typingDelay;

                }

                storyPresenter.ShowDialog(info, skipSettings);
            }
            else
            {
                if (storyPresenter.ShowDialog(info, dialogSettings))
                    currentNodesList.Clear();

                currentNodesList.Add(dialogueTree.currentNode.ID);
            }
        }
    }
    private void OnMultipleChoiceRequest(MultipleChoiceRequestInfo info)
    {

    }

    private readonly string prefabPath = "Dialogue/DialogueView";
    public DialogView GetOrCreateDialogueUIView(Transform parent)
    {
        var prefab = UIManager.instance.LoadUIPrefab(prefabPath);
        return (DialogView)UIManager.instance.GetOrCreateUIPoolView(prefabPath, prefab, parent);
    }
    public ObjectPool<PoolableUIView> GetDialogueUIPool()
    {
        return UIManager.instance.GetUIPool(prefabPath);
    }

    public void StartDialogueTree()
    {
        Debug.Log("Start DialogueTree: " + SerializedSystem.DeserializeDialogueTree(SerializedSystem.JsonPathTest2));
        storyPresenter = UIManager.instance.ShowUI<StoryPresenter>("Dialogue/Story", uiRoot, false);
    }
    public void MoveToCurrentStep(List<int> NodesInPage,bool fromBegin = false)
    {
        skip = true;

        currentNodesList = NodesInPage;

    }
}
