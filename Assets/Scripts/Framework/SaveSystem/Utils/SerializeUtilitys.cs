
// Serialization.cs
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;


public partial class SerializedSystem
{
    public static readonly string GraphPath = "Graph/";
    public static readonly string MissionGraphPath = "Graph/Missions/";
    public static readonly string DialogueTreePath = "Graph/DialogueTrees/";
    public static readonly string BehaviorTreePath = "Graph/BehaviorTrees/";

    //任务系统的测试存档
    public static readonly string JsonPathTest = Application.streamingAssetsPath + "/JsonTest.json";
    //对话系统的测试存档
    public static readonly string JsonPathTest2 = Application.streamingAssetsPath + "/JsonTest2.json";

    private static void SaveJson<T>(T data, string jsonPath)
    {
        StreamWriter writer;
        //�������û�ж�Ӧ��json �ļ������´���
        if (!File.Exists(jsonPath))
        {
            writer = File.CreateText(jsonPath);
        }
        else
        {
            File.Delete(jsonPath);
            writer = File.CreateText(jsonPath);
        }

        string json = JsonUtility.ToJson(data, true);
        writer.Flush();
        writer.Dispose();
        writer.Close();

        File.WriteAllText(jsonPath, json);
    }

    private static string ReadJson(string jsonPath)
    {
        if (!File.Exists(jsonPath))
        {
            return null;
        }

        return File.ReadAllText(jsonPath);
    }
}

// List<T>
[Serializable]
public class Serialization<T>
{
    [SerializeField]
    List<T> target;
    public List<T> ToList() { return target; }

    public Serialization(List<T> target)
    {
        this.target = target;
    }
}

// Dictionary<TKey, TValue>
[Serializable]
public class Serialization<TKey, TValue> : ISerializationCallbackReceiver
{
    [SerializeField]
    List<TKey> keys;
    [SerializeField]
    List<TValue> values;

    Dictionary<TKey, TValue> target;
    public Dictionary<TKey, TValue> ToDictionary() { return target; }

    public Serialization(Dictionary<TKey, TValue> target)
    {
        this.target = target;
    }

    public void OnBeforeSerialize()
    {
        keys = new List<TKey>(target.Keys);
        values = new List<TValue>(target.Values);
    }

    public void OnAfterDeserialize()
    {
        var count = Math.Min(keys.Count, values.Count);
        target = new Dictionary<TKey, TValue>(count);
        for (var i = 0; i < count; ++i)
        {
            target.Add(keys[i], values[i]);
        }
    }
}

