//
//  User.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 12/11/2022.
//

import Foundation

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
