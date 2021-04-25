//
//  Artist.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/22/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
