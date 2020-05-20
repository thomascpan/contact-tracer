//
//  DataManager.swift
//  contact-tracer
//
//  Created by Thomas Pan on 4/27/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import Foundation
import Firebase

public class DataManager {
    // Append
    static func append <T:Encodable> (_ object:T, with fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        appendHelper(atPath: url, withEncoder: encoder, object)
    }
    
    static func append <T:Encodable> (_ objects:[T], with fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        for object in objects {
            appendHelper(atPath: url, withEncoder: encoder, object)
        }
    }
    
    
    // Load (lines, offset)
    static func load <T:Decodable> (_ fileName:String, with type:T.Type, lines:Int, offest:Int) -> [T] {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        var modelObjects = [T]()
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let str = try? String(contentsOf: url, encoding: .utf8) {
                let strs = str.components(separatedBy: .newlines)
                for s in strs {
                    if !s.isEmpty {
                        do {
                            let model = try JSONDecoder().decode(type, from: s.data(using: .utf8)!)
                            modelObjects.append(model)
                        } catch{
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            } else{
                fatalError("Data unavailable at path \(url.path)")
            }
        }
        
        return modelObjects
    }
    
    
    // get Document Directory
    static fileprivate func getDocumentDirectory () -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }else{
            fatalError("Unable to access document directory")
        }
    }
    
    // Save any kind of codable objects
    static func save <T:Encodable> (_ object:T, with fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    
    // Load any kind of codable objects
    static func load <T:Decodable> (_ fileName:String, with type:T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }catch{
                fatalError(error.localizedDescription)
            }
            
        }else{
            fatalError("Data unavailable at path \(url.path)")
        }
        
    }
    
    
    // Load data from a file
    static func loadData (_ fileName:String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            return data
            
        }else{
            fatalError("Data unavailable at path \(url.path)")
        }
        
    }
    
    // Load all files from a directory
    static func loadAll <T:Decodable> (_ type:T.Type) -> [T] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [T]()
            
            for fileName in files {
                modelObjects.append(load(fileName, with: type))
            }
            
            return modelObjects
            
            
        }catch{
            fatalError("could not load any files")
        }
    }
    
    
    // Delete a file
    static func delete (_ fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }catch{
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private static func appendHelper <T:Encodable> (atPath url: URL, withEncoder encoder: JSONEncoder, _ object:T) {
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                if let fileUpdater = try? FileHandle(forUpdating: url) {
                    fileUpdater.seekToEndOfFile()
                    fileUpdater.write(data)
                    fileUpdater.write("\n".data(using: .utf8)!)
                    fileUpdater.closeFile()
                }
            } else {
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
                if let fileUpdater = try? FileHandle(forUpdating: url) {
                    fileUpdater.seekToEndOfFile()
                    fileUpdater.write("\n".data(using: .utf8)!)
                    fileUpdater.closeFile()
                }
            }

        } catch{
            fatalError(error.localizedDescription)
        }
    }
    
    static func removeOld (_ fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }catch{
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func upload () {
        let db = Firestore.firestore()
        
        
//        db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid, "sync":false]) { (error) in
//            
//            if error != nil {
//                // Show error message
//                self.showError("Error saving user data")
//            }
//        }
    }
}
