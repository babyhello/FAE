//
//  IssueInfoViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/10/24.
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


class IssueInfoAttactFileCell:UICollectionViewCell{
    
    @IBOutlet weak var AttactFileController: AttactFileViewController!
}

class IssueInfoTableViewCell:UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var lbl_Content_Constraint: NSLayoutConstraint!
    
    var Issue_File_List = [Issue_File]()
    
    @IBOutlet weak var lbl_Reply_Title: UILabel!
    
    @IBOutlet weak var lbl_Reply_Date: UILabel!
    
    @IBOutlet weak var lbl_Reply_Content: UILabel!
    
    @IBOutlet weak var Col_CommeFile_Attact: UICollectionView!
    
    func Set_Source(FileList:[Issue_File]) {

        Issue_File_List = FileList
    
        Col_CommeFile_Attact.delegate = self
        Col_CommeFile_Attact.dataSource = self
      
        Col_CommeFile_Attact.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return Issue_File_List.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCommentAttactCell", for: indexPath) as!  IssueInfoAttactFileCell
        
        let AttactFileItem = Issue_File_List[indexPath.row]

        switch AttactFileItem.FileType {

        case .Image?:

            cell.AttactFileController.ImagePath = AttactFileItem.FilePath

            break
        case .Voice?:

            cell.AttactFileController.VoicePath = AttactFileItem.FilePath
            break
        case .Video?:

            cell.AttactFileController.VideoPath = AttactFileItem.FilePath
            break
        default:
            break
        }
        
       return cell
    }
}


class Issue_File
{
    var FilePath: String?
    var FileType: AppClass.FileType?
}

class Issue_Command
{
    var Command_Author: String?
    var Command_Time: String?
    var Command_Content: String?
    var Command_Author_WorkID:String?
    var Command_File:String?
    //var FileType: String?
}


class IssueInfoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,FusumaDelegate,UINavigationControllerDelegate {
    
   
    
    
    @IBOutlet weak var btn_Send: UIButton!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lbl_Date: UILabel!
    
    @IBOutlet weak var lbl_Subject: UILabel!
    
    @IBOutlet weak var col_AttactFile: UICollectionView!
    
    @IBOutlet weak var tb_Reply: UITableView!
    
    @IBOutlet weak var Img_Camera: UIImageView!
    
    @IBOutlet weak var Img_Video: UIImageView!
    
    @IBOutlet weak var Img_Microphone: UIImageView!
    
    @IBOutlet weak var txt_Reply_Content: UITextField!
    
    @IBOutlet weak var VW_Bottom_Height: NSLayoutConstraint!
    
    @IBOutlet weak var Vw_Progress: UICircularProgressRingView!
    
