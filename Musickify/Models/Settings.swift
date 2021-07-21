//
//  Settings.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 21/07/2021.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
