//
//  HomeViewController.swift
//  contact-tracer
//
//  Created by Thomas Pan on 4/25/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let contactFile = "contacts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DataManager.delete(contactFile)
//
//        let contacts = [Contact(uid: "1"), Contact(uid: "2"), Contact(uid: "3"), Contact(uid: "4")]
//
//        for contact in contacts {
//            contact.log(with: contactFile)
//        }
        
        let loadedContacts = DataManager.load(contactFile, with: Contact.self, lines: 0, offest: 0)
        
        for contact in loadedContacts {
            print(contact)
        }
        
        // Do any additional setup after loading the view.
    }

}
