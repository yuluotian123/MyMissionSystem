using Framework.UI;
using NodeCanvas.DialogueTrees;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class DialogData 
{
    [Header("Layout�趨")]
    [SerializeField]
    public float _contentSpacing = 1f;

    [Header("�ӳ��趨")]
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
        Debug.Log("�Ի�������");
    }

    void OnDialoguePaused(DialogueTree dlg)
    {
        
    }
    void OnDialogueFinished(DialogueTree dlg)
    {
        
    }
    void OnSubtitlesRequest(SubtitlesRequestInfo info)
    {
        Debug.Log("�Ի�������̨��");   
        if(storyPresenter != null)
        {
            storyPresenter.ShowDialog(info, dialogSettings);
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
