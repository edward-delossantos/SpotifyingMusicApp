//
//  AudioTrack.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/22/21.
//

import Foundation

struct AudioTrack: Codable {
    let artists: [Artist]
    let id: String
    let name: String
    let preview_url: String?
}
