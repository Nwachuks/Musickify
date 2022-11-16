//
//  Playlist.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let externalURLs: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    
    enum CodingKeys: String, CodingKey {
        case description
        case externalURLs = "external_urls"
        case id
        case images
        case name
        case owner
    }
}

struct FeaturedPlaylists: Codable {
    let playlists: Playlists
}

struct CategoryPlaylists: Codable {
    let playlists: Playlists
}

struct Playlists: Codable {
    let items: [Playlist]
}

struct PlaylistDetails: Codable {
    let description: String
    let externalURLs: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let tracks: PlaylistItems
    
    enum CodingKeys: String, CodingKey {
        case description
        case externalURLs = "external_urls"
        case id
        case images
        case name
        case owner
        case tracks
    }
}

struct PlaylistItems: Codable {
    let items: [PlaylistTracks]
}

struct PlaylistTracks: Codable {
    let track: PlaylistTrack
}
