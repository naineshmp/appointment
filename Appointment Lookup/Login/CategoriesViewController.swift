//
//  CategoryTableViewCell.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryTitle: UILabel!
}

class CategoriesViewController: UITableViewController {
    
    @IBAction func signOutClicked(_ sender: UIBarButtonItem) {
        try!
        Auth.auth().signOut()
        performSegue(withIdentifier: "userToSignIn", sender: self)
    }
    //DataSource
    var categories: [String] = []
    var images: [String] = []
    let cellIdentifier = "CategoryCell"
    var selectedCategory: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = ["Health", "Beautician", "Restaurants", "Event Planner", "Legal Services"]
        images = ["health", "beautician", "restaurants", "event", "law"]
        title = "Category"
        
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        // Configure the cell...
        let category = categories[indexPath.row]
        cell.categoryImage.image = UIImage(named: images[indexPath.row])
        cell.categoryTitle.text = "  " + category
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToServiceProvider" {
            let controller = (segue.destination as! ServiceProvidersListViewController)
            controller.businessCategory =  self.selectedCategory
            
            
        }
    }
    
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "listToServiceProvider", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
