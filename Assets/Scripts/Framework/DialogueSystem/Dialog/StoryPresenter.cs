using NodeCanvas.DialogueTrees;


namespace Framework.UI
{
    public class StoryPresenter : BasePresenter<StoryView>
    {
        public StoryPresenter(StoryView view) : base(view)
        {
        }

        public override void Initialize()
        {
            base.Initialize();
        }

        public bool ShowMultiChoices(MultipleChoiceRequestInfo info, DialogConfig data, bool isSkip, int index)
        {
            return View.ShowMultiChoices(info, data, isSkip, index);
        }

        public bool ShowDialog(SubtitlesRequestInfo info, DialogConfig data)
        {
            return View.ShowDialogue(info, data);
        }


        public override void Close()
        {
            base.Close();
        }
    }
}