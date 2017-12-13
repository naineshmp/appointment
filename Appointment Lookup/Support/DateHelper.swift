//
//  DateHelper.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/12/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import Foundation

class DateHelper
{
    static func convertDateToString(date: Date) -> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        return dateFormat.string(from: date)
    }
}
