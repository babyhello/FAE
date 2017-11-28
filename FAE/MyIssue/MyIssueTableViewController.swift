//
//  MyIssueTableViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/10/23.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class IssueInfo
{
    var Priority: UIImageView?
    var Author: String?
    var Owner:String?
    var Subject:String?
    var IssueDate:String?
    var IssueNo:String?
    var Status:String?
    var CreateDate:String?
    var WorkNoteCount:String?
    var ProjectName:String?
    var IssueRead:Int?
    var WorkNoteRead:Int?
    var PrioritySort:Int?
    var Work_ID:String?
    var lifeDate:Int?
}

class MyIssueTableViewCell:UITableViewCell{
    
    @IBOutlet weak var lbl_Issue_Read: UILabel!
    @IBOutlet weak var lbl_Model_Name: UILabel!
    @IBOutlet weak var lbl_Life_Date: UILabel!
    @IBOutlet weak var lbl_Issue_Date: UILabel!
    @IBOutlet weak var lbl_Issue_Reply_Count: UILabel!
    @IBOutlet weak var lbl_Issue_Subject: UILabel!
}

class MyIssueTableViewController: UITableViewController {
    
    var IssueArray = [IssueInfo]()
    
    var SelectedIssueIndex:Int = 0
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Issue"
        
        let backgroundImage = UIImage(named: "bg_dragon")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    
        self.refreshControl?.addTarget(self, action: #selector(MyIssueTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        initIndicator()
        
        Issue_List(AppUser.WorkID!,DateRange: 12)
    }
    
    func initIndicator()
    {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(activityIndicator)
    }
    
    func StartActivityIndicatory() {
        
        activityIndicator.startAnimating()
    }
    
    func StopActivityIndicatory() {
        activityIndicator.stopAnimating()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        Issue_List(AppUser.WorkID!,DateRange: 12)
        
      
        refreshControl.endRefreshing()
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
        return IssueArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssueCell", for: indexPath) as! MyIssueTableViewCell
        
        let str = IssueArray[(indexPath as NSIndexPath).row].CreateDate
        
        let row = indexPath.row
        
        let dateFor: DateFormatter = DateFormatter()
        
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let yourDate: Date? = dateFor.date(from: str!)
        
        cell.lbl_Issue_Date.text  = AppClass.DateStringtoShortDate(String(describing: yourDate!))
        
        cell.lbl_Model_Name.text = IssueArray[row].ProjectName
        
        if(IssueArray[row].lifeDate != nil)
        {
            cell.lbl_Life_Date.text = "Life:" + String(describing: IssueArray[row].lifeDate!) + "D"
        }
        else
        {
            cell.lbl_Life_Date.text = "Life:" + String(describing: " ") + "D"
        }
        
        
        
        cell.lbl_Issue_Subject.text = IssueArray[row].Subject
        
        cell.lbl_Issue_Read.isHidden = true
        
        cell.lbl_Issue_Reply_Count.isHidden = true
        
        return cell
    }
    
    func Issue_List(_ WorkID:String,DateRange:Int)
    {
        StartActivityIndicatory()
        
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_My_Issue_List", parameters: ["F_Keyin": WorkID,"DateRange":DateRange])
            .responseJSON { response in
                
                self.IssueArray = [IssueInfo]()
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        //print(Jstring)
                        
                        for IssueInfomation in (ObjectString )! {
                            
                            let IssueDetail = IssueInfo()
                            
                            if (IssueInfomation["F_Owner"] as? String) != nil {
                                
                                IssueDetail.Owner = IssueInfomation["F_Owner"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Owner = ""
                            }
                            
                            if (IssueInfomation["Issue_Author"] as? String) != nil {
                                
                                IssueDetail.Author =  IssueInfomation["Issue_Author"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Author =  ""
                            }
                            
                            if (IssueInfomation["F_SeqNo"] as? NSNumber) != nil {
                                
                                IssueDetail.IssueNo = String(describing: (IssueInfomation["F_SeqNo"] as! NSNumber))
                            }
                            else
                            {
                                IssueDetail.IssueNo = ""
                            }
                            
                            if (IssueInfomation["F_Priority"] as? String) != nil {
                                
                                IssueDetail.Priority =  AppClass.PriorityImage((IssueInfomation["F_Priority"] as? String)!)
                                
                                IssueDetail.PrioritySort = Int(IssueInfomation["F_Priority"] as! String)
                                
                            }
                            
                            if (IssueInfomation["F_Subject"] as? String) != nil {
                                
                                IssueDetail.Subject =  IssueInfomation["F_Subject"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Subject = ""
                            }
                            
                            if (IssueInfomation["F_CreateDate"] as? String) != nil {
                                
                                IssueDetail.CreateDate =  IssueInfomation["F_CreateDate"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.CreateDate = ""
                            }
                            
                            if (IssueInfomation["F_Status"] as? String) != nil {
                                
                                IssueDetail.Status =  IssueInfomation["F_Status"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Status = ""
                            }
                            if (IssueInfomation["WorkNotesCount"] as? Int64) != nil {
                                
                                IssueDetail.WorkNoteCount =  String(describing: IssueInfomation["WorkNotesCount"] as? Int64)
                                
                            }
                            else
                            {
                                IssueDetail.WorkNoteCount = ""
                            }
                            
                            if (IssueInfomation["Model"] as? String) != nil {
                                
                                IssueDetail.ProjectName =  IssueInfomation["Model"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.ProjectName = ""
                            }
                            if (IssueInfomation["Read"] as? NSNumber) != nil {
                                
                                IssueDetail.IssueRead =  Int((IssueInfomation["Read"] as? NSNumber)!)
                                
                            }
                            
                            
                            if (IssueInfomation["CommentRead"] as? NSNumber) != nil {
                                
                                IssueDetail.WorkNoteRead =  Int((IssueInfomation["CommentRead"] as? NSNumber)!)
                                
                            }
                            
                            if (IssueInfomation["LifeDate"] as? NSNumber) != nil {
                                
                                IssueDetail.lifeDate =  Int((IssueInfomation["LifeDate"] as? NSNumber)!)
                                
                            }
                            
                            
                            
                            self.IssueArray.append(IssueDetail)
                        }
                        
                        self.tableView.reloadData()
                        
                        self.StopActivityIndicatory()
                    }
                    
                    
                }
                
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MyissueToIssueInfo" {
            
            let ViewController = segue.destination as! IssueInfoViewController
            
            ViewController.IssueID = self.IssueArray[self.SelectedIssueIndex].IssueNo
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SelectedIssueIndex = indexPath.row
        
        performSegue(withIdentifier: "MyissueToIssueInfo", sender: self)
        
        
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
