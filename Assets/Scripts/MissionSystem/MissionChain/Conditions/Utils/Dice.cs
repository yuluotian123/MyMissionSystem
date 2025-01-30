using ParadoxNotion.Design;
using UnityEngine;


namespace YLT.MissionSystem
{
    [Name("Dice"), Description("Roll a dice with given probability")]
    public class Dice : ConditionBase
    {
        [SerializeField] public float probability = 0.5f;

        public override bool IsConditionMet => Random.value < probability;

#if UNITY_EDITOR
        public override string Summary =>"随机数小于" + probability.ToString();

        protected override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            probability = UnityEditor.EditorGUILayout.Slider("Probability", probability, 0, 1);
        }
#endif
    }
}