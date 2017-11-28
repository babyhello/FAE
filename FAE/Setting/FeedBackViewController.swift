//
//  FeedBackViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/13.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MobileCoreServices
import AssetsLibrary
import AVFoundation
import AVKit
import Fusuma
import MediaPlayer
import Toast_Swift
import UICircularProgressRing
import MessageUI

class FeedBackViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,FusumaDelegate {
    
    @IBOutlet weak var txt_Subject: UITextField!
    
    @IBOutlet weak var txt_Description: UITextView!
    
    @IBOutlet weak var col_FeebackFile: UICollectionView!
    
    @IBOutlet weak var btn_Send: UIButton!
    
    @IBAction func btn_Send_Finish(_ sender: Any) {
        
        sendEmail()
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(txt_Subject.text!)
            mail.setToRecipients(["markycchen@msi.com"])
            mail.setMessageBody(txt_Description.text, isHTML: false)
           
            for File in AttactFileList
            {
                if let fileData = NSData(contentsOfFile: File.FilePath!) {
                    let theFileName = (File.FilePath! as NSString).lastPathComponent
                    
                    mail.addAttachmentData(fileData as Data, mimeType: "image/jpeg", fileName: theFileName)
                }
                
            }
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    var AttactFileList = [AttactFileItem]()
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        ImagePicker(image: image)
        
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func ImagePicker(image: UIImage)
    {
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName + ".jpg")
        
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            
            try? jpegData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            
            let _AttactFileItem = AttactFileItem()
            
            _AttactFileItem.FileImage = UIImage(contentsOfFile: imagePath)
            
            _AttactFileItem._FileType = AppClass.FileType.Image
            
            _AttactFileItem.FilePath = imagePath
            
            AttactFileList.append(_AttactFileItem)
            
            dismiss(animated: true, completion: nil)
            
            col_FeebackFile.reloadData()
        }
        
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
    }
    
    func fusumaClosed() {
        
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AttactFileList.count + 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FeedBack"
        // Do any additional setup after loading the view.
        
        col_FeebackFile.dataSource = self
        col_FeebackFile.delegate = self
        
        txt_Description.delegate = self
        txt_Description.text = "Please enter a description"
        txt_Description.textColor = UIColor(hexString: "#515156")
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hexString: "#515156") {
            textView.text = nil
            textView.textColor = UIColor(hexString: "#111113")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter a description"
            textView.textColor = UIColor(hexString: "#515156")
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if (indexPath.item != 0) {
            
            let Attactcell: AttactFileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttactFileCell", for: indexPath as IndexPath) as!  AttactFileCell
            
            let AttactFileItem = AttactFileList[indexPath.row - 1]
            
            AttactFileItem.FileIndex = indexPath.row
            
            switch AttactFileItem._FileType {
                
            case .Image?:
                
                Attactcell.AttactFileControl.PictureImage = UIImageView(image: UIImage(named: AttactFileItem.FilePath!))
                
                
                break
            case .Voice?:
                //            cell.AttactFileControl.ImagePath = UIImage(named: "btn_issue_audiovideo_play")
                
                Attactcell.AttactFileControl.VoicePath = AttactFileItem.FilePath
                break
            case .Video?:
                //            cell.AttactFileControl.ImagePath = UIImage(named: "btn_issue_audiovideo_play")
                
                Attactcell.AttactFileControl.VideoPath = AttactFileItem.FilePath
                break
            default:
                break
            }
            
            Attactcell.Btn_Delete.tag = indexPath.row
            
            Attactcell.Btn_Delete.addTarget(self, action: #selector(AttactFileDelete(button:)), for: .touchUpInside)
            
            cell = Attactcell
        }
        else
        {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Add", for: indexPath as IndexPath) as! UICollectionViewCell
            
            let tapTakePhoto = UITapGestureRecognizer(target:self, action:#selector(FeedBackViewController.Take_Photo(_:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapTakePhoto)
            
            //cell.backgroundView = UIImageView(image: UIImage(named: "btn_feedback_addphoto"))
        }
        
        return cell
    }
    
    func AttactFileDelete(button: UIButton) {
        
        AttactFileList.remove(at: button.tag - 1)
        
        self.col_FeebackFile.reloadData()
    }
    
    func Take_Photo(_ Photo:AnyObject)
    {
        
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.2
        
        self.present(fusuma, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
