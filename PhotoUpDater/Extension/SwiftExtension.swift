//
//  SwiftExtension.swift
//  PhotoUpDater
//
//  Created by Khurram Shahzad on 11/04/2020.
//  Copyright © 2020 Khurram Shahzad. All rights reserved.
//

import Foundation

extension String {
    
    func getDateString(fromFormat: String, toFormat: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = fromFormat
        df.timeZone = NSTimeZone.local
        df.calendar = NSCalendar.current
        
        guard let dateFromString = df.date(from: self) else {
            return ""
        }
        
        df.dateFormat = toFormat
        return df.string(from: dateFromString)
    }
    
    func getDate(toFormat: String) -> Date? {

        let df = DateFormatter()
        df.dateFormat = toFormat
        df.timeZone = NSTimeZone.local
        df.calendar = NSCalendar.current

        guard let dateFromString = df.date(from: self) else {
            return nil
        }

        return dateFromString
    }
}
