using UnityEngine;
using UnityEditor;
using System.IO;

public class JsonFilesCleaner : EditorWindow
{
    private string jsonPath = Application.streamingAssetsPath; // 默认JSON文件路径
    private bool includeSubfolders = true; // 是否包含子文件夹
    private Vector2 scrollPosition;
    private string[] foundFiles = new string[0];
    private bool showPreview = false;

    [MenuItem("Tools/JSON Files Cleaner")]
    static void Init()
    {
        JsonFilesCleaner window = (JsonFilesCleaner)EditorWindow.GetWindow(typeof(JsonFilesCleaner));
        window.titleContent = new GUIContent("JSON清理工具");
        window.Show();
    }

    void OnGUI()
    {
        EditorGUILayout.BeginVertical();

        // 路径设置
        EditorGUILayout.LabelField("JSON文件路径设置", EditorStyles.boldLabel);
        EditorGUILayout.BeginHorizontal();
        jsonPath = EditorGUILayout.TextField("路径:", jsonPath);
        if (GUILayout.Button("浏览", GUILayout.Width(60)))
        {
            string path = EditorUtility.OpenFolderPanel("选择JSON文件夹", jsonPath, "");
            if (!string.IsNullOrEmpty(path))
            {
                // 转换为相对路径
                if (path.StartsWith(Application.dataPath))
                {
                    jsonPath = "Assets" + path.Substring(Application.dataPath.Length);
                }
            }
        }
        EditorGUILayout.EndHorizontal();

        // 选项设置
        includeSubfolders = EditorGUILayout.Toggle("包含子文件夹", includeSubfolders);

        EditorGUILayout.Space();

        // 预览按钮
        if (GUILayout.Button("预览将删除的文件"))
        {
            FindJsonFiles();
            showPreview = true;
        }

        // 显示预览
        if (showPreview && foundFiles.Length > 0)
        {
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("将删除以下文件:", EditorStyles.boldLabel);
            
            scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition, GUILayout.Height(200));
            foreach (string file in foundFiles)
            {
                EditorGUILayout.LabelField(file);
            }
            EditorGUILayout.EndScrollView();

            EditorGUILayout.Space();
            EditorGUILayout.HelpBox($"将删除 {foundFiles.Length} 个JSON文件", MessageType.Warning);
        }

        // 删除按钮
        GUI.backgroundColor = Color.red;
        EditorGUI.BeginDisabledGroup(foundFiles.Length == 0);
        if (GUILayout.Button("删除所有JSON文件"))
        {
            if (EditorUtility.DisplayDialog("确认删除",
                $"确定要删除 {foundFiles.Length} 个JSON文件吗？\n此操作不可撤销！",
                "确定删除",
                "取消"))
            {
                DeleteJsonFiles();
            }
        }
        EditorGUI.EndDisabledGroup();
        GUI.backgroundColor = Color.white;

        EditorGUILayout.EndVertical();
    }

    private void FindJsonFiles()
    {
        if (!Directory.Exists(jsonPath))
        {
            EditorUtility.DisplayDialog("错误", "指定的路径不存在！", "确定");
            foundFiles = new string[0];
            return;
        }

        SearchOption searchOption = includeSubfolders ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly;
        foundFiles = Directory.GetFiles(jsonPath, "*.json", searchOption);
    }

    private void DeleteJsonFiles()
    {
        if (foundFiles.Length == 0) return;

        AssetDatabase.StartAssetEditing();
        try
        {
            foreach (string file in foundFiles)
            {
                if (File.Exists(file))
                {
                    File.Delete(file);
                    string metaFile = file + ".meta";
                    if (File.Exists(metaFile))
                    {
                        File.Delete(metaFile);
                    }
                }
            }
        }
        finally
        {
            AssetDatabase.StopAssetEditing();
            AssetDatabase.Refresh();
        }

        EditorUtility.DisplayDialog("完成", $"成功删除 {foundFiles.Length} 个JSON文件", "确定");
        foundFiles = new string[0];
        showPreview = false;
    }
}