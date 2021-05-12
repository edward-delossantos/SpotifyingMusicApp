//
//  RecapViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/29/21.
//

import UIKit

class RecapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tracks: [Tracks] = []
    var correctIndexes: [Int] = []
    var finalScore = 0
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorColor = .black
        tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        setHighScore()
    }
    
    @IBAction func didTapPlayAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
    }
    
    func setHighScore() {
        performSegue(withIdentifier: "showHighScoreScreen", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecapTrackCell", for: indexPath)
        let index = correctIndexes[indexPath.row]
        let track = tracks[index].track
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(track.artists[0].name) - \(track.name)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHighScoreScreen" {
            let controller = segue.destination as! HighScoreViewController
            controller.delegate = self
            controller.finalScore = finalScore
        }
    }
}

extension RecapViewController: HighScoreViewControllerDelegate {
    func didCheckHighScore(highScore: Int) {
        finalScoreLabel.text = "Final Score: \(finalScore)"
        if highScore == finalScore {
            highScoreLabel.text = "Congrats! You beat your high score!"
        } else {
            highScoreLabel.text = "Current High Score: \(highScore)"
        }
    }
}
