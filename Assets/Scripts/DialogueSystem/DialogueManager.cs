using Framework.UI;
using NodeCanvas.DialogueTrees;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueManager : MonoSingleton<DialogueManager>
{
    [SerializeField]
    private DialogueTreeController dialogue;
    [SerializeField]
    private RectTransform uiRoot;

    [Header("延迟设定")]
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


    private StoryPresenter storyPresenter = null;

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
        Debug.Log("对话树启动");
    }

    void OnDialoguePaused(DialogueTree dlg)
    {
        
    }
    void OnDialogueFinished(DialogueTree dlg)
    {
        
    }
    void OnSubtitlesRequest(SubtitlesRequestInfo info)
    {
        Debug.Log("对话树进入台词");   
        if(storyPresenter != null)
        {
            storyPresenter.ShowDialog(info); 
        }
    }
    private void OnMultipleChoiceRequest(MultipleChoiceRequestInfo info)
    {

    }


    private readonly string prefabPath = "Dialogue/DialogueText";
    public DialogView GetOrCreateDialogueUIView(Transform parent)
    {
        var prefab = UIManager.instance.LoadUIPrefab(prefabPath);
        return (DialogView)UIManager.instance.GetOrCreateUIPoolView(prefabPath, prefab, parent);
    }
    public ObjectPool<PoolableUIView> GetDialogueUIPool()
    {
        return UIManager.instance.GetUIPool(prefabPath);
    }


    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            dialogue.StartDialogue();
            storyPresenter = UIManager.instance.ShowUI<StoryPresenter>("Dialogue/Story", uiRoot, false);
        }
    }
}
