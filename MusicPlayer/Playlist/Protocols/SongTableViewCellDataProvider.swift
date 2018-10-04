
public protocol SongTableViewCellDataProvider: AppCellDataProvider {
    var title: String { get }
    var artist: String { get }
    var album: String { get }
    var artworkUrl: URL? { get }
    var isFocused: Bool { get }
    var isPlaying: Bool { get }
}

