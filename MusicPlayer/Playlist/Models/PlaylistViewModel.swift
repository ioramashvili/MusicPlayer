
public class PlaylistViewModel {
    public weak var vc: PlaylistViewController?
    fileprivate let player: PlayerProtocol
    fileprivate var searchDataTask: URLSessionDataTask?
    
    public var searchResultLimit: Int {
        return 25
    }
    
    public var searchTerm: String? {
        didSet {
            performSearch()
        }
    }
    
    public init(vc: PlaylistViewController, player: PlayerProtocol) {
        self.vc = vc
        self.player = player
        
        defer {
            player.playerDelegate = self
        }
    }
    
    public func playPauseDidTap() {
        player.toggle()
    }
    
    fileprivate func performSearch() {
        var term = searchTerm ?? ""
        term = term.isEmpty ? String.makeRandomCharacter() : term
        searchDataTask?.cancel()
        vc?.searchLoaderIndicatorView.isHidden = false
        
        searchDataTask = iTunesNetworkClient.makeNewsAndOffersRequest(term: term.lowercased(), limit: searchResultLimit, media: .music).startWithExpected(type: SearchResultCodable.self) { [weak self] response in
            guard let self = self else {return}
            
            defer {
                self.vc?.searchLoaderIndicatorView.isHidden = true
            }
            
            guard let searchResultCodable = response.output else {return}
            let dataProvider = PlaylistListDataProvider.init(
                playlistViewController: self.vc,
                searchResultCodable: searchResultCodable,
                player: self.player)
            dataProvider.delegate = self
            
            self.vc?.tableViewController.dataProvider = nil
            self.vc?.tableViewController.tableView.layoutIfNeeded()
            self.vc?.tableViewController.dataProvider = dataProvider
            self.scrollToFocusedSong()
        }
    }
    
    fileprivate func scrollToFocusedSong() {
        if let indexPath = self.songInfo(for: player.song?.id)?.indexPath {
        self.vc?.tableViewController.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) { [weak self] in
            }
        }
    }
    
    fileprivate func songInfo(for songId: Int?) -> (song: Song, indexPath: IndexPath)? {
        guard let songId = songId, let section = vc?.tableViewController.dataProvider?.first else {return nil}
        
        let songs = section.dataProviders.compactMap { $0 as? Song }
        guard let songIndex = songs.firstIndex(where: { $0.id == songId }) else {return nil}
        
        return (songs[songIndex], IndexPath.init(row: songIndex, section: 0))
    }
    
    fileprivate func updateCurrentSongLoadingState() {
        if let songInfo = self.songInfo(for: player.song?.id) {
            songInfo.song.isPlaying = player.song?.isPlaying ?? false
            let tableView = vc?.tableViewController.tableView
            tableView?.beginUpdates()
            tableView?.reloadRows(at: [songInfo.indexPath], with: .fade)
            tableView?.endUpdates()
        }
    }
}

extension PlaylistViewModel: PlayerDelegate {
    public func progressDidChange(to progress: CGFloat) {
        vc?.audioPlayerControlView.slider.value = Float(progress)
    }
    
    public func playerStateChanged(to isPlaying: Bool) {
        if isPlaying {
            vc?.showAudioPlayerControlViewIfNeeded()
            vc?.audioPlayerControlView.playPauseButton.play()
        } else {
            vc?.audioPlayerControlView.playPauseButton.pause()
        }
        
        updateCurrentSongLoadingState()
    }
}

extension PlaylistViewModel: PlaylistDataProviderDelegate {
    public func didSelect(song: Song, indexPath: IndexPath) {
        print(song.title, indexPath)
        vc?.closeKeyboard()
        
        if player.song?.id == song.id {
            player.toggle()
            return
        }
        
        let tableView = vc?.tableViewController.tableView
        
        let songInfo = self.songInfo(for: player.song?.id)
        songInfo?.song.isFocused = false
        song.isFocused = true
        
        tableView?.beginUpdates()
        if let prevIndexPath = songInfo?.indexPath {
            tableView?.reloadRows(at: [prevIndexPath], with: .left)
        }
        tableView?.reloadRows(at: [indexPath], with: .right)
        tableView?.endUpdates()
        
        vc?.audioPlayerControlView.artworkImageView.fadeImageDownload(at: song.artworkUrl, placeholderImage: #imageLiteral(resourceName: "default_artwork.png"))
        
        player.song = song
    }
}


