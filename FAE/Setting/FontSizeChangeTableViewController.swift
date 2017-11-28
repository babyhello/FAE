//
//  FontSizeChangeTableViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/13.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit

class FontSizeChangeTableViewController: UITableViewController {
    
    var SelectedIndex = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Font Size"
        
        let backgroundImage = UIImage(named: "bg_dragon")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
      
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       
        
        
        
        
        
        
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontSizeChangeCell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel!.backgroundColor = UIColor(hexString: "#18171A")
        
        cell.textLabel!.textColor = UIColor(hexString: "#FFFFFF")
        
        cell.backgroundColor = UIColor(hexString: "#18171A")
        
        var FonSizeNumber:Double = 0
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.textLabel!.text = "Small"
            cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(0.4 * 40.0))
            FonSizeNumber = 0.4 * 40.0
            
        case 1:
            cell.textLabel!.text = "Medium"
            cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(0.45 * 40.0))
            FonSizeNumber = 0.45 * 40.0
        case 2:
            cell.textLabel!.text = "Large"
            cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(0.5 * 40.0))
             FonSizeNumber = 0.5 * 40.0
        default:
            break
        }
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let SettingData = Setting.Get_Setting(moc)
        
        if SettingData.count > 0 {
            if(FonSizeNumber == SettingData[0].fontsize)
            {
                cell.accessoryType = .checkmark
            }
        }
        
        
        cell.addBottomBorderWithColor(color: UIColor(hexString: "#363636"), width: 1)
        
       
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                var FonSizeNumber:Double = 0
                
                switch (indexPath as NSIndexPath).row {
                case 0:
                    FonSizeNumber = 0.4 * 40.0
                    
                case 1:
                    FonSizeNumber = 0.45 * 40.0
                    
                case 2:
                    FonSizeNumber = 0.5 * 40.0
                    
                default:
                    break
                }
                
                UILabel.appearance().font = UIFont.systemFont(ofSize: CGFloat(FonSizeNumber))
                
                UILabel.appearance().adjustsFontSizeToFitWidth = true
                
                let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                
                let SettingData = Setting.Get_Setting(moc)
                
                if SettingData.count > 0 {
                    Setting.Update_Setting(moc, id: 1, fontsize: FonSizeNumber, notification: false)
                }
                else
                {
                    Setting.addSetting(moc, id: 1, fontsize: FonSizeNumber, notification: false)
                }
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
//
//        selectedCell.accessoryType = .none
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
