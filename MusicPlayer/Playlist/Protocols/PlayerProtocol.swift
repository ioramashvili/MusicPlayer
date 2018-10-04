
public protocol PlayerProtocol: class {
    var song: Song? { get set }
    func play()
    func pause()
    func toggle()
    var playerDelegate: PlayerDelegate? { get set }
}
