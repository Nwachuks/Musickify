//
//  AudioTrack.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

struct AudioTrack: Codable {
    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationInMS: Int
    let explicit: Bool
    let externalURLs: [String: String]
    let id: String
    let name: String
    let popularity: Int
    
    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationInMS = "duration_ms"
        case explicit
        case externalURLs = "external_urls"
        case id
        case name
        case popularity
    }
}
