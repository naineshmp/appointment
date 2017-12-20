//
//  NewApptTableViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/15/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit

class TimeSlotTabelViewCell: UITableViewCell {
    
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Slot: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
