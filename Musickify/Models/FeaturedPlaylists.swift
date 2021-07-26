//
//  FeaturedPlaylists.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 26/07/2021.
//

import Foundation

struct FeaturedPlaylists: Codable {
    let playlists: Playlists
}

struct Playlists: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let displayName: String
    let externalURLs: [String: String]
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalURLs = "external_urls"
        case id
    }
}
