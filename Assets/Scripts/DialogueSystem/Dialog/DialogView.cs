using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Framework.UI;

public class DialogView : PoolableUIView
{
    [Header("UI Components")]
    [SerializeField] private Text _contentText;

    [Header("Layout Settings")]
    [SerializeField] private float _contentSpacing = 1f;

    private bool _isTyping;
    private DialogData _dialogData;
    public bool IsTyping => _isTyping;

    private Transform poolParent;

    protected override void Awake()
    {
        base.Awake();

        _contentText.lineSpacing = _contentSpacing;
    }

    public void ShowDialog(DialogData data, float speed, bool instant = false)
    {
        StopAllCoroutines();

        _dialogData = data;

        if (instant)
        {
            _contentText.text = data.content;
            _isTyping = false;
        }
        else
        {
            StartCoroutine(TypeText(data.content, speed));
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

            _contentText.text = _dialogData.content;
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