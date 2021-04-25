//
//  ViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/17/21.
//

import UIKit

//add delegate to pop the view controller. Token is now in the system but on return it does not move to the next view controller. next add api calls and display the username on the welcome screen 

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSignIn() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil ))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = WelcomeViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }

}

