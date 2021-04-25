//
//  CategoriesViewController.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/23/21.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var categories: [Category]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async {
            self.fetchCategories()
            self.tableView.reloadData()
        }
    }
    
    private func fetchCategories() {
        APICaller.shared.getCategories { result in
            switch result {
            case .success(let model):
                self.categories = model.categories.items
                self.categories?.shuffle()
                print(self.categories!)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = category?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = categories![indexPath.row]
        print(id)
        tableView.deselectRow(at: indexPath, animated: true)
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
