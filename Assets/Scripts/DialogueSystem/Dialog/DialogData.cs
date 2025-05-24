using System;
using UnityEngine;

[Serializable]
public class DialogData
{
    public string speakerName;
    public string content;
    public Sprite speakerAvatar;
    public AudioClip voiceClip;

    public DialogData(string speakerName, string content, Sprite speakerAvatar = null, AudioClip voiceClip = null)
    {
        this.speakerName = speakerName;
        this.content = content;
        this.speakerAvatar = speakerAvatar;
        this.voiceClip = voiceClip;
    }
}