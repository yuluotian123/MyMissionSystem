using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using NodeCanvas.DialogueTrees;
using System.Collections.Generic;

namespace Framework.UI
{

    public class DialogView : PoolableUIView
    {
        [Header("UI Components")]
        [SerializeField] private Transform _statementGroup;
        [SerializeField] private Text _contentText;
        [SerializeField] private Transform _optionalGroup;
        [SerializeField] private Button _choiceButton;

        private bool _isTyping;
        public bool IsTyping => _isTyping;

        public Dictionary<Button, int> _buttonsCache;
        private string _contentCache;

        private Transform _poolParent;

        public Vector2 SetDialog(float screenPaddingLeft, float screenPaddingRight, float textSpacing, float fontSize, string text)
        {
            _contentText.fontSize = (int)fontSize;
            _contentText.lineSpacing = textSpacing;

            var rect = _contentText.rectTransform;
            var textSize = CalculateTextSize(_contentText, text, Screen.width - (screenPaddingLeft + screenPaddingRight));
            rect.sizeDelta = new Vector2(rect.sizeDelta.x, textSize.y);

            return rect.sizeDelta;
        }
        public void ShowDialog(string commentContent, float speed, bool instant = false, string nameContent = "", bool hasCharacterName = false)
        {
            _statementGroup.gameObject.SetActive(true);
            _optionalGroup.gameObject.SetActive(false);

            //StopAllCoroutines();

            CoroutineManager.instance.StopPersistentCoroutineAll(this);

            _contentCache = nameContent + commentContent;

            if (instant)
            {
                _contentText.text = _contentCache;
                _isTyping = false;
            }
            else
            {
                //StartCoroutine(TypeText(commentContent, speed,nameContent,hasCharacterName));
                CoroutineManager.instance.StartPersistentCoroutine(this, TypeText(commentContent, speed, nameContent, hasCharacterName));
            }
        }
        public void FinishTyping()
        {
            if (_isTyping)
            {
                //StopAllCoroutines();
                CoroutineManager.instance.StopPersistentCoroutineAll(this);


                _contentText.text = _contentCache;
                _isTyping = false;
            }
        }
        private IEnumerator TypeText(string content, float speed, string nameContent = "", bool hasCharacterName = false)
        {
            _isTyping = true;
            _contentText.text = "";

            if (hasCharacterName)
            {
                _contentText.text = nameContent;
            }

            yield return new WaitForSeconds(speed);

            foreach (char c in content)
            {
                _contentText.text += c;

                yield return new WaitForSeconds(speed);
            }

            _isTyping = false;
        }

        public Vector2 ShowMultiChoices(MultipleChoiceRequestInfo info, float screenPaddingLeft, float screenPaddingRight, float contentSpacing, float choiceSpacing, float fontSize)
        {
            _buttonsCache = new Dictionary<Button, int>();
            float height = 0;
            var preferWidth = Screen.width - screenPaddingRight - screenPaddingLeft;

            foreach (KeyValuePair<IStatement, int> pair in info.options)
            {
                var btn = Instantiate(_choiceButton);
                btn.gameObject.SetActive(true);
                btn.transform.SetParent(_optionalGroup.transform, false);
                var buttonText = btn.GetComponentInChildren<Text>();
                buttonText.lineSpacing = contentSpacing;
                buttonText.fontSize = (int)fontSize;
                buttonText.text = pair.Key.text;

                var textSize = CalculateTextSize(buttonText, buttonText.text, preferWidth, -1, false);
                var rect = btn.GetComponent<RectTransform>();

                rect.sizeDelta = textSize;
                rect.anchoredPosition = new Vector2(0, height);
                height -= textSize.y + choiceSpacing;

                _buttonsCache.Add(btn, pair.Value);
                btn.onClick.AddListener(() => { FinishingChoice(info, _buttonsCache[btn]); });
            }

            return new Vector2(preferWidth, -(height + choiceSpacing));
        }
        public void FinishingChoice(MultipleChoiceRequestInfo info, int index)
        {
            foreach (var tempBtn in _buttonsCache.Keys)
            {
                tempBtn.interactable = false;
                tempBtn.onClick.RemoveAllListeners();
                if (_buttonsCache[tempBtn] == index)
                    tempBtn.image.color = Color.red;
            }
            info.SelectOption(index);
        }


