//
//  ViewController.swift
//  contact-tracer
//
//  Created by Thomas Pan on 4/25/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        
        if Utilities.isRememberMe() {
            transitionToHome()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupElements()
    }

    func setupElements() {
        Utilities.styleFilledButton(self.traitCollection, signUpButton)
        Utilities.styleHollowButton(self.traitCollection, loginButton)
    }

    func transitionToHome() {
        print("transitionToHome")
        let contactTableViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.contactTableViewController) as? ContactTableViewController
        
        view.window?.rootViewController = contactTableViewController
        view.window?.makeKeyAndVisible()
        
    }
}

