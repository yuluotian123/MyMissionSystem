using UnityEngine;
using UnityEngine.Audio;

public class PoolableAudioSource : MonoBehaviour, IPoolable
{
    private AudioSource audioSource;

    private void Awake()
    {
        audioSource = GetComponent<AudioSource>();
        if (audioSource == null)
        {
            audioSource = gameObject.AddComponent<AudioSource>();
        }
    }

    public void OnSpawn()
    {
        // 对象被启用时的初始化逻辑
    }

    public void OnDespawn()
    {
        // 对象被回收时的清理逻辑
        audioSource.Stop();
    }

    public void ConfigureAudioSource(AudioClip clip, float volume, float pitch, bool loop, AudioMixerGroup mixerGroup)
    {
        audioSource.clip = clip;
        audioSource.volume = volume;
        audioSource.pitch = pitch;
        audioSource.loop = loop;
        audioSource.outputAudioMixerGroup = mixerGroup;
    }

    public void Play()
    {
        audioSource.Play();
    }

    public void Stop()
    {
        audioSource.Stop();
    }

    public void Pause()
    {
        audioSource.Pause();
    }

    public bool IsPlaying()
    {
        return audioSource.isPlaying;
    }

    public void SetVolume(float volume)
    {
        audioSource.volume = volume;
    }

    public void SetPitch(float pitch)
    {
        audioSource.pitch = pitch;
    }
} 