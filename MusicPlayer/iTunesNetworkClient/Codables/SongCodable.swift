
public struct SongCodable: Codable {
    public let trackId: Int
    public let artistName: String
    public let trackName: String
    public let collectionName: String
    public let artworkUrl100: URL?
    public let previewUrl: URL
}

public class SongFactory {
    public class func makeSongs(from searchResult: SearchResultCodable, selectionBlock: @escaping Song.SelectionBlock) -> Songs {
        return searchResult.results.map { make(from: $0, selectionBlock: selectionBlock) }
    }
    
    public class func make(from codable: SongCodable, selectionBlock: @escaping Song.SelectionBlock) -> Song {
        return Song(
            id: codable.trackId,
            title: codable.trackName,
            artist: codable.artistName,
            album: codable.collectionName,
            artworkUrl: codable.artworkUrl100,
            previewUrl: codable.previewUrl,
            selectionBlock: selectionBlock)
    }
}

//
//{
//    "wrapperType": "track",
//    "kind": "song",
//    "artistId": 315473044,
//    "collectionId": 329481191,
//    "trackId": 329481197,
//    "artistName": "The xx",
//    "collectionName": "xx (Bonus Track Version)",
//    "trackName": "Intro",
//    "collectionCensoredName": "xx (Bonus Track Version)",
//    "trackCensoredName": "Intro",
//    "artistViewUrl": "https://itunes.apple.com/us/artist/the-xx/315473044?uo=4",
//    "collectionViewUrl": "https://itunes.apple.com/us/album/intro/329481191?i=329481197&uo=4",
//    "trackViewUrl": "https://itunes.apple.com/us/album/intro/329481191?i=329481197&uo=4",
//    "previewUrl": "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/Music/v4/8b/04/13/8b04139e-1016-2af3-554f-372d58030680/mzaf_5309197990555909191.plus.aac.p.m4a",
//    "artworkUrl30": "https://is2-ssl.mzstatic.com/image/thumb/Music/v4/11/dc/de/11dcde3a-c728-ef6e-20db-d20620462ade/source/30x30bb.jpg",
//    "artworkUrl60": "https://is2-ssl.mzstatic.com/image/thumb/Music/v4/11/dc/de/11dcde3a-c728-ef6e-20db-d20620462ade/source/60x60bb.jpg",
//    "artworkUrl100": "https://is2-ssl.mzstatic.com/image/thumb/Music/v4/11/dc/de/11dcde3a-c728-ef6e-20db-d20620462ade/source/100x100bb.jpg",
//    "collectionPrice": 9.99,
//    "trackPrice": 1.29,
//    "releaseDate": "2009-08-14T07:00:00Z",
//    "collectionExplicitness": "notExplicit",
//    "trackExplicitness": "notExplicit",
//    "discCount": 1,
//    "discNumber": 1,
//    "trackCount": 12,
//    "trackNumber": 1,
//    "trackTimeMillis": 127852,
//    "country": "USA",
//    "currency": "USD",
//    "primaryGenreName": "Alternative",
//    "isStreamable": true
//},

