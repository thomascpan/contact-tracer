//
//  Contact.swift
//  contact-tracer
//
//  Created by Thomas Pan on 4/27/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import Foundation

struct Contact: Codable {
    private var uid:String
    private var datetime:Date
    
    func log(with fileName:String) {
        DataManager.append(self, with: fileName)
    }
    
    func saveItem() {
        DataManager.save(self, with: uid)
    }
    
    func deleteItem() {
        DataManager.delete(uid)
    }
    
    init(uid: String) {
        self.uid = uid
        self.datetime = Date()
    }
}
