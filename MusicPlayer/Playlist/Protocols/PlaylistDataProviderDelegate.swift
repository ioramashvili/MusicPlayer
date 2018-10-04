
public protocol PlaylistDataProviderDelegate: class {
    func didSelect(song: Song, indexPath: IndexPath) -> Void
}
