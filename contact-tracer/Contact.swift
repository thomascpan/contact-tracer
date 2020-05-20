//
//  Contact.swift
//  contact-tracer
//
//  Created by Thomas Pan on 4/27/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var uid:String
    var contactUid:String
    var datetime:Date
    
    var formattedDatetime:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
        return formatter.string(from: datetime)
    }
    
    func log(with fileName:String) {
        DataManager.append(self, with: fileName)
    }
    
    func saveItem() {
        DataManager.save(self, with: uid)
    }
    
    func deleteItem() {
        DataManager.delete(uid)
    }
    
    init(uid: String, contactUid: String) {
        self.uid = uid
        self.contactUid = contactUid
        self.datetime = Date()
    }
}
