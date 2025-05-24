using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.EventSystems;
using Framework.UI;
using NodeCanvas.DialogueTrees;

public class StoryPresenter : BasePresenter<StoryView>
{
    private List<DialogData> _dialogDatas;

    public StoryPresenter(StoryView view) : base(view)
    {
        _dialogDatas = new List<DialogData>();
    }

    public override void Initialize()
    {
        base.Initialize();
    }

    public void ShowDialog(SubtitlesRequestInfo info)
    {
        var text = info.statement.text;
        var audio = info.statement.audio;
        var actor = info.actor;

        var dialogData = new DialogData(actor.name, text, actor.portraitSprite, audio);
        _dialogDatas.Add(dialogData);

        View.ShowDialogue(info,dialogData);
    }

    public override void Close()
    {
        base.Close();
    }
}