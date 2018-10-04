
public typealias Songs = [Song]

public class Song: SongTableViewCellDataProvider, AppCellDelegate {
    public typealias SelectionBlock = (Song, IndexPath) -> Void
    public let id: Int
    public let title: String
    public let artist: String
    public let album: String
    public let artworkUrl: URL?
    public let previewUrl: URL
    public let selectionBlock: SelectionBlock
    
    public var isFocused = false
    public var isPlaying = false
    
    public init(id: Int, title: String, artist: String, album: String, artworkUrl: URL?, previewUrl: URL, selectionBlock: @escaping SelectionBlock ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.artworkUrl = artworkUrl
        self.previewUrl = previewUrl
        self.selectionBlock = selectionBlock
    }
    
    public var identifier: String {
        return SongTableViewCell.identifierValue
    }
    
    public func didSelect(at indexPath: IndexPath) {
        selectionBlock(self, indexPath)
    }
}
