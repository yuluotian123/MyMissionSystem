using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Framework.UI;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using NodeCanvas.DialogueTrees;
using Unity.VisualScripting;
using System.Linq;

public class StoryView : BaseView, IPointerClickHandler
{
    [SerializeField]private Button _nextDialogButton;
    [SerializeField]private VerticalLayoutGroup _verticalLayoutGroup;

    private Dictionary<SubtitlesRequestInfo, DialogView> _dialogViews;
    private List<DialogView> _activeViews;

    protected override void Awake()
    {
        base.Awake();
        _activeViews = new List<DialogView>();
        _dialogViews = new Dictionary<SubtitlesRequestInfo, DialogView>();
    }

    private bool CheckDialogUIBornerOut(DialogView view)
    {
        LayoutRebuilder.ForceRebuildLayoutImmediate(this._rectTransform);
        Canvas.ForceUpdateCanvases();

        // 获取UI预制体的RectTransform
        RectTransform _rect = view.GetComponent<RectTransform>();
        Debug.Log(_rect.anchoredPosition);

        if (_rect.anchoredPosition.y <= (-Screen.height + _verticalLayoutGroup.padding.bottom))
            return true;

        return false;
    }

    public void ShowDialogue(SubtitlesRequestInfo info,DialogData data)
    {
        StartCoroutine(Internal_ShowDialog(info,data));
    }

    IEnumerator Internal_ShowDialog(SubtitlesRequestInfo info,DialogData data)
    {
        var dialogView = DialogueManager.instance.GetOrCreateDialogueUIView(this.transform);

        //识别字符功能，看是做在这里还是写在表里
        if (CheckDialogUIBornerOut(dialogView)/*||data.content.Substring(data.content.Length - 2) == "\\F"*/)
        {
            var pool = DialogueManager.instance.GetDialogueUIPool();
            foreach(var view in _activeViews)
            {
                pool.Despawn(view);
            }
            _activeViews.Clear();
            
            yield return new WaitForSeconds(DialogueManager.instance.flipDelay);
        }

        _activeViews.Add(dialogView);
        _dialogViews.Add(info, dialogView);

        dialogView.ShowDialog(data, DialogueManager.instance.typingDelay, DialogueManager.instance.isInstant);

        while (dialogView.IsTyping)
        {
            yield return null;

            if(!DialogueManager.instance.isAuto && anyKeyDown)
            {
                dialogView.FinishTyping();
                break;
            }
        }

        yield return null;

        if(DialogueManager.instance.isAuto)
            yield return new WaitForSeconds(DialogueManager.instance.finalDelay);
        else
        {
            while (!anyKeyDown)
            {
                yield return null;
            }
        }

        yield return null;

        info.Continue();
    }
    private bool anyKeyDown;
    public void OnPointerClick(PointerEventData eventData) => anyKeyDown = true;
    private void LateUpdate() => anyKeyDown = false;
}