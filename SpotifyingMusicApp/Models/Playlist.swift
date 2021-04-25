//
//  Playlist.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/22/21.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let name: String
    let owner: User
}
