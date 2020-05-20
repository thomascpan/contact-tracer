//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static let r: CGFloat = 82/255
    static let g: CGFloat = 200/255
    static let b: CGFloat = 250/255
    static let a: CGFloat = 1
    
//    static let r = CGFloat(48/255)
//    static let g = CGFloat(173/255)
//    static let b = CGFloat(99/255)
//    static let a = CGFloat(1)
    
    
    static func styleTextField(_ traitCollection:UITraitCollection, _ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: self.r, green: self.g, blue: self.b, alpha: self.a).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ traitCollection:UITraitCollection, _ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: self.r, green: self.g, blue: self.b, alpha: self.a)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ traitCollection:UITraitCollection, _ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 25.0
        if traitCollection.userInterfaceStyle == .light {
            button.tintColor = UIColor.black
            button.layer.borderColor = UIColor.black.cgColor
        } else {
            button.tintColor = UIColor.white
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isRememberMe() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaults.rememberMe)
    }
    
    static func setSession(_ uid: String) {
        UserDefaults.standard.set(uid, forKey: Constants.UserDefaults.uid)
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.rememberMe)
    }
    
    static func clearSession() {
        for key in Constants.UserDefaults.keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
