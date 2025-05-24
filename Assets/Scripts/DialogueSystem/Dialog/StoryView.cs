using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Framework.UI;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using NodeCanvas.DialogueTrees;
using Unity.VisualScripting;
using System.Linq;
using static System.Net.Mime.MediaTypeNames;

public class StoryView : BaseView, IPointerClickHandler
{
    private Dictionary<SubtitlesRequestInfo, DialogView> _dialogViews;
    private List<DialogView> _activeViews;

    protected override void Awake()
    {
        base.Awake();
        _activeViews = new List<DialogView>();
        _dialogViews = new Dictionary<SubtitlesRequestInfo, DialogView>();
    }

    private bool CheckAndSetUIRectTransform(DialogView view,DialogData data,SubtitlesRequestInfo info)
    {
        var anchorPos = new Vector2(0, 0);
        if(_activeViews.Count == 0)
            anchorPos = new Vector2(data.ScreenPadding.x, -data.ScreenPadding.z);
        else
        {
            var leftBottomPos = _activeViews[_activeViews.Count - 1].GetLeftBottomPos();
            anchorPos = new Vector2(data.ScreenPadding.x ,- leftBottomPos.y - data.ScreenSpacing);
        }

        var textSize = view.SetDialogRect(data._contentSpacing,data.ScreenPadding.x,data.ScreenPadding.y, info.statement.text);
        view.GetComponent<RectTransform>().anchoredPosition = anchorPos;

        if ((anchorPos.y - textSize.y) <= (-Screen.height + data.ScreenPadding.z))
        {
            anchorPos = new Vector2(data.ScreenPadding.x, -data.ScreenPadding.z);
            view.GetComponent<RectTransform>().anchoredPosition = anchorPos;
            return true;
        }

        return false;
    }

    public void ShowDialogue(SubtitlesRequestInfo info,DialogData data)
    {
        StartCoroutine(Internal_ShowDialog(info, data));
    }

    IEnumerator Internal_ShowDialog(SubtitlesRequestInfo info,DialogData data)
    {
        var dialogView = DialogueManager.instance.GetOrCreateDialogueUIView(this.transform);

        //识别字符功能，看是做在这里还是写在表里
        if (CheckAndSetUIRectTransform(dialogView,data,info))
        {
            var pool = DialogueManager.instance.GetDialogueUIPool();
            foreach(var view in _activeViews)
            {
                pool.Despawn(view);
            }
            _activeViews.Clear();
            
            yield return new WaitForSeconds(data.flipDelay);
        }

        _activeViews.Add(dialogView);
        _dialogViews.Add(info, dialogView);

        dialogView.ShowDialog(info, data._contentSpacing, data.typingDelay, data.isInstant);

        while (dialogView.IsTyping)
        {
            yield return null;

            if(!data.isAuto && anyKeyDown)
            {
                dialogView.FinishTyping();
                break;
            }
        }

        yield return null;

        if(data.isAuto)
            yield return new WaitForSeconds(data.finalDelay);
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