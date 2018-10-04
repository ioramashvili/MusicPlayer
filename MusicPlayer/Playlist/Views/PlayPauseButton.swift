
@IBDesignable
public class PlayPauseButton: UIButton {
    fileprivate var controlState: ControlState = .pause
    fileprivate let dalay: Double = 0
    
    lazy var playLayer: CAShapeLayer = { [unowned self] in
        let playLayer = CAShapeLayer()
        playLayer.fillColor = self.tintColor.cgColor
        return playLayer
    }()
    
    lazy var pauseLayer: CAShapeLayer = { [unowned self] in
        let pauseLayer = CAShapeLayer()
        pauseLayer.fillColor = self.tintColor.cgColor
        return pauseLayer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
    func sharedInitialization() {
        clipsToBounds = true
        layer.addSublayer(playLayer)
        layer.addSublayer(pauseLayer)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let beziers = PlayPauseButton.generate(frame: bounds)
        playLayer.frame = bounds
        playLayer.path = playAnimationValues.toValue
        
        pauseLayer.frame = bounds
        pauseLayer.path = beziers.pause.cgPath
        pauseLayer.position.x = pauseAnimationValues.toValue
    }
    
    struct Beziers {
        var playPart1: UIBezierPath // პაუზის ფორმით
        var playPart2: UIBezierPath // ფლეის ფორმით
        var pause: UIBezierPath // მარჯვენა პაუზა
    }
    
    static func generate(frame: CGRect = CGRect(x: 0, y: 0, width: 384, height: 384)) -> Beziers {
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        let playPart1 = UIBezierPath()
        playPart1.move(to: CGPoint(x: frame.minX + 0.33333 * frame.width, y: frame.minY + 0.00000 * frame.height))
        playPart1.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.00000 * frame.height))
        playPart1.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 1.00000 * frame.height))
        playPart1.addLine(to: CGPoint(x: frame.minX + 0.33333 * frame.width, y: frame.minY + 1.00000 * frame.height))
        
        let playPart2 = UIBezierPath()
        playPart2.move(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        playPart2.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.00000 * frame.height))
        playPart2.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 1.00000 * frame.height))
        playPart2.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 1.00000 * frame.height))
        
        let pause = UIBezierPath()
        pause.move(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.00000 * frame.height))
        pause.addLine(to: CGPoint(x: frame.minX + 0.66667 * frame.width, y: frame.minY + 0.00000 * frame.height))
        pause.addLine(to: CGPoint(x: frame.minX + 0.66667 * frame.width, y: frame.minY + 1.00000 * frame.height))
        pause.addLine(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 1.00000 * frame.height))
        
        return Beziers(playPart1: playPart1, playPart2: playPart2, pause: pause)
    }
    
    var playAnimationValues: (fromValue: CGPath, toValue: CGPath) {
        let playPart1 = PlayPauseButton.generate(frame: bounds).playPart1.cgPath
        let playPart2 = PlayPauseButton.generate(frame: bounds).playPart2.cgPath
        
        return controlState == .pause ? (playPart1, playPart2) : (playPart2, playPart1)
    }
    
    var pauseAnimationValues: (fromValue: CGFloat, toValue: CGFloat) {
        let value1 = bounds.midX
        let value2 = -0.66667 * bounds.width
        
        return controlState == .pause ? (value1, value2) : (value2, value1)
    }
    
    public func play() {
        if controlState == .play { return }
        toggle()
    }
    
    public func pause() {
        if controlState == .pause { return }
        toggle()
    }
    
    public func toggle() {
        let playDuration: Double = controlState == .play ? 0.45 : 0.45
        let playBeginTime: Double = controlState == .play ? 0.2 : 0
        let playTimingFunction = CAMediaTimingFunction(controlPoints: 0.1, 0.2, 0.1, 1)
        
        let pauseDuration: Double = controlState == .play ? 0.25 : 0.35
        let pauseBeginTime: Double = controlState == .play ? 0 : 0
        let pauseTimingFunction = controlState == .play ?
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn) : CAMediaTimingFunction(controlPoints: 0.1, 0.2, 0.1, 1)
        
        controlState = controlState == .play ? .pause : .play
        
        let playAnimationGroup = CAAnimationGroup()
        playAnimationGroup.delegate = self
        playAnimationGroup.timingFunction = playTimingFunction
        playAnimationGroup.duration = playDuration
        playAnimationGroup.beginTime = CACurrentMediaTime() + dalay + playBeginTime
        playAnimationGroup.fillMode = CAMediaTimingFillMode.forwards
        playAnimationGroup.isRemovedOnCompletion = false
        
        let animatePlayPath = CABasicAnimation(keyPath: "path")
        animatePlayPath.fromValue = playAnimationValues.fromValue
        animatePlayPath.toValue = playAnimationValues.toValue
        
        playAnimationGroup.animations = [animatePlayPath]
        playLayer.add(playAnimationGroup, forKey: nil)
        
        let pauseAnimationGroup = CAAnimationGroup()
        pauseAnimationGroup.delegate = self
        pauseAnimationGroup.timingFunction = pauseTimingFunction
        pauseAnimationGroup.duration = pauseDuration
        pauseAnimationGroup.beginTime = CACurrentMediaTime() + dalay + pauseBeginTime
        pauseAnimationGroup.fillMode = CAMediaTimingFillMode.forwards
        pauseAnimationGroup.isRemovedOnCompletion = false
        
        let animatePausePositionX = CABasicAnimation(keyPath: "position.x")
        animatePausePositionX.fromValue = pauseAnimationValues.fromValue
        animatePausePositionX.toValue = pauseAnimationValues.toValue
        
        pauseAnimationGroup.animations = [animatePausePositionX]
        pauseLayer.add(pauseAnimationGroup, forKey: nil)
    }
}

extension PlayPauseButton {
    enum ControlState {
        case play, pause
    }
}

extension PlayPauseButton: CAAnimationDelegate{
    public func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}
