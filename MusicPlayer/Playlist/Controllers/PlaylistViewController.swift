
public class PlaylistViewController: UIViewController {
    fileprivate lazy var viewModel = PlaylistViewModel(vc: self, player: DependencyContainer.shared.player)
    weak var tableViewController: MusicPlayerTableViewController!
    fileprivate let tableViewControllerSegueIdentifier = "Playlist"
    @IBOutlet fileprivate weak var searchTextField: UITextField!
    @IBOutlet weak var audioPlayerControlView: AudioPlayerControlView!
    @IBOutlet weak var searchLoaderIndicatorView: UIActivityIndicatorView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchTextField()
        addKeyboardCloseOnTap()
        setupAudioPlayerControlView()
        textFieldDidChange(searchTextField)
    }
    
    public override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == tableViewControllerSegueIdentifier {
            tableViewController = segue.destination as? MusicPlayerTableViewController
        }
    }
    
    @IBAction func playPauseDidTap(_ sender: PlayPauseButton) {
        viewModel.playPauseDidTap()
    }
    
    @objc fileprivate func textFieldDidChange(_ sender: UITextField) {
        viewModel.searchTerm = searchTextField.text
    }
    
    fileprivate func addKeyboardCloseOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc public func closeKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func setupAudioPlayerControlView() {
        audioPlayerControlView.slider.value = 0
        audioPlayerControlView.slider.isUserInteractionEnabled = false
        audioPlayerControlView.playPauseButton.play()
        audioPlayerControlView.isHidden = true
    }
    
    public func showAudioPlayerControlViewIfNeeded() {
        guard audioPlayerControlView.isHidden else {return}
        
        audioPlayerControlView.isHidden = false
        audioPlayerControlView.alpha = 0
        audioPlayerControlView.frame.origin.y += 100
        
        UIView.animate(withDuration: 0.45) {
            self.audioPlayerControlView.alpha = 1
            self.audioPlayerControlView.frame.origin.y -= 100
        }
    }
}

extension PlaylistViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
