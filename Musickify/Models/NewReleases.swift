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