        public Vector2 GetLeftBottomPos()
        {
            // 获取父Canvas
            Canvas parentCanvas = GetComponentInParent<Canvas>();
            if (parentCanvas == null) return Vector2.zero;

            // 获取Canvas的RectTransform
            RectTransform canvasRectTransform = parentCanvas.GetComponent<RectTransform>();

            // 获取所有子物体的RectTransform（包括自身）
            RectTransform[] allRectTransforms = GetComponentsInChildren<RectTransform>();

            // 初始化最小坐标值
            Vector2 minPosition = new Vector2(float.MaxValue, float.MaxValue);

            // 遍历所有RectTransform
            foreach (RectTransform rectTransform in allRectTransforms)
            {
                // 获取当前RectTransform的四个角的世界坐标
                Vector3[] corners = new Vector3[4];
                rectTransform.GetWorldCorners(corners);

                // 转换每个角到Canvas坐标
                foreach (Vector3 worldCorner in corners)
                {
                    Vector2 canvasPos;
                    if (RectTransformUtility.ScreenPointToLocalPointInRectangle(
                        canvasRectTransform,
                        RectTransformUtility.WorldToScreenPoint(null, worldCorner),
                        null,
                        out canvasPos))
                    {
                        minPosition.x = Mathf.Min(minPosition.x, canvasPos.x);
                        minPosition.y = Mathf.Min(minPosition.y, canvasPos.y);
                    }
                }
            }

            // 获取Canvas的尺寸
            Vector2 canvasSize = canvasRectTransform.rect.size;

            // 转换坐标系：从中心点为原点转换为左上角为原点
            Vector2 leftTopPos = new Vector2(
                minPosition.x + canvasSize.x / 2,  // 将x从中心点转换为从左边开始
                -minPosition.y + canvasSize.y / 2  // 将y从中心点转换为从上边开始，并翻转方向
            );

            return leftTopPos;
        }
        private Vector2 CalculateTextSize(Text contentText, string text, float preferWidth = -1, float preferHeight = -1, bool isTemporary = true)
        {
            if (contentText == null) return Vector2.zero;

            // 保存当前文本和设置
            string originalText = "";
            bool originalEnabled = contentText.enabled;

            var rect = contentText.rectTransform;
            rect.sizeDelta = new Vector2(preferWidth == -1 ? rect.sizeDelta.x : preferWidth, preferHeight == -1 ? rect.sizeDelta.y : preferHeight);

            try
            {
                // 确保Text组件是启用的，这样才能正确计算
                contentText.enabled = true;

                // 临时设置要计算的文本
                contentText.text = text;

                // 强制刷新布局
                Canvas.ForceUpdateCanvases();
                LayoutRebuilder.ForceRebuildLayoutImmediate(contentText.rectTransform);

                // 使用preferredWidth和preferredHeight来获取准确的大小
                Vector2 size = new Vector2(
                    contentText.preferredWidth,
                    contentText.preferredHeight
                );

                // 如果size还是0，尝试使用TextGenerator
                if (size.x == 0 || size.y == 0)
                {
                    TextGenerator textGen = new TextGenerator();
                    Vector2 extents = contentText.rectTransform.rect.size;
                    var settings = contentText.GetGenerationSettings(extents);
                    textGen.Populate(text, settings);

                    size = new Vector2(
                        textGen.GetPreferredWidth(text, settings),
                        textGen.GetPreferredHeight(text, settings)
                    );
                }

                return size;
            }
            finally
            {
                // 恢复原始状态
                if (isTemporary)
                    contentText.text = originalText;

                contentText.enabled = originalEnabled;
            }
        }


        protected override void ResetState()
        {
            _isTyping = false;
            StopAllCoroutines();
        }
        public override void OnSpawn()
        {
            base.OnSpawn();
            var storyView = GetComponentInParent<StoryView>();
            _poolParent = this.transform.parent;

            if (storyView != null)
            {
                this.transform.SetParent(storyView.transform);
            }
        }
        public override void OnDespawn()
        {
            base.OnDespawn();
            this.transform.SetParent(_poolParent);
        }
    }
}