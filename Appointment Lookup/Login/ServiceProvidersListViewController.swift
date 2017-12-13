//
//  ServiceProvidersListViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/22/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit

class ServiceProviderListCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var serviceProviderTitle: UILabel!
    @IBOutlet var distanceToLocation: UILabel!
    
}

class ServiceProvidersListViewController: UITableViewController {
    
    
    let cellIdentifier = "ServiceProviderListCell"
    
//    var placesList: GMSPlaceLikelihoodList?
    var selectedFinalCategory: String = ""
    
    var placesList: NSMutableArray = []

    
    var segueIdentifier = "BusinessPageViewControllerSegue"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Results"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //prk for fetching list of nearby places
        
//        performSegue(withIdentifier: "BusinessPageViewControllerSegue", sender: nil)

//        imageView = UIImageView()
//        placesClient = GMSPlacesClient.shared()
//        if AppState.sharedInstance.location != nil{
//            self.get_data_from_url(url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?type=\(selectedFinalCategory)&radius=10000&location=\(AppState.sharedInstance.location!.coordinate.latitude),\(AppState.sharedInstance.location!.coordinate.longitude)&key=AIzaSyBm5MbHM3bhvPpzUlmwlLkGHSCJUccjUIY")
//        }
        
        self.tableView.reloadData()

        
//        placesClient?.currentPlace(callback: { (placeLikelihoods, error) -> Void in
//            guard error == nil else {
//                print("Current Place error: \(error!.localizedDescription)")
//                return
//            }
//            
//            if let placeLikelihoods = placeLikelihoods {
//                
//                self.placesList = placeLikelihoods
//                print("\n\n-----\n1. ", self.placesList?.likelihoods.count ?? 0)
//                print(type(of: self.placesList?.likelihoods))
//                self.tableView.reloadData()
////                print("\n\n-----\n", (self.placesList?.likelihoods[0].place.name)!)
////                for likelihood in placeLikelihoods.likelihoods {
////                    let place = likelihood.place
////                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
////                    print("Current Place address \(place.formattedAddress)")
////                    print("Current Place attributions \(place.attributions)")
////                    print("Current PlaceID \(place.placeID)")
////                    //self.loadFirstPhotoForPlace(placeID: place.placeID)
////                }
//            }
//        })
//        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestLocation()
//        locationManager.requestAlwaysAuthorization()
//        
        //prk end
        
        //let locationManager = CLLocationManager()
        //locationManager.requestWhenInUseAuthorization()
        
        
        // Sort by navigation bar item
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort By ▾", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ServiceProvidersListViewController.showSortByActionSheet))
        
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
        print("\n\n-----\n2.Number of rows", self.placesList.count , "\n\n")
        return self.placesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ServiceProviderListCell

        // Configure the cell...
        
//        let place_name = result["name"] as? String
        //
        //                        let placeid = result["place_id"] as? String
        //                                //                                TableData.append(place_name + " [" + placeid + "]")
        //                        let rating = result["rating"] as? Float
        //                        let address = result["vicinity"] as? String
        //                        let opening_hours = result["opening_hours"] as? NSDictionary
        //                        let status = opening_hours?["open_now"] as? Int
        
//        let result = placesList[indexPath.row] as! Place
      

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
//    // Action sheet for sorting menu
//    func showSortByActionSheet() {
//        // 1
//        let sortByMenu = UIAlertController(title: "Sort By", message: "Sort Results By", preferredStyle: .actionSheet)
//
//        // 2
//        let distanceAction = UIAlertAction(title: "Distance", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            print("Sort By Distance")
//
//            // sort by distance logic goes here
//            let coordinate = CLLocation(latitude: (AppState.sharedInstance.location?.coordinate.latitude)!, longitude: (AppState.sharedInstance.location?.coordinate.longitude)!)
//
//            let list = self.placesList.sorted( by: { place1, place2 in return coordinate.distance(from: CLLocation(latitude: ((place1 as! Place).location?.coordinate.latitude)!, longitude: ((place1 as! Place).location?.coordinate.longitude)!)) < coordinate.distance(from: CLLocation(latitude: ((place2 as! Place).location?.coordinate.latitude)!, longitude: ((place2 as! Place).location?.coordinate.longitude)!))} )
//
//            self.placesList.removeAllObjects()
//            self.placesList.addObjects(from: list)
//
//            self.tableView.reloadData()
//        })
//
//        let ratingAction = UIAlertAction(title: "Rating", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            print("Sort By Rating")
//
//            let list = self.placesList.sorted( by: { place1, place2 in return (((place1 as! Place).rating! > (place2 as! Place).rating!))} )
//
//            self.placesList.removeAllObjects()
//            self.placesList.addObjects(from: list)
//
//            self.tableView.reloadData()
//        })
//
//        //
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//            print("Cancelled")
//        })
//
//
//        // 4
//        sortByMenu.addAction(distanceAction)
//        sortByMenu.addAction(ratingAction)
//        sortByMenu.addAction(cancelAction)
//
//        // 5
//        self.present(sortByMenu, animated: true, completion: nil)
//    }
    
    
   
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            print("reloading")
            return
        })
    }

}
