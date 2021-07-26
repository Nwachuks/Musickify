//
//  NewReleases.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 26/07/2021.
//

import Foundation

struct NewReleases: Codable {
    let albums: Albums
}

struct Albums: Codable {
    let items: [Album]
}

struct Album: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case id
        case images
        case name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
    }
}



