using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Framework.UI;
using NodeCanvas.DialogueTrees;

public class DialogView : PoolableUIView
{
    [Header("UI Components")]
    [SerializeField] private Text _contentText;

    private bool _isTyping;
    public bool IsTyping => _isTyping;
    private string content;

    private Transform poolParent;

    protected override void Awake()
    {
        base.Awake();
    }

    public Vector2 SetDialogRect(float contentSpacing,float screenPaddingLeft,float screenPaddingRight,string text)
    {
        _contentText.lineSpacing = contentSpacing;

        var rect = _contentText.rectTransform;
        rect.sizeDelta = new Vector2(Screen.width - (screenPaddingLeft + screenPaddingLeft), 0);
        var textSize = CalculateTextSize(text);
        rect.sizeDelta = new Vector2(rect.sizeDelta.x, textSize.y);
        Debug.Log(rect.sizeDelta);

        return rect.sizeDelta;
    }
    /// <summary>
    /// 计算指定文本在当前Text组件设置下的大小
    /// </summary>
    /// <param name="text">要计算的文本内容</param>
    /// <returns>返回文本的大小 (width, height)</returns>
    private Vector2 CalculateTextSize(string text)
    {
        if (_contentText == null) return Vector2.zero;

        // 保存当前文本和设置
        string originalText = _contentText.text;
        bool originalEnabled = _contentText.enabled;
        
        try
        {
            // 确保Text组件是启用的，这样才能正确计算
            _contentText.enabled = true;
            
            // 临时设置要计算的文本
            _contentText.text = text;
            
            // 强制刷新布局
            Canvas.ForceUpdateCanvases();
            LayoutRebuilder.ForceRebuildLayoutImmediate(_contentText.rectTransform);
            
            // 使用preferredWidth和preferredHeight来获取准确的大小
            Vector2 size = new Vector2(
                _contentText.preferredWidth,
                _contentText.preferredHeight
            );

            // 如果size还是0，尝试使用TextGenerator
            if (size.x == 0 || size.y == 0)
            {
                TextGenerator textGen = new TextGenerator();
                Vector2 extents = _contentText.rectTransform.rect.size;
                var settings = _contentText.GetGenerationSettings(extents);
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
            _contentText.text = originalText;
            _contentText.enabled = originalEnabled;
        }
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

    public void ShowDialog(SubtitlesRequestInfo info,float contentSpacing, float speed, bool instant = false)
    {
        StopAllCoroutines();

        content = info.statement.text;

        if (instant)
        {
            _contentText.text = content;
            _isTyping = false;
        }
        else
        {
            StartCoroutine(TypeText(content, speed));
        }
    }
    private IEnumerator TypeText(string content,float speed )
    {
        _isTyping = true;
        _contentText.text = "";

        foreach (char c in content)
        {
            _contentText.text += c;

            yield return new WaitForSeconds(speed);
        }

        _isTyping = false;
    }

    public void FinishTyping()
    {
        if (_isTyping)
        {
            StopAllCoroutines();

            _contentText.text = content;
            _isTyping = false;
        }
    }


    protected override void ResetState()
    {
        _contentText.text = "";
        _isTyping = false;
        StopAllCoroutines();
    }
    public override void OnSpawn()
    {
        base.OnSpawn();
        var storyView = GetComponentInParent<StoryView>();
        poolParent = this.transform.parent;

        if (storyView != null)
        {
            this.transform.SetParent(storyView.transform);
        }
    }
    public override void OnDespawn()
    {
        base.OnDespawn();
        this.transform.SetParent(poolParent);
    }
}