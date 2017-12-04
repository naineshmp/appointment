////
////  Menu.swift
////  test
////
////  Created by Dominic Heaton on 22/10/2017.
////  Copyright © 2017 Dominic Heaton. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
////import FirebaseDatabase
//
//class Menu: UIViewController {
//
//    var finalResultsSWE = Double()
//    var finalResultsPDE = Double()
//    var finalResultsTowre = Double()
//
//    var finalResultsDigit = Double()
//    var finalResultsRevDigit = Double()
//    var finalResultsDigitSpan = Double()
//
//    var copyBestWordsWritten = Double()
//    var copyFastWordsWritten = Double()
//    var copyAlphabetTotalWritten = Double()
//    var freeWritingTotalWritten = Double()
//    var finalResultDash = Double()
//
//    var finalResultBPVS = Double()
//    var finalErrorsBPVS = Double()
//    var finalSetBPVS = Double()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //For debugging
//        print("SWE        :", finalResultsSWE)
//        print("PDE        :", finalResultsPDE)
//        print("Towre      :", finalResultsTowre)
//        print("For D      :", finalResultsDigit)
//        print("Rev D      :", finalResultsRevDigit)
//        print("Span       :", finalResultsDigitSpan)
//        print("CopyB      :", copyBestWordsWritten)
//        print("CopyF      :", copyFastWordsWritten)
//        print("CopyA      :", copyAlphabetTotalWritten)
//        print("FreeW      :", freeWritingTotalWritten)
//        print("DASH       :", finalResultDash)
//        print("BPVS Raw   :", finalResultBPVS)
//        print("BPVS Errors:", finalErrorsBPVS)
//        print("BPVS Set No:", finalSetBPVS)
//
//        //override the back button in the navigation controller
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(self.signOut(sender:)))
//
//        let testScoresToSave: [Double]! = [finalResultsSWE, finalResultsPDE, finalResultsDigit, finalResultsRevDigit, finalResultsTowre, finalResultsDigitSpan, copyBestWordsWritten, copyFastWordsWritten, copyAlphabetTotalWritten, freeWritingTotalWritten, finalResultDash, finalResultBPVS, finalErrorsBPVS, finalSetBPVS]
//
//        if testScoresToSave[0] != 0 || testScoresToSave[1] != 0 || testScoresToSave[2] != 0 || testScoresToSave[3] != 0 || testScoresToSave[4] != 0 || testScoresToSave[5] != 0 || testScoresToSave[6] != 0 || testScoresToSave[7] != 0 || testScoresToSave[8] != 0 || testScoresToSave[9] != 0 || testScoresToSave[10] != 0 || testScoresToSave[11] != 0 || testScoresToSave[12] != 0 || testScoresToSave[13] != 0 {
//            saveResults()
//        }
//
//    }
//
//    func saveResults() {
//        var refDatabase: DatabaseReference!
//        refDatabase = Database.database().reference().child("results").child("user")
//
//        let userName = Auth.auth().currentUser?.email
//        let uid = Auth.auth().currentUser?.uid
//        let key = refDatabase.child(uid!).key
//
//        var userResults: [String : Any]
//
//        if finalResultsTowre == 0 && finalResultDash == 0 && finalResultBPVS == 0 {
//            userResults = ["username":userName!, "Forward Digit Span":finalResultsDigit, "Reverse Digit Span":finalResultsRevDigit, "Digit Span":finalResultsDigitSpan] as [String : Any]
//        }
//        else if finalResultsDigitSpan == 0 && finalResultDash == 0 && finalResultBPVS == 0 {
//            userResults = ["username":userName!, "TowreSWE":finalResultsSWE, "TowrePDE":finalResultsPDE, "Towre-2":finalResultsTowre] as [String : Any]
//        }
//        else if finalResultsDigitSpan == 0 && finalResultsTowre == 0 && finalResultBPVS == 0 {
//            userResults = ["username":userName!, "Dash CopyBest":copyBestWordsWritten, "Dash CopyFast":copyFastWordsWritten, "Dash CopyAlpha":copyAlphabetTotalWritten, "Dash Free":freeWritingTotalWritten, "Dash Final":finalResultDash] as [String : Any]
//        }
//        else if finalResultsTowre == 0 && finalResultDash == 0 && finalResultsDigitSpan == 0 {
//            userResults = ["username":userName!, "BPVS Final":finalResultBPVS, "BPVS Errors":finalErrorsBPVS, "BPVS Set Num":finalSetBPVS] as [String : Any]
//        }
//        else {
//            userResults = ["username":userName!, "TowreSWE":finalResultsSWE, "TowrePDE":finalResultsPDE, "Towre-2":finalResultsTowre, "Digit Span":finalResultsDigit, "Reverse Digit Span":finalResultsRevDigit, "Digit Span":finalResultsDigitSpan, "Dash CopyBest":copyBestWordsWritten, "Dash CopyFast":copyFastWordsWritten, "Dash CopyAlpha":copyAlphabetTotalWritten, "Dash Free":freeWritingTotalWritten, "Dash Final":finalResultDash, "BPVS Final":finalResultBPVS, "BPVS Errors":finalErrorsBPVS, "BPVS Set Num":finalSetBPVS] as [String : Any]
//        }
//        refDatabase.child(key).updateChildValues(userResults)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    @objc func signOut(sender: AnyObject) {
//
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//        self.performSegue(withIdentifier: "signOut", sender: nil)
//    }
//
//}
//
