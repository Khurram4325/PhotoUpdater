//
//  DateExtension.swift
//  PhotoUpDater
//
//  Created by Khurram Shahzad on 10/04/2020.
//  Copyright © 2020 Khurram Shahzad. All rights reserved.
//

import Foundation

public extension Date {
    
    func getString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
