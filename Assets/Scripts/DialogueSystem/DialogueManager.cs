using Framework.UI;
using NodeCanvas.DialogueTrees;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class DialogData 
{
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

    public DialogData(float contentSpacing = 1f, Vector4 screenPadding = default, float screenSpacing = 60f, 
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
}


public class DialogueManager : MonoSingleton<DialogueManager>
{
    [SerializeField]
    private DialogueTreeController dialogue;
    [SerializeField]
    private RectTransform uiRoot;
    [SerializeField]
    private DialogData dialogSettings;

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
    }

    void OnDialoguePaused(DialogueTree dlg)
    {
        
    }
    void OnDialogueFinished(DialogueTree dlg)
    {
        
    }
    void OnSubtitlesRequest(SubtitlesRequestInfo info)
    {
        if(storyPresenter != null)
        {
            storyPresenter.ShowDialog(info, dialogSettings);
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
