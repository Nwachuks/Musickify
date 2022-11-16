//
//  Category.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 16/11/2022.
//

import Foundation

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}

struct AllCategories: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}
