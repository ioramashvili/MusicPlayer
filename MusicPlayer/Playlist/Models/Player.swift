import AVFoundation

public class Player: NSObject, PlayerProtocol {
    public static let shared = Player()
    fileprivate var audioPlayer = AVPlayer()
    public weak var playerDelegate: PlayerDelegate?
    
    public var song: Song? {
        didSet {
            guard let song = song else {
                pause()
                return
            }
            
            play(url: song.previewUrl)
        }
    }
    
    override init() {
        super.init()
        setupObservers()
        setupNotifications()
    }
    
    fileprivate func setupObservers() {
        let oneSecondInterval = CMTime.init(value: 1, timescale: 1)
        audioPlayer.addPeriodicTimeObserver(forInterval: oneSecondInterval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else {return}
            self.playerDelegate?.progressDidChange(to: self.calculateCurrentProgress(currentTime: time))
        }
        
        audioPlayer.addObserver(self, forKeyPath: ObserverKeyPath.rate.keyPath, options: .new, context: nil)
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc fileprivate func audioPlayerDidFinish() {
        audioPlayer.seek(to: .zero)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer, keyPath == ObserverKeyPath.rate.keyPath {
            let isPlaying = player.rate == 1.0
            song?.isPlaying = isPlaying
            playerDelegate?.playerStateChanged(to: isPlaying)
        }
    }
    
    deinit {
        audioPlayer.removeTimeObserver(self)
        audioPlayer.removeObserver(self, forKeyPath: ObserverKeyPath.rate.keyPath)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func calculateCurrentProgress(currentTime: CMTime) -> CGFloat {
        guard let duration = audioPlayer.currentItem?.duration, !currentTime.seconds.isNaN, !duration.seconds.isNaN else {return 0}
        return CGFloat(currentTime.seconds / duration.seconds)
    }
    
    public func play(url: URL) {
        audioPlayer.replaceCurrentItem(with: AVPlayerItem.init(url: url))
        audioPlayer.play()
    }
    
    public func play() {
        audioPlayer.play()
    }
    
    public func pause() {
        audioPlayer.pause()
    }
    
    public func toggle() {
        if audioPlayer.rate == 0 {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
    
    public enum ObserverKeyPath: String {
        case rate
        
        public var keyPath: String {
            return rawValue
        }
    }
}

extension AVPlayer {
    public var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension CMTime {
    public func fomratted() -> String {
        if self.seconds.isNaN {return ""}
        let seconds = Int(CMTimeGetSeconds(self))
        
        let secondsText = seconds % 60
        let minutesText = String(format: "%02d", seconds / 60)
        return "\(minutesText):\(secondsText)"
    }
}
