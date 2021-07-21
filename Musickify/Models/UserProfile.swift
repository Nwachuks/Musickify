//
//  UserProfile.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let displayName: String
    let email: String
    let explicitContent: [String: Bool]
    let externalURLS: [String: String]
//    let followers: [String: Codable?]
    let id: String
    let product: String
    let images: [UserImage?]
    
    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalURLS = "external_urls"
        case id
        case product
        case images
    }
}

struct UserImage: Codable {
    let url: String
}

