using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using NodeCanvas.DialogueTrees;

namespace Framework.UI
{
    public class StoryView : BaseView, IPointerClickHandler
    {
        private List<DialogView> _activeViews;

        protected override void Awake()
        {
            base.Awake();
            _activeViews = new List<DialogView>();
        }

        /// <summary>
        /// �����Ƿ�ҳ
        /// </summary>
        /// <param name="info"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool ShowDialogue(SubtitlesRequestInfo info, DialogConfig data)
        {
            var dialogView = DialogueManager.instance.GetOrCreateDialogueUIView(transform);

            var hasName = false;
            var nameContent = "";
            if (info.actor != null)
            {
                var actor = info.actor;
                nameContent = string.Format("<size={0}><color=#{1}>{2}</color></size>\n", 55, ColorUtility.ToHtmlStringRGBA(actor.dialogueColor), actor.name);
                hasName = true;
            }

            var isFlip = false;
            var anchorPos = new Vector2(data._screenPadding.x, -data._screenPadding.z);
            if (_activeViews.Count > 0)
            {
                var leftBottomPos = _activeViews[_activeViews.Count - 1].GetLeftBottomPos();
                Debug.Log("ShowDialogue："+leftBottomPos);
                anchorPos = new Vector2(data._screenPadding.x, -leftBottomPos.y - data._screenSpacing);
            }
            var textSize = dialogView.SetDialog(data._screenPadding.x, data._screenPadding.y, data._contentSpacing, data._fontSize, nameContent + info.statement.text);
            dialogView.GetComponent<RectTransform>().anchoredPosition = anchorPos;
            if ((anchorPos.y - textSize.y) <= (-Screen.height + data._screenPadding.z))
            {
                anchorPos = new Vector2(data._screenPadding.x, -data._screenPadding.z);
                dialogView.GetComponent<RectTransform>().anchoredPosition = anchorPos;
                isFlip = true;
            }

            if (isFlip)
            {
                var pool = DialogueManager.instance.GetDialogueUIPool();

                foreach (var view in _activeViews)
                    pool.Despawn(view);

                _activeViews.Clear();
            }
            _activeViews.Add(dialogView);

            //StartCoroutine(Internal_ShowDialog(dialogView,info, info.statement.text,nameContent,data._typingDelay,data._finalDelay,data._flipDelay,hasName,data._isInstant,data._isAuto,isFlip));
            CoroutineManager.instance.StartPersistentCoroutine(this, Internal_ShowDialog(dialogView, info, info.statement.text, nameContent, data._typingDelay, data._finalDelay, data._flipDelay, hasName, data._isInstant, data._isAuto, isFlip));

            return isFlip;
        }
        IEnumerator Internal_ShowDialog(DialogView dialogView, SubtitlesRequestInfo info, string statement, string nameContent, float typingDelay, float finalDelay, float flipDelay, bool hasName, bool isInstant, bool isAuto, bool isFlip)
        {
            if (isFlip)
                yield return new WaitForSeconds(flipDelay);

            dialogView.ShowDialog(statement, typingDelay, isInstant, nameContent, hasName);

            while (dialogView.IsTyping)
            {
                yield return null;

                if (!isAuto && anyKeyDown)
                {
                    dialogView.FinishTyping();
                    break;
                }
            }

            yield return null;

            if (isAuto)
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

        public bool ShowMultiChoices(MultipleChoiceRequestInfo info, DialogConfig data, bool isSkip = false, int index = -1)
        {
            var dialogView = DialogueManager.instance.GetOrCreateDialogueUIView(transform);


            var isFlip = false;
            var anchorPos = new Vector2(data._screenPadding.x, -data._screenPadding.z);
            if (_activeViews.Count > 0)
            {
                var leftBottomPos = _activeViews[_activeViews.Count - 1].GetLeftBottomPos();
                anchorPos = new Vector2(data._screenPadding.x, -leftBottomPos.y - data._screenSpacing);
            }

            var totalSize = dialogView.ShowMultiChoices(info, data._screenPadding.x, data._screenPadding.y, data._contentSpacing, data._choiceSpacing, data._fontSize);

            dialogView.GetComponent<RectTransform>().anchoredPosition = anchorPos;
            if ((anchorPos.y - totalSize.y) <= (-Screen.height + data._screenPadding.z))
            {
                anchorPos = new Vector2(data._screenPadding.x, -data._screenPadding.z);
                dialogView.GetComponent<RectTransform>().anchoredPosition = anchorPos;
                isFlip = true;
            }

            if (isFlip)
            {
                var pool = DialogueManager.instance.GetDialogueUIPool();

                foreach (var view in _activeViews)
                    pool.Despawn(view);

                _activeViews.Clear();
            }
            _activeViews.Add(dialogView);

            //StartCoroutine(Internal_ShowMultiChoices(dialogView,info,data._flipDelay, isFlip,isSkip, index));
            CoroutineManager.instance.StartPersistentCoroutine(this, Internal_ShowMultiChoices(dialogView, info, data._flipDelay, isFlip, isSkip, index));

            return isFlip;
        }
        IEnumerator Internal_ShowMultiChoices(DialogView view, MultipleChoiceRequestInfo info, float flipDelay, bool isFlip, bool isSkip, int index)
        {
            view.Hide();

            if (isFlip)
                yield return new WaitForSeconds(flipDelay);

            if (isSkip && index != -1)
            {

                yield return null;
                view.FinishingChoice(info, index);
            }


            view.Show();
        }

        private bool anyKeyDown;
        public void OnPointerClick(PointerEventData eventData)
        {
            //Debug.Log("GetPointer");
            anyKeyDown = true;
            //Debug.Log(anyKeyDown);
        }
        private void LateUpdate() => anyKeyDown = false;
        public override void Close()
        {
            DialogueManager.instance.ClearDialogueUIPool();

            base.Close();
        } 
    }
}