    var Issue_File_List = [Issue_File]()
    var Issue_Command_List = [Issue_Command]()
    var recoder_manager = VoiceRecord()//初始化
    var IssueID:String?
    var MicrophonRecord = false
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "bg_dragon")
        let imageView = UIImageView(image: backgroundImage)
        self.tb_Reply.backgroundView = imageView
       
        self.hideKeyboardWhenTappedAround()
        
        col_AttactFile.dataSource = self
        col_AttactFile.delegate = self
        
        tb_Reply.dataSource = self
        tb_Reply.delegate = self
        
        self.tb_Reply.estimatedRowHeight = 70
        
        self.tb_Reply.rowHeight = UITableViewAutomaticDimension
        
        Get_Issue_Info(IssueID!)
        
        btn_Send.layer.cornerRadius = 5.0
        
        btn_Send.layer.masksToBounds = true
        
        let TakePhoto = Img_Camera
        let tapTakePhoto = UITapGestureRecognizer(target:self, action:#selector(IssueInfoViewController.Take_Photo(_:)))
        TakePhoto?.isUserInteractionEnabled = true
        TakePhoto?.addGestureRecognizer(tapTakePhoto)
        
        let TakeVideo = Img_Video
        let tapTakeVideo = UITapGestureRecognizer(target:self, action:#selector(IssueInfoViewController.Take_Video(_:)))
        TakeVideo?.isUserInteractionEnabled = true
        TakeVideo?.addGestureRecognizer(tapTakeVideo)
        
        let TakeMicroPhone = Img_Microphone
        let tapTakeMicroPhone = UITapGestureRecognizer(target:self, action:#selector(IssueInfoViewController.Take_MicroPhone(_:)))
        TakeMicroPhone?.isUserInteractionEnabled = true
        TakeMicroPhone?.addGestureRecognizer(tapTakeMicroPhone)
        
         Vw_Progress.isHidden = true
        
//        btn_Send.addTarget(self, action: #selector(IssueInfoViewController.Send_WorkNote(_:), for: UIControlEvents.touchUpInside))
//
        btn_Send.addTarget(self, action:#selector(Send_WorkNote(_:)), for: .touchUpInside)
//        btn_Send.addTarget(self, action: "Send_WorkNote:", for#selector(IssueInfoViewController.Send_WorkNote(_:)): UIControlEvents.touchUpInside)
//
    }

    
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        ImagePicker(image: image)
        
    }
    func play(){
        //进度条开始转动
        Vw_Progress.isHidden = false
    }
    
    func stop(){
        //进度条停止转动
        Vw_Progress.isHidden = true
    }
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func ImagePicker(image: UIImage)
    {
        
        let selectedImage = image
        
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName + ".jpg")
        
        if let jpegData = UIImageJPEGRepresentation(selectedImage, 80) {
            
            try? jpegData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            
        }
        
        dismiss(animated: true, completion: nil)
        
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Send",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in self.SendImageToWorkNote(ImagePath: imagePath)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        let width : NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300);
        
        alert.view.addConstraint(width);
        
        let margin:CGFloat = 25.0
        let rect = CGRect(x: margin, y: margin, width: 250, height: 160)
        let imageView = UIImageView(frame: rect)
        
        imageView.image = image
        
        alert.view.addSubview(imageView)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func SendImageToWorkNote(ImagePath:String)
    {
        
        if AppUser.WorkID! != "" {
            
            self.play()
            
            Upload_Issue_File(AppUser.WorkID!, IssueID: IssueID!, IssueFilePath: ImagePath)
            
        }
        
    }
    
    
    
    
    func Upload_Issue_File(_ WorkID:String,IssueID:String,IssueFilePath:String)
    {
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File_MultiPart"
        
        let theFileName = (IssueFilePath as NSString).lastPathComponent
        
        let fileUrl = URL(fileURLWithPath: IssueFilePath)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(fileUrl, withName: "photo")
                
                
        },
            to: Path,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                    upload.uploadProgress { progress in
                        
                        debugPrint(Float(progress.fractionCompleted))
                        
                        self.Vw_Progress.setProgress(value: CGFloat(Float(progress.fractionCompleted) * 100), animationDuration: 0)
                        
                        if(Float(progress.fractionCompleted) >= 1)
                        {
                            self.stop()
                            
                            self.Get_Issue_Info(IssueID)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_Comment_File_Insert", parameters: ["F_Keyin": WorkID,"F_Master_ID":IssueID,"File":theFileName])
            .responseJSON { response in
                
                
        }
    }
    
    func Comment_Insert(_ WorkID:String,IssueID:String,Comment:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/C_Comment_Insert", parameters: ["F_Keyin": WorkID,"F_Master_Table":"C_Issue","F_Master_ID":IssueID,"F_Comment":Comment])
            .responseJSON { response in
                self.Get_Issue_Info(self.IssueID!)
                
                self.txt_Reply_Content.text = ""
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
    
    func Take_Photo(_ Photo:AnyObject)
    {
        
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.2
        
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func Send_WorkNote(_ Btn_Send:AnyObject)
    {
       let Content = txt_Reply_Content.text
        
        if(!(Content?.isEmpty)!)
        {
            Comment_Insert(AppUser.WorkID!, IssueID: IssueID!, Comment: Content!)
        }
        
    }
    
    
    func Take_Video(_ Video:AnyObject)
    {
        startCameraFromViewController(self, withDelegate: self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    }
    
    func Take_MicroPhone(_ MicroPhone:AnyObject)
    {
        if (MicrophonRecord)
        {
            Img_Microphone.image = UIImage(named: "btn_newissue_microphone")
            
            recoder_manager.stopRecord()//结束录音
            
            self.view.makeToast("StopRecord")
            
            VoicePicker(Path:recoder_manager.file_path)
        }
        else
        {
            Img_Microphone.image = UIImage(named: "btn_newissue_microphone_recording")
            
            recoder_manager.beginRecord()//开始录音
            
            self.view.makeToast("BeginRecord")
        }
        
        MicrophonRecord = !MicrophonRecord
    }
    func VoicePicker(Path: String)
    {
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Send",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in self.SendImageToWorkNote(ImagePath: Path)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        let width : NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300);
        
        alert.view.addConstraint(width);
        
        let margin:CGFloat = 25.0
        let rect = CGRect(x: margin, y: margin, width: 250, height: 160)
        let attactFileControl = AttactFileViewController(frame: rect)
        
        attactFileControl.VoicePath = Path
    

        alert.view.addSubview(attactFileControl)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        //dismiss(animated: true, completion: nil)
        // Handle a movie capture
        
        if mediaType == kUTTypeMovie {
            
            let TempVideoPath = info[UIImagePickerControllerMediaURL] as! NSURL!
            
            guard let path = (TempVideoPath)?.path else { return }
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(IssueInfoViewController.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                
                let alert = UIAlertController(title: "\n\n\n\n\n\n\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Send",
                                              style: UIAlertActionStyle.default,
                                              handler: {(alert: UIAlertAction!) in self.SendImageToWorkNote(ImagePath: path)}))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                
                let width : NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300);
                
                alert.view.addConstraint(width);
                
                let margin:CGFloat = 25.0
                let rect = CGRect(x: margin, y: margin, width: 250, height: 160)
                let attactFileControl = AttactFileViewController(frame: rect)
                
                attactFileControl.VideoPath = path
                
                alert.view.addSubview(attactFileControl)
                
                dismiss(animated: true, completion: nil)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func keyboardWillShow(_ notification:Foundation.Notification)
    {
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.VW_Bottom_Height.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillHide(_ notification:Foundation.Notification)
    {
        VW_Bottom_Height.constant = 0.0
        view.setNeedsLayout()
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Issue_File_List.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueInfoAttactCell", for: indexPath) as!  IssueInfoAttactFileCell
        
       let AttactFileItem = Issue_File_List[indexPath.row]
        
        switch AttactFileItem.FileType {
            
        case .Image?:
            
          
            
            cell.AttactFileController.ImagePath = AttactFileItem.FilePath
           
            break
        case .Voice?:
            
            cell.AttactFileController.VoicePath = AttactFileItem.FilePath
            break
        case .Video?:
            
            cell.AttactFileController.VideoPath = AttactFileItem.FilePath
            break
        default:
            break
        }

        return cell
    }
    
    
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Issue_Command_List.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueInfoCell", for: indexPath) as! IssueInfoTableViewCell
        
        let row = indexPath.row
        
        var CommentFileList = [Issue_File] ()
        
        let CommentIssue_File = Issue_File()
        
        cell.lbl_Reply_Date.text = AppClass.DateStringtoShortDate(Issue_Command_List[row].Command_Time!)
        
        cell.lbl_Reply_Content.text = Issue_Command_List[row].Command_Content
        
        if ((Issue_Command_List[row].Command_File?.uppercased().contains("JPG"))! || (Issue_Command_List[row].Command_File?.uppercased().contains("PNG"))! || (Issue_Command_List[row].Command_File?.uppercased().contains("GIF"))!)
        {
            CommentIssue_File.FilePath = Issue_Command_List[row].Command_File?.replacingOccurrences(of: "//172.16.111.114/File", with: "http://wtsc.msi.com.tw/IMS/FileServer")
            
            CommentIssue_File.FileType = AppClass.FileType.Image
          
            CommentFileList.append(CommentIssue_File)
            
             cell.Set_Source(FileList: CommentFileList)
        }
        
        if ((Issue_Command_List[row].Command_File?.uppercased().contains("WAV")))!
        {
            CommentIssue_File.FilePath = Issue_Command_List[row].Command_File?.replacingOccurrences(of: "//172.16.111.114/File", with: "http://wtsc.msi.com.tw/IMS/FileServer")
            
            CommentIssue_File.FileType = AppClass.FileType.Voice
            
            CommentFileList.append(CommentIssue_File)
            
             cell.Set_Source(FileList: CommentFileList)
        }
        
        if ((Issue_Command_List[row].Command_File?.uppercased().contains("MOV")))!
        {
            CommentIssue_File.FilePath = Issue_Command_List[row].Command_File?.replacingOccurrences(of: "//172.16.111.114/File", with: "http://wtsc.msi.com.tw/IMS/FileServer")
        
            CommentIssue_File.FileType = AppClass.FileType.Video
            
            CommentFileList.append(CommentIssue_File)
            
             cell.Set_Source(FileList: CommentFileList)
        }
       
        if (Issue_Command_List[row].Command_File?.isEmpty)!
        {
            cell.lbl_Content_Constraint.constant = cell.lbl_Content_Constraint.constant - cell.Col_CommeFile_Attact.frame.height

            cell.Col_CommeFile_Attact.isHidden = true

            cell.layoutIfNeeded()
        }
        else
        {
            cell.lbl_Content_Constraint.constant = 169

            cell.Col_CommeFile_Attact.isHidden = false

            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func Get_Issue_Info(_ Issue_ID:String)
    {
//        showActivityIndicatory(uiView: self.view)
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/GetIssue_Info", parameters: ["IssueID": Issue_ID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [String: AnyObject]
                    
                    if((ObjectString?.count)! > 0)
                    {
                        let IssueInfo = ObjectString?["IssueInfo"]! as? [[String: AnyObject]]
                        
                        self.Get_Issue_InfoData(Data: IssueInfo!)
                        
                        let IssueComment = ObjectString?["IssueComment"] as? [[String: AnyObject]]
                        
                        self.Get_Issue_Command_Data(Data: IssueComment!)
                        
                        let IssueFile = ObjectString?["IssueFile"] as? [[String: AnyObject]]
                        
                        self.Get_Issue_FileData(Data: IssueFile!)
                    }
                    
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
                
                if let viewWithTag = self.view.viewWithTag(1) {
                    
                    viewWithTag.removeFromSuperview()
                }
                
        }
        
    }
    
    func Get_Issue_FileData(Data:[[String: AnyObject]])
    {
        Issue_File_List = [Issue_File]()
        
        for IssueInfo in (Data ) {
            
            let _Issue_File = Issue_File()
            
            let Issue_File_Path = IssueInfo["F_DownloadFilePath"] as! String
            
            
            
            if ((Issue_File_Path.uppercased().contains("JPG")) || (Issue_File_Path.uppercased().contains("PNG")) || (Issue_File_Path.uppercased().contains("GIF")))
            {
                _Issue_File.FilePath = Issue_File_Path.replacingOccurrences(of: "//172.16.111.114/File", with: "http://wtsc.msi.com.tw/IMS/FileServer")
                
                _Issue_File.FileType = AppClass.FileType.Image
                
                self.Issue_File_List.append(_Issue_File)
                
                
            }
            
            if ((Issue_File_Path.uppercased().contains("WAV")))
            {
                _Issue_File.FilePath = Issue_File_Path.replacingOccurrences(of: "//172.16.111.114/File", with: "http://wtsc.msi.com.tw/IMS/FileServer")
                
                _Issue_File.FileType = AppClass.FileType.Voice
                
                self.Issue_File_List.append(_Issue_File)
            }
            
            if ((Issue_File_Path.uppercased().contains("MOV")))
            {
                _Issue_File.FilePath = Issue_File_Path.replacingOccurrences(of: "//172.16.111.114/File", with: "http://wtsc.msi.com.tw/IMS/FileServer")
                
                
//                Issue_File_Path    String    "//172.16.111.114/File/VSS/Code/IMS/53067682867__FBA8EE37-F4D4-4A61-B333-98C4B789AE7D.MOV"
                //_Issue_File.FilePath = "http:" + Issue_File_Path
                
                _Issue_File.FileType = AppClass.FileType.Video
                
                self.Issue_File_List.append(_Issue_File)
            }
            
        }
        
        if(self.Issue_File_List.count > 0 )
        {
            self.col_AttactFile.dataSource = self
            
            self.col_AttactFile.delegate = self
            
            self.col_AttactFile.collectionViewLayout.invalidateLayout()
            
            self.col_AttactFile.reloadData()
        }
        else
        {
            
//            self.VW_IssueInfo.frame = CGRect(x: self.VW_IssueInfo.frame.origin.x, y: self.VW_IssueInfo.frame.origin.y, width: self.VW_IssueInfo.frame.width, height: self.VW_IssueInfo.frame.height - self.Col_Edit_View.frame.height)
//
            self.col_AttactFile.frame = CGRect(x: self.col_AttactFile.frame.origin.x, y: self.col_AttactFile.frame.origin.y, width: 0, height: 0)
        }
        
    }
    
    func Get_Issue_Command_Data(Data:[[String: AnyObject]])
    {
        Issue_Command_List = [Issue_Command]()
        
        for IssueInfo in (Data ) {
            
            let _Issue_Command = Issue_Command()
            
            let Issue_Command_Author = IssueInfo["F_Owner"] as! String
            let Issue_Command_Date = IssueInfo["F_CreateDate"] as! String
            
            let Issue_Command_Content = IssueInfo["F_Comment"] as! String
            let Issue_Command_WorkID = IssueInfo["F_Keyin"] as! String
            let Issue_Command_File = IssueInfo["Comment_File"] as! String
            
            _Issue_Command.Command_Author_WorkID = Issue_Command_WorkID
            _Issue_Command.Command_Author = Issue_Command_Author
            _Issue_Command.Command_Content = Issue_Command_Content
            _Issue_Command.Command_Time = Issue_Command_Date
            _Issue_Command.Command_File = Issue_Command_File
            
            
            self.Issue_Command_List.append(_Issue_Command)
        }
        
        self.tb_Reply.reloadData()
    }
    
    func Get_Issue_InfoData(Data:[[String: AnyObject]])
    {
        let IssueInfo = Data
        
        if IssueInfo.count > 0
        {
            
          
            
            if (IssueInfo[0]["F_ModelName"] as? String) != nil {
                
                self.lbl_Title.text = (IssueInfo[0]["F_ModelName"] as? String)!
                
            }
            else
            {
                self.lbl_Title.text = ""
            }
            
            if (IssueInfo[0]["F_Subject"] as? String) != nil {
                
                self.lbl_Subject.text = IssueInfo[0]["F_Subject"] as? String
                
            }
            else
            {
                self.lbl_Subject.text = ""
            }
            
        
            
            if (IssueInfo[0]["F_CreateDate"] as? String) != nil {
                
                self.lbl_Date.text = AppClass.DateStringtoShortDate( (IssueInfo[0]["F_CreateDate"] as? String)!)
                
            }
            else
            {
                self.lbl_Date.text = ""
            }
            
        }
        
    }
    
  
}




