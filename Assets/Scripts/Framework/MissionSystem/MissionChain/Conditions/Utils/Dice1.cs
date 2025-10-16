using ParadoxNotion.Design;
using UnityEngine;


namespace YLT.MissionSystem
{
    [Name("Dice1"), Description("Roll a dice with given probability")]
    public class Dice1 : ConditionBase
    {
        [SerializeField] public float probability = 0.5f;

        public override bool IsConditionMet => Random.value >= probability;

#if UNITY_EDITOR
        public override string Summary =>"随机数大于等于" + probability.ToString();

        protected override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            probability = UnityEditor.EditorGUILayout.Slider("Probability", probability, 0, 1);
        }
#endif
    }
}