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
    public StoryPresenter(StoryView view) : base(view)
    {
    }

    public override void Initialize()
    {
        base.Initialize();
    }

    public bool ShowDialog(SubtitlesRequestInfo info,DialogConfig data)
    {
        return View.ShowDialogue(info,data);
    }

    public override void Close()
    {
        base.Close();
    }
}