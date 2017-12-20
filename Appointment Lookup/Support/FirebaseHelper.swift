//
//  FirebaseHelper.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/15/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import Foundation
import FirebaseDatabase


public class FirebaseHelper {
    
    static let rootRef = Database.database().reference()
    
    static func save(child: String!, value: String!) {
        print("FirebaseHelper: ", "Save");
        rootRef.child(child).setValue(value);
    }
    
    static func save(child: String!, uid: String!, value: NSDictionary!) {
        rootRef.child(child).child(uid).setValue(value);
    }
    
    static func delete(child: String!){
        rootRef.child(child).removeValue()
    }

}
