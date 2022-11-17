//
//  Artist.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let externalURLs: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case externalURLs = "external_urls"
    }
}

struct ArtistDetail: Codable {
    let id: String
    let images: [APIImage]
    let name: String
    let externalURLs: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case name
        case externalURLs = "external_urls"
    }
}
