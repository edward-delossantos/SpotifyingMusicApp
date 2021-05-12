//
//  WelcomeViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/17/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchProfile()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let highScore = UserDefaults.standard.integer(forKey: "high_score")
        highScoreLabel.text = "High Score: \(highScore)"
    }
    
    private func fetchProfile() {
        let displayName = UserDefaults.standard.string(forKey: "display_name")
        if displayName != nil {
            self.usernameLabel.text = "Logged in as: \(displayName!)"
        } else {
            APICaller.shared.getCurrentUserProfile { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.usernameLabel?.text = "Logged in as: \(model.display_name)"
                        UserDefaults.standard.setValue(model.display_name, forKey: "display_name")
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories" {
            var categories: [Category]?
            
            let group = DispatchGroup()
            group.enter()
            let controller = segue.destination as! CategoriesViewController            // Get the new view controller using segue.destination.
            APICaller.shared.getCategories { result in
                switch result {
                case .success(let model):
                    categories = model.categories.items
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            group.wait()
            controller.categories = categories
        }
    }
}
