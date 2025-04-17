using YLT.MissionSystem;

public static class GameAPI
{
    /// <summary>朝游戏广播一条消息</summary>
    /// <param name="message"></param>
    public static void Broadcast(GameMessage message) =>
        GameManager.instance.MissionManager.SendMessage(message);

    public static void StartMission(MissionPrototype<object> missionProto) =>
        GameManager.instance.MissionManager.StartMission(missionProto);

    public static void Save() => SerializedSystem.SerializeMissionSystem();
}

