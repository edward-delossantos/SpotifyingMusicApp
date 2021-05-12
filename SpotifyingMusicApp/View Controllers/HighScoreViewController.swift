//
//  HighScoreViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 5/10/21.
//

import UIKit

protocol HighScoreViewControllerDelegate {
    func didCheckHighScore(highScore: Int)
}

class HighScoreViewController: UIViewController {
    
    var delegate: HighScoreViewControllerDelegate!
    var finalScore: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHighScore()
    }
    
    func setHighScore() {
        var highScore = UserDefaults.standard.integer(forKey: "high_score")
        if highScore < finalScore {
            highScore = finalScore
            UserDefaults.standard.setValue(finalScore, forKey: "high_score")
        }
        delegate.didCheckHighScore(highScore: highScore)
        self.dismiss(animated: true, completion: nil)
    }
}
