using UnityEngine;
using System.Collections;
using Framework.UI;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using NodeCanvas.DialogueTrees;

public class StoryView : BaseView, IPointerClickHandler
{
    private List<DialogView> _activeViews;

    protected override void Awake()
    {
        base.Awake();
        _activeViews = new List<DialogView>();
    }

    public override void Close()
    {
        DialogueManager.instance.GetDialogueUIPool().Clear();
        base.Close();
    }

    private bool CheckAndSetUIRectTransform(DialogView view,DialogConfig data,string contentText)
    {
        var anchorPos = new Vector2(data.ScreenPadding.x, -data.ScreenPadding.z);
        if (_activeViews.Count > 0)
        {
            var leftBottomPos = _activeViews[_activeViews.Count - 1].GetLeftBottomPos();
            anchorPos = new Vector2(data.ScreenPadding.x ,- leftBottomPos.y - data.ScreenSpacing);
        }

        var textSize = view.SetDialogRect(data._contentSpacing,data.ScreenPadding.x,data.ScreenPadding.y, contentText);
        view.GetComponent<RectTransform>().anchoredPosition = anchorPos;

        if ((anchorPos.y - textSize.y) <= (-Screen.height + data.ScreenPadding.z))
        {
            anchorPos = new Vector2(data.ScreenPadding.x, -data.ScreenPadding.z);
            view.GetComponent<RectTransform>().anchoredPosition = anchorPos;
            return true;
        }

        return false;
    }

    /// <summary>
    /// 返回是否翻页
    /// </summary>
    /// <param name="info"></param>
    /// <param name="data"></param>
    /// <returns></returns>
    public bool ShowDialogue(SubtitlesRequestInfo info,DialogConfig data)
    {
        //读取名字信息
        var hasName = false;
        var nameContent = "";
        if (info.actor != null)
        {
            var actor = info.actor;
            nameContent = string.Format("<size={0}><color=#{1}>{2}</color></size>\n", 55, UnityEngine.ColorUtility.ToHtmlStringRGBA(actor.dialogueColor), actor.name);
            hasName = true;
        }

        var dialogView = DialogueManager.instance.GetOrCreateDialogueUIView(this.transform);
        var isFlip = false;

        //设置当前dialogView的大小和位置，如果满一页则翻页
        if (CheckAndSetUIRectTransform(dialogView, data, nameContent + info.statement.text))
        {
            var pool = DialogueManager.instance.GetDialogueUIPool();

            foreach (var view in _activeViews)
                pool.Despawn(view);

            _activeViews.Clear();
            isFlip = true;
        }
        _activeViews.Add(dialogView);

        StartCoroutine(Internal_ShowDialog(dialogView,info, info.statement.text,nameContent,data.typingDelay,data.finalDelay,data.flipDelay,hasName,data.isInstant,data.isAuto,isFlip));

        return isFlip;
    }
    IEnumerator Internal_ShowDialog(DialogView dialogView,SubtitlesRequestInfo info, string statement,string nameContent,float typingDelay,float finalDelay,float flipDelay,bool hasName,bool isInstant,bool isAuto,bool isFlip)
    {

        if(isFlip)
            yield return new WaitForSeconds(flipDelay);

        //显示dialog对应页面
        dialogView.ShowDialog(statement, typingDelay, isInstant,nameContent,hasName);

        while (dialogView.IsTyping)
        {
            yield return null;

            if(!isAuto && anyKeyDown)
            {
                dialogView.FinishTyping();
                break;
            }
        }

        yield return null;

        if(isAuto)
            yield return new WaitForSeconds(finalDelay);
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