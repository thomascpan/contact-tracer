//
//  SignUpViewController.swift
//  contact-tracer
//
//  Created by Thomas Pan on 4/25/20.
//  Copyright © 2020 Thomas Pan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTextField.resignFirstResponder()
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(self.traitCollection, firstNameTextField)
        Utilities.styleTextField(self.traitCollection, lastNameTextField)
        Utilities.styleTextField(self.traitCollection, emailTextField)
        Utilities.styleTextField(self.traitCollection, phoneTextField)
        Utilities.styleTextField(self.traitCollection, passwordTextField)
        Utilities.styleFilledButton(self.traitCollection, signUpButton)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "phone": phone, "uid": result!.user.uid, "sync": false, "infected": false]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    self.initUserDefaults()
                    Utilities.setSession(result!.user.uid)
                    // Transition to the home screen
                    self.transitionToHome()
                }
                
            }
            
            
            
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func transitionToHome() {
        let contactTableViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.contactTableViewController) as? ContactTableViewController
        
        view.window?.rootViewController = contactTableViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func initUserDefaults() {
        UserDefaults.standard.set(false, forKey: "sync")
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
