
public class DependencyContainer {
    public static let shared = DependencyContainer()
    public lazy var player: PlayerProtocol = Player.shared
}
