//
//  CategoriesViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/23/21.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var categories: [Category]?
    var playlists: [Playlist]?
    var type = ""
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = ""
        tableView.separatorColor = .black
        tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        selectLabel.text = "Select a \(type)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        switch type {
        case "Playlist":
            label.text = playlists![indexPath.row].name
            break
        case "Category":
            label.text = categories![indexPath.row].name
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Animation
    // code from: https://github.com/brianadvent/SimpleAnimations/blob/master/Animations/TableViewController.swift
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tracks: [Tracks]?
        
        if segue.identifier == "showAnswerChoices" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let group = DispatchGroup()
                group.enter()
                let controller = segue.destination as! AnswerSelectionViewController
                //perform api call
                switch type {
                case "Playlist":
                    APICaller.shared.getPlaylistTracks(playlistId: playlists![indexPath.row].id) { result in
                        switch result {
                        case.success(let model):
                            tracks = model.items.shuffled()
                            group.leave()
                        case.failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    break
                    
                case "Category":
                    var categoryPlaylists: [Playlist]?
                    APICaller.shared.getPlaylists(categoryId: categories![indexPath.row].id) {
                        result in
                        switch result {
                        case .success(let model):
                            categoryPlaylists = model.playlists.items.shuffled()
                            let playlist = categoryPlaylists!.randomElement()
                            APICaller.shared.getPlaylistTracks(playlistId: playlist!.id) { result in
                                switch result {
                                case .success(let model):
                                    tracks = model.items.shuffled()
                                    group.leave()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    break
                    
                default:
                    break
                }
                group.wait()
                controller.tracks = (tracks?.filter({ track in
                    return track.track.preview_url != nil
                }))!
            }
            // Pass the selected object to the new view controller.
        }
    }
    
    
}
