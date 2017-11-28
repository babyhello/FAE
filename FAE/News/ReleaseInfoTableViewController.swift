//
//  ReleaseInfoTableViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/8.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit

class ExpandTableSection
{
    var Title: String?
    var Collapse: Bool?
    
    init(Title: String?,Collapse: Bool?) {
        // Default type is Mine
        self.Title = Title
        self.Collapse = Collapse
        
    }
    
}


class ReleaseInfoContentTableViewCell:UITableViewCell{
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lbl_Content: UILabel!
    
    @IBOutlet weak var lbl_Date: UILabel!
    
    @IBOutlet weak var Img_Share: UIImageView!
    
    @IBOutlet weak var lbl_News: UILabel!
    
    @IBOutlet weak var VW_Content: UIView!
    
}

class ReleaseInfoTableViewController: UITableViewController {

    var SectionTitleArray = [ExpandTableSection]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let HeaderSectionCellNib = UINib(nibName: "ReleaseInfoTableViewHeaderSectionCell", bundle: nil)
        
        tableView.register(HeaderSectionCellNib, forCellReuseIdentifier: "HeaderSectionCell")
        
        let backgroundImage = UIImage(named: "bg_dragon")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        HeadArray()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func HeadArray()
    {
        
        SectionTitleArray.append(ExpandTableSection(Title: "GE63VR 7RE RAIDER", Collapse: true))
        
        SectionTitleArray.append(ExpandTableSection(Title: "GE70VR 7RE RAIDER", Collapse: true))
        
        SectionTitleArray.append(ExpandTableSection(Title: "GE73VR 7RE RAIDER", Collapse: true))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SectionTitleArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let someText:String = "Hello want to share text also"
        let objectsToShare:URL = URL(string: "http://msi.com.tw")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseInfoCell", for: indexPath) as! ReleaseInfoContentTableViewCell

        cell.lbl_News.isHidden = true

        cell.VW_Content.addBottomBorderWithColor(color: UIColor(hexString: "#363636"), width: 1)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.Img_Share.isUserInteractionEnabled = true
        cell.Img_Share.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let titleHeader =  SectionTitleArray[section].Title // Also set on button
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderSectionCell") as! ReleaseInfoTableViewCell
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectedSectionStoredButtonClicked(sender:)))
        
      
        headerCell.lbl_Title.text = SectionTitleArray[section].Title
        
        headerCell.lbl_Title.sizeToFit()
        
        headerCell.lbl_Title.numberOfLines = 0;
        
        //headerCell.lbl_Toggle_Title.text = !SectionTitleArray[section].Collapse! ? "v": ">"
        headerCell.Expend_Set(Expend: true)
        headerCell.contentView.tag = section
        
        headerCell.contentView.addGestureRecognizer(gesture)
        
        headerCell.Expend_Set(Expend: SectionTitleArray[section].Collapse!)
        //print(String(section) + "ViewForHeaderINsection")
        
        return headerCell.contentView
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return !SectionTitleArray[indexPath.section].Collapse! ? 0: 90
        
    }
    
    func selectedSectionStoredButtonClicked (sender:UITapGestureRecognizer) {
        
        let section = sender.view?.tag
        
        SectionTitleArray[section!].Collapse = !SectionTitleArray[section!].Collapse!
        
        tableView.beginUpdates()
        
        //let ProjectInfoArray =  ProjectInfroList.filter{$0.Model_Focus == SectionTitleArray[section!].Title}
        
        // tableView.reloadSections(section, with: .automatic)
        
        self.tableView.reloadSections(NSIndexSet(index: section!) as IndexSet, with: UITableViewRowAnimation.none)
        
        //        for i in 0 ..< ProjectInfoArray.count {
        //            tableView.reloadRows(at: [IndexPath(row: i, section: section!)], with: .automatic)
        //        }
        tableView.endUpdates()
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
extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

