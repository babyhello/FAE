//
//  SettingTableViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/9.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit
import Alamofire

class SettingTableViewController: UITableViewController {
    
    var ServerVersion = ""
    var LocalVersion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "bg_dragon")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        LocalVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        
        GetServerVersion()
        
        //self.tableView.allowsSelection = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func NotificationChanged(_ switchState: UISwitch) {
        if switchState.isOn {
           UIApplication.shared.registerForRemoteNotifications()
        } else {
          UIApplication.shared.unregisterForRemoteNotifications()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
        
        switch (indexPath as NSIndexPath).row {
            
        case 1:
            GetServerVersion()
            //self.performSegueWithIdentifier("SettingToFont", sender: self)
            break
        case 2:
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            break
        case 3:
            
            performSegue(withIdentifier: "FontSizeChange", sender: nil)
            
            
            break
            
        case 4:
            performSegue(withIdentifier: "GoFeedBack", sender: nil)
            break
            
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        //        let clearView = UIView()
        //        clearView.backgroundColor = UIColor.clear
        //        cell.selectedBackgroundView = clearView
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.imageView?.image = UIImage(named: "ic_setting_version")
            
            cell.textLabel!.text = "Current Version"
            
            cell.detailTextLabel!.text = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            
            cell.textLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.textLabel!.textColor = UIColor(hexString: "#FFFFFF")
            
            cell.detailTextLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.detailTextLabel!.textColor = UIColor(hexString: "#BBBAC0")
            
            cell.accessoryView?.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.isUserInteractionEnabled = false
            
            cell.accessoryType = .none
            
        case 1:
            cell.imageView?.image = UIImage(named: "ic_setting_updateversion")
            
            cell.textLabel!.text = "Update Version"
            
            cell.detailTextLabel!.text = ServerVersion
            
            cell.textLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.textLabel!.textColor = UIColor(hexString: "#FFFFFF")
            
            cell.detailTextLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.detailTextLabel!.textColor = UIColor(hexString: "#BBBAC0")
            
            cell.accessoryView?.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.isUserInteractionEnabled = false
            
            cell.accessoryType = .none
        case 2:
            cell.imageView?.image = UIImage(named: "ic_setting_notifications")
            
            cell.textLabel!.text = "Notification"
            
            cell.detailTextLabel!.text = ""
            
            let NotificationSwitch :UISwitch = UISwitch()
            
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            if isRegisteredForRemoteNotifications {
                NotificationSwitch.isOn = true
            } else {
                 NotificationSwitch.isOn = false
            }
            
            NotificationSwitch.addTarget(self, action: #selector(SettingTableViewController.NotificationChanged(_:)), for: .valueChanged)
            
            
            cell.accessoryView = NotificationSwitch
            
            cell.textLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.textLabel!.textColor = UIColor(hexString: "#FFFFFF")
            
            cell.detailTextLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.detailTextLabel!.textColor = UIColor(hexString: "#BBBAC0")
            
            cell.accessoryView?.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.backgroundColor = UIColor(hexString: "#18171A")
        case 3:
            cell.imageView?.image = UIImage(named: "ic_setting_fontsize")
            
            cell.textLabel!.text = "Font Size"

            cell.detailTextLabel!.text = ""
            
            cell.textLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.textLabel!.textColor = UIColor(hexString: "#FFFFFF")
            
            cell.detailTextLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.detailTextLabel!.textColor = UIColor(hexString: "#BBBAC0")
            
            cell.accessoryView?.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.backgroundColor = UIColor(hexString: "#18171A")
            
        case 4:
            cell.imageView?.image = UIImage(named: "ic_setting_feedback")
            
            cell.textLabel!.text = "Feedback"
            
            cell.detailTextLabel!.text = ""
            
            cell.textLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.textLabel!.textColor = UIColor(hexString: "#FFFFFF")
            
            cell.detailTextLabel!.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.detailTextLabel!.textColor = UIColor(hexString: "#BBBAC0")
            
            cell.accessoryView?.backgroundColor = UIColor(hexString: "#18171A")
            
            cell.backgroundColor = UIColor(hexString: "#18171A")
        default:
            break
        }
        
        cell.addBottomBorderWithColor(color: UIColor(hexString: "#363636"), width: 1)
        
        return cell
    }
    
    func GetServerVersion()
    {
        
        var PlistPath = ""
        
        var PathPath = ""
        
        Alamofire.request(AppClass.ServerPath + "/FAE_App_Service.asmx/Get_IOS_Version")
            
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let IssueInfo = ObjectString!
                        
                        
                        if IssueInfo.count > 0
                        {
                            
                            if (IssueInfo[0]["Path"] as? String) != nil {
                                
                                PlistPath = (IssueInfo[0]["Path"] as? String)!
                                
                            }
                            if (IssueInfo[0]["PagePath"] as? String) != nil {
                                
                                PathPath = (IssueInfo[0]["PagePath"] as? String)!
                                
                            }
                        }
                        
                        if(!PlistPath.isEmpty && !PathPath.isEmpty)
                        {
                            self.checkForUpdates(PlistPath, HtmlPath: PathPath)
                        }
                        
                    }
                    else
                    {
                    }
                    
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
        }
        
        
    }
    
    
    func checkForUpdates(_ PlistPath:String,HtmlPath:String) {
        
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async(execute: {
                
                let categoriesURL =  URL(string: PlistPath)
                //let dict = NSDictionary(contentsOfURL: categoriesURL!)
                
                let updateDictionary = NSDictionary(contentsOf: categoriesURL!)
                
                let items = updateDictionary?["items"]
                let itemDict = (items as AnyObject).lastObject as! NSDictionary
                let metaData = itemDict["metadata"] as! NSDictionary
                let serverVersion = metaData["bundle-version"] as! String
                let localVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
                let updateAvailable = serverVersion.compare(localVersion, options: .numeric) == .orderedDescending;
                self.ServerVersion = serverVersion
                
                self.tableView.reloadData()
                
                //                if updateAvailable {
                //                    self.showUpdateDialog(serverVersion,PagePath:HtmlPath)
                //                }
                //                else
                //                {
                //                    let alertController = UIAlertController(title: "Is New Version", message:
                //                        "", preferredStyle: UIAlertControllerStyle.alert)
                //
                //                    self.present(alertController, animated: true, completion: nil)
                //                }
            })
        }
        
        
    }
    
    func showUpdateDialog(_ serverVersion: String,PagePath:String) {
        DispatchQueue.main.async(execute: { () -> Void in
            
            
            
            let alertController = UIAlertController(title: "New version available!", message:
                "New Version \(serverVersion) has been released. Would you like to download it now?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Not now", style: .cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: PagePath)! as URL)
            }))
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
        })
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
