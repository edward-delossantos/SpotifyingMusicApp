//
//  WelcomeViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/17/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchProfile()
    }
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.usernameLabel.text = "Welcome \(model.display_name)"
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
