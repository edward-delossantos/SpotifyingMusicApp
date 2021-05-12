//
//  AnswerSelectionViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/27/21.
//

import UIKit
import AVFoundation

class AnswerSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tracks: [Tracks] = []
    var currentRound = 0
    var lowerBound = 0
    var upperBound = 3
    var score = 0
    var currentTime = 0.0
    var correctIndexes: [Int] = []
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var timeObserverToken: Any?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .black
        tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        correctIndexes.append(Int.random(in: lowerBound...upperBound))
        setAudio()
        animateTable()
    }
    
    //MARK: - TimeObserver
    //code from https://developer.apple.com/documentation/avfoundation/media_playback_and_selection/observing_the_playback_time
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)
        
        
        timeObserverToken = player!.addPeriodicTimeObserver(forInterval: time,
                                                            queue: .main) {
            [weak self] time in
            self!.currentTime = Double(15 - CMTimeGetSeconds(time))
            self!.currentTimeLabel.text = "Time Left: \(Int(round(self!.currentTime)))"
            if(self!.currentTime <= 0) {
                self!.removePeriodicTimeObserver()
                self!.startNextRound()
            }
        }
    }
    
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player!.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    //MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerChoiceCell", for: indexPath)
        let track = tracks[indexPath.row + (currentRound*4)].track
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(track.artists[0].name) - \(track.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        player?.pause()
        removePeriodicTimeObserver()
        if (indexPath.row + currentRound.convertToIndex()) == correctIndexes[currentRound] {
            let points = calculateScore()
            score += points
        }
        if currentRound == 4 {
            performSegue(withIdentifier: "showRecap", sender: nil)
        } else {
            startNextRound()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                self.player?.play()
                addPeriodicTimeObserver()
            }
        }
    }
    
    
    //MARK: - Round Handling
    func startNextRound() {
        currentScoreLabel.text = "Current Score: \(Int(score))"
        currentTimeLabel.text = "Time Left: 15"
        setNextValues()
        setAudio()
        animateTable()
    }
    
    func calculateScore() -> Int {
        var points = 0
        let scoreForRound = Int(round(1500 - ((15 - currentTime) * 100)))
        //Bonus Points
        if (currentTime >= 13) {
            points = scoreForRound + 1000;
        } else if (currentTime >= 10) {
            points = scoreForRound + 500;
        } else if (currentTime >= 5) {
            points = scoreForRound + 200;
        }
        return points;
    }
    
    func setNextValues() {
        currentTime = 0
        currentRound += 1
        lowerBound = 0 + currentRound.convertToIndex()
        upperBound = 3 + currentRound.convertToIndex()
        correctIndexes.append(Int.random(in: lowerBound...upperBound))
    }
    
    func setAudio() {
        let url = URL(string: tracks[correctIndexes[currentRound]].track.preview_url! )
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewWidth = tableView.bounds.size.width
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewWidth, y: 0)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.5, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecap" {
            let controller = segue.destination as! RecapViewController
            controller.finalScore = score
            controller.correctIndexes = correctIndexes
            controller.tracks = tracks
        }
    }
}
