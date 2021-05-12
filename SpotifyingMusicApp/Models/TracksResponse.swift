//
//  TracksResponse.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/27/21.
//

import Foundation

struct TracksResponse: Codable {
    let items: [Tracks]
}

struct Tracks: Codable {
    let track: AudioTrack
}
