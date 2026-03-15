///////////////////////////////////
//// This is a generated file. ////
////     Do not modify it.     ////
///////////////////////////////////

using System;
using System.Collections.Generic;

namespace GAS.Runtime
{
    public class AS_Character : AttributeSet
    {
        #region ATK

        /// <summary>
        /// 基础攻击力
        /// </summary>
        public AttributeBase ATK { get; } = new ("AS_Character", "ATK", 0f, CalculateMode.Stacking, (SupportedOperation)31, float.MinValue, float.MaxValue);

        public void InitATK(float value)
        {
            ATK.SetBaseValue(value);
            ATK.SetCurrentValue(value);
        }

        public void SetCurrentATK(float value)
        {
            ATK.SetCurrentValue(value);
        }

        public void SetBaseATK(float value)
        {
            ATK.SetBaseValue(value);
        }

        public void SetMinATK(float value)
        {
            ATK.SetMinValue(value);
        }

        public void SetMaxATK(float value)
        {
            ATK.SetMaxValue(value);
        }

        public void SetMinMaxATK(float min, float max)
        {
            ATK.SetMinMaxValue(min, max);
        }

        #endregion ATK

        #region HP

        /// <summary>
        /// 生命值
        /// </summary>
        public AttributeBase HP { get; } = new ("AS_Character", "HP", 0f, CalculateMode.Stacking, (SupportedOperation)31, float.MinValue, float.MaxValue);

        public void InitHP(float value)
        {
            HP.SetBaseValue(value);
            HP.SetCurrentValue(value);
        }

        public void SetCurrentHP(float value)
        {
            HP.SetCurrentValue(value);
        }

        public void SetBaseHP(float value)
        {
            HP.SetBaseValue(value);
        }

        public void SetMinHP(float value)
        {
            HP.SetMinValue(value);
        }

        public void SetMaxHP(float value)
        {
            HP.SetMaxValue(value);
        }

        public void SetMinMaxHP(float min, float max)
        {
            HP.SetMinMaxValue(min, max);
        }

        #endregion HP

        #region Stamina

        /// <summary>
        /// 体力
        /// </summary>
        public AttributeBase Stamina { get; } = new ("AS_Character", "Stamina", 0f, CalculateMode.Stacking, (SupportedOperation)31, float.MinValue, float.MaxValue);

        public void InitStamina(float value)
        {
            Stamina.SetBaseValue(value);
            Stamina.SetCurrentValue(value);
        }

        public void SetCurrentStamina(float value)
        {
            Stamina.SetCurrentValue(value);
        }

        public void SetBaseStamina(float value)
        {
            Stamina.SetBaseValue(value);
        }

        public void SetMinStamina(float value)
        {
            Stamina.SetMinValue(value);
        }

        public void SetMaxStamina(float value)
        {
            Stamina.SetMaxValue(value);
        }

        public void SetMinMaxStamina(float min, float max)
        {
            Stamina.SetMinMaxValue(min, max);
        }

        #endregion Stamina

        public override AttributeBase this[string key]
        {
            get
            {
                switch (key)
                {
                    case "HP":
                        return HP;
                    case "ATK":
                        return ATK;
                    case "Stamina":
                        return Stamina;
                }

                return null;
            }
        }

        public override string[] AttributeNames { get; } =
        {
            "HP",
            "ATK",
            "Stamina",
        };

        public override void SetOwner(AbilitySystemComponent owner)
        {
            _owner = owner;
            HP.SetOwner(owner);
            ATK.SetOwner(owner);
            Stamina.SetOwner(owner);
        }

        public static class Lookup
        {
            public const string HP = "AS_Character.HP";
            public const string ATK = "AS_Character.ATK";
            public const string Stamina = "AS_Character.Stamina";
        }
    }

    public static class GAttrSetLib
    {
        public static readonly Dictionary<string, Type> AttrSetTypeDict = new Dictionary<string, Type>()
        {
            { "Character", typeof(AS_Character) },
        };

        public static readonly Dictionary<Type, string> TypeToName = new Dictionary<Type, string>
        {
            { typeof(AS_Character), nameof(AS_Character) },
        };

        public static List<string> AttributeFullNames = new List<string>()
        {
            "AS_Character.HP",
            "AS_Character.ATK",
            "AS_Character.Stamina",
        };
    }
}