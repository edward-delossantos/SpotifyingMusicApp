//
//  FeaturedPlaylistsResponse.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/22/21.
//

import Foundation

struct PlaylistsResponse: Codable {
    let playlists: PlaylistItems
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
