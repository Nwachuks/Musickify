//
//  SearchResult.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 17/11/2022.
//

import Foundation

struct SearchResults: Codable {
    let albums: SearchAlbum
    let artists: SearchArtist
    let tracks: SearchTrack
    let playlists: SearchPlaylist
}

struct SearchAlbum: Codable {
    let items: [Album]
}

struct SearchArtist: Codable {
    let items: [ArtistDetail]
}

struct SearchTrack: Codable {
    let items: [AudioTrack]
}

struct SearchPlaylist: Codable {
    let items: [Playlist]
}

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

enum SearchResult {
    case album(result: Album)
    case artist(result: ArtistDetail)
    case track(result: AudioTrack)
    case playlist(result: Playlist)
}
