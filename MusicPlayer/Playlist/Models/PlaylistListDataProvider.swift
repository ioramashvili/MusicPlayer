
public class PlaylistListDataProvider: AppListDataProvider {
    public weak var playlistViewController: PlaylistViewController?
    public weak var delegate: PlaylistDataProviderDelegate?
    fileprivate var player: PlayerProtocol?
    
    public required init(sectionDataProviders: AppSectionDataProviders) {
        super.init(sectionDataProviders: sectionDataProviders)
    }
    
    public convenience init(playlistViewController: PlaylistViewController?, searchResultCodable: SearchResultCodable, player: PlayerProtocol) {
        self.init(sectionDataProviders: [])
        self.player = player
        self.playlistViewController = playlistViewController
        append(makeSongsSection(searchResultCodable: searchResultCodable))
    }
    
    fileprivate func makeSongsSection(searchResultCodable: SearchResultCodable) -> AppSectionDataProvider {
        let songs = SongFactory.makeSongs(from: searchResultCodable, selectionBlock: didSelect)
        setFocusedIfNeeded(songs: songs)
        return AppSectionDataProvider.init(dataProviders: songs)
    }
    
    fileprivate func setFocusedIfNeeded(songs: Songs) {
        guard let current = player?.song else {return}
        let first = songs.first(where: { $0.id == current.id })
        first?.isFocused = true
        first?.isPlaying = current.isPlaying
    }
    
    public func didSelect(song: Song, indexPath: IndexPath) -> Void {
        delegate?.didSelect(song: song, indexPath: indexPath)
    }
}
