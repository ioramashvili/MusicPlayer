
public class MusicPlayerTableViewController: AppTableViewController {
    fileprivate var _keyboardFrame = CGRect.zero
    fileprivate var _isKeyboardOpen = false
    fileprivate var cachedCellHeights: [IndexPath: CGFloat] = [:]
    
    public override var dataProvider: AppListDataProvider? {
        get {
            return super.dataProvider
        }
        set {
            clearCachedCellHeights()
            super.dataProvider = newValue
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .interactive
        tableView.register(types: [
            SongTableViewCell.self
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc public func closeKeyboard() {
        view.endEditing(true)
    }
    
    public func addKeyboardCloseOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardCloseOnTap()
    }
    
    public func clearCachedCellHeights() {
        cachedCellHeights = [:]
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cachedCellHeights[indexPath] = cell.frame.height
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cachedCellHeights[indexPath] ?? UITableView.automaticDimension
    }
}
