//
//  ContactTableViewController.swift
//  contact-tracer
//
//  Created by Thomas Pan on 5/2/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import UIKit
import CoreBluetooth

class ContactTableViewController: UITableViewController {
    let contactFile = "contacts"
    var contacts:[Contact]!
    var newContacts = Dictionary<String, Contact>()
    var timer = Timer()
    
    var peripheralManager = CBPeripheralManager()
    var centralManager: CBCentralManager?
    
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSyncButton()
        loadData()
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func loadData() {
        DataManager.delete(contactFile)
        
        contacts = [Contact]()
        contacts = DataManager.load(contactFile, with: Contact.self, lines: 0, offest: 0).sorted(by: {$0.datetime < $1.datetime})
        tableView.reloadData()
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        scheduledTimerWithTimeInterval()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        Utilities.clearSession()
        transitionToView()
    }
    
    @IBAction func syncData(_ sender: Any) {
        let sync = UserDefaults.standard.bool(forKey: "sync")
        
        print("syncData: \(sync)")
        
        var title = "Sync"
        var message = "This grants contact-tracer access to your contacts data."
        
        if sync {
            title = "Unsync"
            message = "This revokes contact-tracer from receiving anymore data."
        }
        
        let syncAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        syncAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action:UIAlertAction) in
            UserDefaults.standard.set(!sync, forKey: "sync")
            self.setupSyncButton()
        }))
        
        syncAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(syncAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell

        let contact = contacts[indexPath.row]
        
        cell.contactLabel.text = "\(contact.formattedDatetime) - \(contact.contactUid)"

        return cell
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.clearPeripherals), userInfo: nil, repeats: true)
    }
    
    @objc func clearPeripherals(){
        updateContacts()
        tableView?.reloadData()
    }
    
    func updateAdvertisingData() {
        
//        if (peripheralManager.isAdvertising) {
//            peripheralManager.stopAdvertising()
//        }
        
        if let userUid = UserDefaults.standard.string(forKey: "uid") {
            let advertisementData = String(format: "%@", userUid)
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
        }
    }
    
    func updateContacts() {
        let newContactsList = Array(newContacts.values).sorted(by: {$0.datetime < $1.datetime})
        DataManager.append(newContactsList, with: contactFile)
        contacts+=newContactsList
        newContacts.removeAll()
    }
    
    func setupSyncButton() {
        let sync = UserDefaults.standard.bool(forKey: "sync")
        
        if sync {
            self.syncButton.title = "Unsync"
        } else {
            self.syncButton.title = "Sync"
        }
    }
    
    func transitionToView() {
        let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
}

extension ContactTableViewController : CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn){
            updateAdvertisingData()
        }
    }
}

extension ContactTableViewController : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            if let userUid = UserDefaults.standard.string(forKey: "uid") {
                let contact = Contact(uid: userUid, contactUid: advertisementName)
                newContacts[contact.contactUid] = contact
            }
        }
    }
}
