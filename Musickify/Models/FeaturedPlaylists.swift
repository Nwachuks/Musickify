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
