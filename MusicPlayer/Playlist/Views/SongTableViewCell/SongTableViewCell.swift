
public class SongTableViewCell: AppTableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var artistLabel: UILabel!
    @IBOutlet fileprivate weak var albumLabel: UILabel!
    @IBOutlet fileprivate weak var artworkImageView: UIImageView!
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    fileprivate class var defaultArtwork: UIImage {
        return #imageLiteral(resourceName: "default_artwork.png")
    }
    
    override public class var identifier: Identifierable {
        return AppCellType.song
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = nil
    }
    
    override public var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? SongTableViewCellDataProvider else {fatalError()}
            
            titleLabel.text = dataProvider.title
            artistLabel.text = dataProvider.artist
            albumLabel.text = dataProvider.album
            artworkImageView.downloadImage(at: dataProvider.artworkUrl, placeholderImage: SongTableViewCell.defaultArtwork)
            
            if dataProvider.isPlaying {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            backgroundColor = dataProvider.isFocused ? .red : .white
            [titleLabel, artistLabel, albumLabel].forEach {
                $0?.textColor = dataProvider.isFocused ? .white : .black
            }
        }
    }
}
