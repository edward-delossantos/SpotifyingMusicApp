//
//  AudioTrack.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/22/21.
//

import Foundation

struct AudioTrack: Codable {
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let preview_url: String?
    let popularity: Int
}
