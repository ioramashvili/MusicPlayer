
public class SongTableViewCell: AppTableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var artistLabel: UILabel!
    @IBOutlet fileprivate weak var albumLabel: UILabel!
    @IBOutlet fileprivate weak var artworkUIImageView: UIImageView!
    
    fileprivate static var defaultArtwork = #imageLiteral(resourceName: "default_artwork.png")
    
    override public class var identifier: Identifierable {
        return AppCellType.song
    }
    
    override public var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? SongTableViewCellDataProvider else {fatalError()}
            
            titleLabel.text = dataProvider.title
            artistLabel.text = dataProvider.artist
            albumLabel.text = dataProvider.album
            artworkUIImageView.downloadImage(at: dataProvider.artworkUrl, placeholderImage: SongTableViewCell.placeholderImage)
        }
    }
}
