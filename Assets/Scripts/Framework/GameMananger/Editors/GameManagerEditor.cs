#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System.IO;
using System.Linq;

/// <summary>
/// GameManager 自定义 Inspector：输入场景名称并一键切换
/// - 在运行时：调用 GameManager.LoadSceneByName(sceneNameInput)
/// - 在编辑器：直接打开匹配的场景（通过 Build Settings 映射名称到路径）
/// </summary>
[CustomEditor(typeof(GameManager))]
public class GameManagerEditor : Editor
{
    private string sceneNameInput = "";

    public override void OnInspectorGUI()
    {
        // 绘制原有 Inspector
        base.OnInspectorGUI();

        EditorGUILayout.Space(10);
        EditorGUILayout.LabelField("场景切换工具", EditorStyles.boldLabel);

        // 输入场景名称（不含扩展名）
        sceneNameInput = EditorGUILayout.TextField("场景名称", sceneNameInput);

        // 校验：在 Build Settings 中查找是否存在匹配名称的场景
        var buildScenes = EditorBuildSettings.scenes;
        var matched = buildScenes.FirstOrDefault(s =>
        {
            var name = Path.GetFileNameWithoutExtension(s.path);
            return string.Equals(name, sceneNameInput, System.StringComparison.OrdinalIgnoreCase);
        });

        // 提示信息
        if (buildScenes.Length == 0)
        {
            EditorGUILayout.HelpBox("Build Settings 中没有任何场景。请将场景加入 File > Build Settings。", MessageType.Warning);
        }
        else if (string.IsNullOrEmpty(sceneNameInput))
        {
            EditorGUILayout.HelpBox("请输入场景名称（不含扩展名）。", MessageType.Info);
        }
        else if (matched == null)
        {
            EditorGUILayout.HelpBox($"未在 Build Settings 找到名为 \"{sceneNameInput}\" 的场景。", MessageType.Warning);
        }
        else if (!matched.enabled)
        {
            EditorGUILayout.HelpBox($"场景 \"{sceneNameInput}\" 在 Build Settings 中未启用。", MessageType.Warning);
        }

        EditorGUILayout.Space(4);

        using (new EditorGUI.DisabledScope(string.IsNullOrEmpty(sceneNameInput)))
        {
            var buttonText = EditorApplication.isPlaying ? "运行中切换到该场景" : "在编辑器中打开该场景";
            if (GUILayout.Button(buttonText, GUILayout.Height(28)))
            {
                if (EditorApplication.isPlaying)
                {
                    // 运行时：调用 GameManager 的加载逻辑
                    var gm = target as GameManager;
                    if (gm != null)
                    {
                        gm.LoadSceneByName(sceneNameInput);
                    }
                    else
                    {
                        Debug.LogError("GameManager 目标无效。");
                    }
                }
                else
                {
                    // 编辑器：打开场景（通过 Build Settings 路径）
                    if (matched != null)
                    {
                        if (EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo())
                        {
                            EditorSceneManager.OpenScene(matched.path);
                        }
                    }
                    else
                    {
                        EditorUtility.DisplayDialog("未找到场景",
                            $"未在 Build Settings 找到名为 \"{sceneNameInput}\" 的场景。\n请确保该场景已加入 Build Settings。",
                            "确定");
                    }
                }
            }
        }

        // 可选增强：列出 Build Settings 中的场景，帮助用户确认名称
        if (buildScenes.Length > 0)
        {
            EditorGUILayout.Space(6);
            EditorGUILayout.LabelField("已加入 Build Settings 的场景：", EditorStyles.miniBoldLabel);
            foreach (var s in buildScenes)
            {
                var name = Path.GetFileNameWithoutExtension(s.path);
                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField($"- {name}", GUILayout.ExpandWidth(true));
                    if (GUILayout.Button("填入名称", GUILayout.Width(70)))
                    {
                        sceneNameInput = name;
                    }
                }
            }
        }
    }
}
#endif
