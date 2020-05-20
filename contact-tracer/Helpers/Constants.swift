//
//  Constants.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-23.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Constants {
    
    struct Storyboard {
        static let viewController = "VC"
        static let homeViewController = "HomeVC"
        static let contactTableViewController = "ContactTVC"
    }
    
    static let SERVICE_UUID = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF5")
    static let RX_UUID = CBUUID(string: "3B66D024-2336-4F22-A980-8095F4898C42")
    static let RX_PROPERTIES: CBCharacteristicProperties = .write
    static let RX_PERMISSIONS: CBAttributePermissions = .writeable
    
    struct UserDefaults {
        static let uid = "uid"
        static let rememberMe = "rememberMe"
        static let keys = [uid, rememberMe]
    }
    
}
