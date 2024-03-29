//
//  Album.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 12/11/2022.
//

import Foundation

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

struct AlbumDetails: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalURLs: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: AlbumTracks
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalURLs = "external_urls"
        case id
        case images
        case label
        case name
        case tracks
    }
}

struct NewReleases: Codable {
    let albums: Albums
}

struct Albums: Codable {
    let items: [Album]
}
