//
//  GameModeViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 5/11/21.
//

import UIKit

class GameModeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let group = DispatchGroup()
        group.enter()

        if segue.identifier == "showPlaylists" {
            var playlists: [Playlist]?
            // Get the new view controller using segue.destination.
            let controller = segue.destination as! CategoriesViewController
            APICaller.shared.getCurrentPlaylists { result in
                switch result {
                case .success(let model):
                    playlists = model.items.shuffled()
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            group.wait()
            controller.playlists = playlists
            controller.type = "Playlist"
        }
        
        if segue.identifier == "showCategories" {
            var categories: [Category]?
            // Get the new view controller using segue.destination.
            let controller = segue.destination as! CategoriesViewController
            APICaller.shared.getCategories { result in
                switch result {
                case .success(let model):
                    categories = model.categories.items.shuffled()
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            group.wait()
            controller.categories = categories
            controller.type = "Category"
        }
    }
}
