//
//  CGSizeExtension.swift
//  PhotoUpDater
//
//  Created by Khurram Shahzad on 11/04/2020.
//  Copyright © 2020 Khurram Shahzad. All rights reserved.
//

import UIKit
import Foundation

public extension CGSize {
    
    func toPixel() -> CGSize {
        let scale = UIScreen.main.scale
        
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}
