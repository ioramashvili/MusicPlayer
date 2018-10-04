import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        return true
    }
}
