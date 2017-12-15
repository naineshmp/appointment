//
//  ServiceProvidersListViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ServiceProviderListCell: UITableViewCell {
    
    @IBOutlet var serviceProviderTitle: UILabel!
    
}

class ServiceProvidersListViewController: UITableViewController {
    
    var providerList = ["Health"]
    let cellIdentifier = "ServiceProviderListCell"
    var businessCategory: String = ""
    var ref: DatabaseReference! = Database.database().reference()
//    var placesList: GMSPlaceLikelihoodList?
    var selectedFinalCategory: String = ""
    
    var placesList: NSMutableArray = []

    
    var segueIdentifier = "providetToBookCustomer"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        print("---- business selected", businessCategory)
        getAllServiceProviders()
        self.tableView.reloadData()
    }
    
  

    func getAllServiceProviders(){
        ref.child("businessUsers").observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            self.providerList.removeAll()
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    print(each)
                    let businessType:String = (each.value["businesstype"] as? String)!
                    if(self.businessCategory == businessType){
                        self.providerList.append((each.value["name"] as? String)!)
                    }
                    print()
                    self.tableView.reloadData()
                }
              
            }
            
        })
        return;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.providerList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ServiceProviderListCell
        cell.serviceProviderTitle.text = self.providerList[indexPath.row]
        return cell
    }

    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {

//            let destinationViewController = segue.destination as! BusinessPageViewController
            //estinationViewController.place = placesList[indexPath.row] as? Place
        }
    }
    

 
   
}
