//
//  ContactViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-23.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var NickNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var statusLabel: UILabel!
    
    var contacts = [Contact]()
    
    var checked = false
    var callback_called = false
    
    // contact ispassed by `ContactTableViewController` in `prepareForSegue(_:sender:)`
    // or constructed as part of adding a new contact.
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add any additional setup to load the view, typically from nib
        if let contact = contact {
            navigationItem.title = contact.name
            photoImageView.image = contact.photo
            UserNameTextField.text = contact.name
            NickNameTextField.text = contact.nickName
            EmailTextField.text = contact.email
            UserNameTextField.userInteractionEnabled = false;
        }
        
        //Handle the text field's user input through delegate callbacks.
        UserNameTextField.delegate = self
        NickNameTextField.delegate = self
        EmailTextField.delegate = self
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // use this function to send a friend request to another user
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // grab the original image
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        
        //Dismiss the picker once picture is chosen
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        //let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        let isPresentingInAddTaskMode = presentingViewController is UITabBarController
        if isPresentingInAddTaskMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if saveButton === sender {
            let userName = UserNameTextField.text ?? ""
            
            let whitespace = NSCharacterSet.whitespaceCharacterSet()
            
            
            let range = userName.rangeOfCharacterFromSet(whitespace)
            
            // range will be nil if no whitespace is found
            if range != nil {
                self.statusLabel.text = "User does not exist!"
                return false
            }
            
            for contact in contacts {
                if contact.name == userName {
                    self.statusLabel.text = "Username already exists in contacts!"
                    return false
                }
            }
            
            checked = false
            callback_called = false
            
            JsonManager.getInstance().check(userName) {
                data in
                print("entered callback")
                var message = ""
                do {
                    print(data)
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                    message = jsonDict["message"] as! String
                    if message == "Password does not match" {
                        self.checked = true
                    }
                    
                } catch {
                    print("caught")
                }
                self.callback_called = true
            }
            
            while !checked && !callback_called {
                let _ = "a"
            }
            
            if !self.checked {
                self.statusLabel.text = "User does not exist!"
            } else {
                self.statusLabel.text = ""
            }
            
            return checked
        } else {
            return false
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let userName = UserNameTextField.text ?? ""
            let nickName = NickNameTextField.text ?? ""
            let email = EmailTextField.text ?? ""
            let photo = photoImageView.image
            
            
            
            contact = Contact(name: userName, nickName: nickName, email: email, photo: photo, sending: false)
        }
        
    }
    
    //MARK: Actions
    @IBAction func selectPhotoFromLibrary(sender: UITapGestureRecognizer) {
        //Hide the keyboard when user taps the image view
        UserNameTextField.resignFirstResponder()
        NickNameTextField.resignFirstResponder()
        EmailTextField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ContactViewController is notified when the user picks an image
        imagePickerController.delegate = self
        // the following line asks the controller to present the view defined by imagePickerController
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
}
