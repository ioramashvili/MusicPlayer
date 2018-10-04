
public protocol PlayerDelegate: class {
    func progressDidChange(to progress: CGFloat)
    func playerStateChanged(to isPlaying: Bool)
}
