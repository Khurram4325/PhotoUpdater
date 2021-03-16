//
//  Utility.swift
//  PhotoUpDater
//
//  Created by Khurram Shahzad on 10/04/2020.
//  Copyright © 2020 Khurram Shahzad. All rights reserved.
//

import UIKit
import Foundation

class Utility {

    static let shared = Utility()

    func showAlert(title: String, message: String?, cancelButton: Bool = false, okActionTitle: String = "OK", cancelActionTitle: String = "Cancel", isChangeCancelColor: Bool = false, cancelButtonColor: UIColor = UIColor.clear, isChangeOkColor: Bool = false, okButtonColor: UIColor = UIColor.clear, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: okActionTitle, style: .default) {
            _ in
            guard let completion = completion else { return }
            completion()
        }
        if isChangeOkColor { actionOK.setValue(okButtonColor, forKey: "titleTextColor") }
        alert.addAction(actionOK)
        
        let cancel = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        if isChangeCancelColor { cancel.setValue(cancelButtonColor, forKey: "titleTextColor") }
        if cancelButton { alert.addAction(cancel) }
        
        return alert
    }
}
