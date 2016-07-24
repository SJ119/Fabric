//
//  ShowSplashScreen.swift
//  Fabric
//
//  Created by Parth Pancholi on 2016-07-13.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//
import Foundation
import UIKit

class ShowSplashScreen: UIViewController {
    
    var loggedout:Bool = false
    private var originalPassword:String = ""
    private var status:Bool = false
    //MARK: Properties
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var warning: UILabel!
    
    @IBOutlet weak var remainSignedIn: UISwitch!
//    var loggedout:Bool
    
    @IBAction func passwordTextBox(sender: UITextField) {
        let len = password.text!.characters.count
        if(len == 1)
        {
            self.originalPassword = ""
            self.originalPassword = self.originalPassword + String(password.text!.characters.last!)
//            print(self.originalPassword)
        }
        else if(password.text! == "")
        {
            self.originalPassword = ""
        }
        else if(password.text! != "")
        {
            self.originalPassword = self.originalPassword + String(password.text!.characters.last!)
//            print(self.originalPassword)
        }
        var newPW:String = ""
        for i in 0..<len{
            newPW = "*" + newPW
            
        }
        password.text = newPW
    }
    
    func resetProfile()
    {
        
    }
    
    func updateWarning(msg:String)
    {
        dispatch_async(dispatch_get_main_queue(), { self.warning.text = msg})
    }
    func shouldTransition() -> Bool {
        
        var actionB = false// || true
        var visited = false// || true
        
        userID.text = userID.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        password.text = password.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        originalPassword = originalPassword.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if (userID.text! != "" && password.text! != "")
        {
            
            userID.text = userID.text?.lowercaseString
            let url = "http://lit-plains-99831.herokuapp.com/confirm_user?name=" + userID.text! + "&password=" + self.originalPassword
            
            let requestURL: NSURL = NSURL(string: url)!
            
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                if error != nil {
                    //                    create a label for invalid password or userid
                    print("error=\(error)")
                    return
                }
                if response == nil {
                    print("empty response")
                }
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    //                    print(data.dynamicType)
                    //                let results = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    
                    do {
                        let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                        
                        if let parseJSON = myJSON {
                            let status = parseJSON["status"] as? String
                            if(status! == "OK")
                            {
                                self.updateWarning("SUCCESS")
                                actionB = true
                            }
                            else
                            {
                                self.updateWarning("UserID or Password is Incorrect")
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                    visited = true //                    print(results)
                }
            }
            
            task.resume()
            
        }
        else if (password.text! == "" && userID.text! == "")
        {
            self.updateWarning("USERID AND PASSWORD IS MISSING")
            visited = true
        }
        else if (password.text! == "")
        {
            self.updateWarning("PASSWORD IS MISSING")
            visited = true
        }
        else
        {
            self.updateWarning("USERID IS MISSING")
            visited = true
        }
        while(!visited)
        {
            
        }
        return actionB
    }
    func shouldRegister() -> Bool {
        
        var actionB = false
        var visited = false
        
        userID.text = userID.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        password.text = password.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        originalPassword = originalPassword.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if (userID.text! != "" && password.text! != "")
        {
            let url = "http://lit-plains-99831.herokuapp.com/get_task?name=" + userID.text!
            let requestURL: NSURL = NSURL(string: url)!
            
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest)
            {
                (data, response, error) -> Void in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                if response == nil {
                    print("empty response")
                }
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                        
                        if let parseJSON = myJSON {
                            let status = parseJSON["status"] as? String
                            if(status! == "Success!")
                            {
                                self.updateWarning("USERID ALREADY EXISTS")
                                
                            }
                            else
                            {
                                self.updateWarning("Registered")
                                let myUrl = NSURL(string: "http://lit-plains-99831.herokuapp.com/new_user?")
                                let request = NSMutableURLRequest(URL: myUrl!)
                                request.HTTPMethod = "POST"
                                let postString = "name=" + self.userID.text! + "&password=" + self.originalPassword
                                
                                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                
                                let innerTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
                                {
                                    (data, response, error) -> Void in
                                    
                                    if error != nil {
                                        print("error=\(error)")
                                        return
                                    }
                                    if response == nil {
                                        print("empty response")
                                    }
                                }
                                
                                let httpResponse = response as! NSHTTPURLResponse
                                let statusCode = httpResponse.statusCode
                                
                                if (statusCode == 200) {
                                    do {
                                        let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                                
                                        if let parseJSON = myJSON {
                                            let status = parseJSON["name"] as? String
                                            print(status!)
                                            actionB = true
                                        }
                                    }
                                    catch {
                                        print(error)
                                    }
                                    visited = true
                                }
                                innerTask.resume()
                                
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                    visited = true
                }
            }
            
            task.resume()
            
        }
        else if (password.text! == "" && userID.text! == "")
        {
            self.updateWarning("USERID AND PASSWORD IS MISSING")
            visited = true
        }
        else if (password.text! == "")
        {
            self.updateWarning("PASSWORD IS MISSING")
            visited = true
        }
        else
        {
            self.updateWarning("USERID IS MISSING")
            visited = true
        }
        while(!visited)
        {
            
        }
        return actionB
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSplashScreen" || segue.identifier == "registered" || segue.identifier == "autoSeg" {
            let tabBarViewController = segue.destinationViewController as! UITabBarController
            let achievementsViewController = tabBarViewController.childViewControllers[0].childViewControllers[0] as? AchievementsViewController
            achievementsViewController!.username = self.userID.text!
            let taskTableViewController = tabBarViewController.childViewControllers[2].childViewControllers[0] as? TaskTableViewController
            taskTableViewController!.username = self.userID.text!
        }
    }
    
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "showSplashScreen" {
                // DO LOGIN IN AUTHENTICATION, IF SUCCESSFUL RETURN TRUE HERE, ELSE RETURN FALSE
                var res = false
                
                res = shouldTransition()
                if(res)
                {
                    status = remainSignedIn.on
//                    print(status)
                    if(status)
                    {
                        saveUser(true)
                        print("user wants to be saved")
                    }
                    else
                    {
                        saveUser(false)
                        print("user does not want to be saved")
                    }
                    
                }
                return res
            }
            else if ident == "registered"
            {
                var res = false
                res = shouldRegister()
                if(res)
                {
                    status = remainSignedIn.on
                    print(status)
                    if(status)
                    {
                        saveUser(true)
                    }
                    else
                    {
                        saveUser(false)
                    }
                }
                return res
            }
            else if ident == "autoSeg"
            {
                return true
            }
        }
        return true
    }
    
    
    
    override func viewDidLoad()
    {
        print("ready")
        remainSignedIn.on = false
        super.viewDidLoad()
        
        
//        print("TRYING TO CHECK LOGOUT")
        
        if(loggedout)
        {
            
        }
        else
        {
            if let currentUser:User = loadUser()
            {
                if(currentUser.status)
                {
                    let len = currentUser.password.characters.count
                    var newPW:String = ""
                    for i in 0..<len{
                        newPW = "*" + newPW
                        
                    }
                    password.text = newPW
                    userID.text = currentUser.userid
                    originalPassword = currentUser.password
                    remainSignedIn.on = currentUser.status
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.performSegueWithIdentifier("autoSeg", sender: self)
                    }
                }
            }
            else
            {
                //            print("NOTHING SAVED")
            }
        }
    }
    func showNavController(){
        sleep(2);
        performSegueWithIdentifier("showSplashScreen", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

    func saveUser(save:Bool) {
        let currentUser:User
        if(save)
        {
            currentUser = User(userid: self.userID.text!, password: self.originalPassword, status: self.status)!
//            print("wants to save")
        }
        else
        {
            currentUser = User(userid: self.userID.text!, password: self.originalPassword, status: false)!
//            print("does not want to save")
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currentUser, toFile: User.ArchiveURL.path!)
        
        if !isSuccessfulSave
        {
            print("Failed to save user information!")
        }
        else
        {
            print("saved")
        }
    }
    
    func loadUser() -> User?{
        
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(User.ArchiveURL.path!))
        {
            return (NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User)!
        }
        return User(userid: "",password: "",status: false)
    }
}
