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

    public void ShowDialog(SubtitlesRequestInfo info,float contentSpacing, float speed, bool instant = false)
    {
        StopAllCoroutines();

        _contentText.lineSpacing = contentSpacing;
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