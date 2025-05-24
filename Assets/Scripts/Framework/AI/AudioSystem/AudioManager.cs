using UnityEngine;
using UnityEngine.Audio;
using System.Collections.Generic;

public class AudioManager : MonoSingleton<AudioManager>
{
    [System.Serializable]
    public class Sound
    {
        public string name;
        public AudioClip clip;
        [Range(0f, 1f)]
        public float volume = 1f;
        [Range(0.1f, 3f)]
        public float pitch = 1f;
        public bool loop = false;
        public bool usePool = false;  // 是否使用对象池
        public int poolSize = 5;      // 对象池初始大小
    }

    [Header("音频设置")]
    public Sound[] sounds;
    public AudioMixerGroup musicMixerGroup;
    public AudioMixerGroup sfxMixerGroup;
    public PoolableAudioSource audioSourcePrefab; // 可池化的AudioSource预制体

    private Dictionary<string, Sound> soundDictionary = new Dictionary<string, Sound>();
    private Dictionary<string, ObjectPool<PoolableAudioSource>> soundPools = new Dictionary<string, ObjectPool<PoolableAudioSource>>();
    private Dictionary<string, PoolableAudioSource> singleSources = new Dictionary<string, PoolableAudioSource>();

    protected override void OnInit()
    {
        // 初始化所有音频
        foreach (Sound s in sounds)
        {
            if (s.usePool)
            {
                // 使用对象池初始化
                InitializeSoundPool(s);
            }
            else
            {
                // 创建单个音频源
                CreateSingleAudioSource(s);
            }

            soundDictionary[s.name] = s;
        }
    }

    private void InitializeSoundPool(Sound sound)
    {
        // 使用PoolManager创建对象池
        var pool = PoolManager.instance.CreatePool(audioSourcePrefab, sound.poolSize);
        soundPools[sound.name] = pool;
    }

    private void CreateSingleAudioSource(Sound sound)
    {
        var audioSource = Instantiate(audioSourcePrefab, transform);
        audioSource.name = $"Sound_{sound.name}";
        audioSource.ConfigureAudioSource(
            sound.clip,
            sound.volume,
            sound.pitch,
            sound.loop,
            sound.loop ? musicMixerGroup : sfxMixerGroup
        );
        singleSources[sound.name] = audioSource;
    }

    public void PlaySound(string name)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
        {
            Debug.LogWarning($"Sound: {name} not found!");
            return;
        }

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                var audioSource = pool.Spawn(transform.position, Quaternion.identity);
                audioSource.ConfigureAudioSource(
                    sound.clip,
                    sound.volume,
                    sound.pitch,
                    sound.loop,
                    sound.loop ? musicMixerGroup : sfxMixerGroup
                );
                audioSource.Play();

                // 如果不是循环音频，在播放完成后自动回收
                if (!sound.loop)
                {
                    StartCoroutine(DespawnAfterPlay(audioSource, sound.clip.length, pool));
                }
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            source.Play();
        }
    }

    private System.Collections.IEnumerator DespawnAfterPlay(PoolableAudioSource audioSource, float delay, ObjectPool<PoolableAudioSource> pool)
    {
        yield return new WaitForSeconds(delay);
        if (audioSource != null)
        {
            pool.Despawn(audioSource);
        }
    }

    public void StopSound(string name)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
            return;

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                foreach (var source in pool.GetActiveObjects())
                {
                    source.Stop();
                    pool.Despawn(source);
                }
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            source.Stop();
        }
    }

    public void PauseSound(string name)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
            return;

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                foreach (var source in pool.GetActiveObjects())
                {
                    if (source.IsPlaying())
                    {
                        source.Pause();
                    }
                }
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            source.Pause();
        }
    }

    public void SetVolume(string name, float volume)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
            return;

        sound.volume = Mathf.Clamp01(volume);

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                foreach (var source in pool.GetActiveObjects())
                {
                    source.SetVolume(sound.volume);
                }
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            source.SetVolume(sound.volume);
        }
    }

    public void SetPitch(string name, float pitch)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
            return;

        sound.pitch = Mathf.Clamp(pitch, 0.1f, 3f);

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                foreach (var source in pool.GetActiveObjects())
                {
                    source.SetPitch(sound.pitch);
                }
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            source.SetPitch(sound.pitch);
        }
    }

    public bool IsPlaying(string name)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
            return false;

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                return pool.GetActiveObjects().Exists(source => source.IsPlaying());
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            return source.IsPlaying();
        }

        return false;
    }

    public int GetPlayingCount(string name)
    {
        if (!soundDictionary.TryGetValue(name, out Sound sound))
            return 0;

        if (sound.usePool)
        {
            if (soundPools.TryGetValue(name, out var pool))
            {
                return pool.GetActiveObjects().FindAll(source => source.IsPlaying()).Count;
            }
        }
        else if (singleSources.TryGetValue(name, out var source))
        {
            return source.IsPlaying() ? 1 : 0;
        }

        return 0;
    }

    protected void OnDestroy()
    {
        // 清理所有对象池
        foreach (var pool in soundPools.Values)
        {
            if (pool != null)
            {
                pool.Clear();
            }
        }
        soundPools.Clear();

        // 清理单个音频源
        foreach (var source in singleSources.Values)
        {
            if (source != null)
            {
                Destroy(source.gameObject);
            }
        }
        singleSources.Clear();
    }
} 