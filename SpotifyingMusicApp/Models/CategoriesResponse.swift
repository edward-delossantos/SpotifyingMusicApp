//
//  CategoriesResponse.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/23/21.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: CategoryResponse
}

struct CategoryResponse: Codable {
    let items: [Category]
}

struct Category: Codable {
    let href: String
    let id: String
    let name: String
}

