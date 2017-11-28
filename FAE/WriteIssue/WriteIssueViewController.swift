//
//  WriteIssueViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/10/11.
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

protocol WriteIssueViewControllerDelegate
{
    func backevent()
}

class AttactFileCell:UICollectionViewCell
{
    @IBOutlet weak var Btn_Delete: UIButton!
    
    @IBOutlet weak var AttactFileControl: AttactFileViewController!
    
}



class AttactFileItem
{
    var FilePath:String?
    
    var _FileType:AppClass.FileType?
    
    var FileImage:Image?
    
    var FileIndex:Int?
}

class WriteIssueViewController: UIViewController,FusumaDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{

      var IssueNo:String?
    
    @IBOutlet weak var txt_Subject: UITextView!
    
    var recoder_manager = VoiceRecord()//初始化
    
    var AttactFileList = [AttactFileItem]()
    
    func AttactFileDelete(button: UIButton) {
        
        AttactFileList.remove(at: button.tag)
     
        self.Col_FileAttact.reloadData()
    }
    
    @IBOutlet weak var Vw_Progress: UICircularProgressRingView!
    
    @IBOutlet weak var Col_FileAttact: UICollectionView!
    
    var ModelName :String?
    
     var MarketName :String?
    
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
            
            Col_FileAttact.reloadData()
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
    
   
    @IBOutlet weak var Img_Camera: UIImageView!
    
    @IBOutlet weak var Img_Video: UIImageView!
    
    @IBOutlet weak var Img_Microphone: UIImageView!
    
    var ItemCount:Int = 20
    
    var delegate: WriteIssueViewControllerDelegate?
    
    var MicrophonRecord = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let TakePhoto = Img_Camera
        let tapTakePhoto = UITapGestureRecognizer(target:self, action:#selector(WriteIssueViewController.Take_Photo(_:)))
        TakePhoto?.isUserInteractionEnabled = true
        TakePhoto?.addGestureRecognizer(tapTakePhoto)
        
        let TakeVideo = Img_Video
        let tapTakeVideo = UITapGestureRecognizer(target:self, action:#selector(WriteIssueViewController.Take_Video(_:)))
        TakeVideo?.isUserInteractionEnabled = true
        TakeVideo?.addGestureRecognizer(tapTakeVideo)
        
        let TakeMicroPhone = Img_Microphone
        let tapTakeMicroPhone = UITapGestureRecognizer(target:self, action:#selector(WriteIssueViewController.Take_MicroPhone(_:)))
        TakeMicroPhone?.isUserInteractionEnabled = true
        TakeMicroPhone?.addGestureRecognizer(tapTakeMicroPhone)
        
        
        //self.title = "New Issue"
        self.title = MarketName
        self.Col_FileAttact.dataSource = self
        self.Col_FileAttact.delegate = self
        txt_Subject.delegate = self
        txt_Subject.text = " Please enter a issue Subject"
        txt_Subject.textColor = UIColor.lightGray
        
        Vw_Progress.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(FinishIssue))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: "fdfefe")
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenSize.width, height: screenSize.width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        Col_FileAttact!.collectionViewLayout = layout
        
        self.hideKeyboardWhenTappedAround()
        
        Issue_Init(AppUser.WorkID!)
    }

    func Issue_Init(_ WorkID:String)
    {
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_Init", parameters: ["F_Keyin": WorkID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let IssueInfo = ObjectString!
                        
                        
                        if IssueInfo.count > 0
                        {
                            self.IssueNo = IssueInfo[0]["F_SeqNo"] as? String
                            
                            //print(self.IssueNo!)
                            
                        }
                        
                        
                    }
                    else
                    {
                        
                        
                        //AppClass.Alert("Not Verify", SelfControl: self)
                    }
                    
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
        }
        
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func FinishIssue(){
        
     Finish_Issue()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = " Please enter a issue Subject"
            textView.textColor = UIColor.lightGray
        }
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
        let _AttactFileItem = AttactFileItem()
        
        _AttactFileItem.FilePath = Path
        
        _AttactFileItem._FileType = AppClass.FileType.Voice
        
        AttactFileList.append(_AttactFileItem)
        
        dismiss(animated: true, completion: nil)
        
        Col_FileAttact.reloadData()
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (AttactFileList.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttactFileCell", for: indexPath) as!  AttactFileCell
        
        let AttactFileItem = AttactFileList[indexPath.row]
        
        AttactFileItem.FileIndex = indexPath.row
        
        switch AttactFileItem._FileType {
            
        case .Image?:
            cell.AttactFileControl.PictureImage = UIImageView(image: UIImage(named: AttactFileItem.FilePath!))
            
           
            break
        case .Voice?:
//            cell.AttactFileControl.ImagePath = UIImage(named: "btn_issue_audiovideo_play")
            
            cell.AttactFileControl.VoicePath = AttactFileItem.FilePath
            break
        case .Video?:
//            cell.AttactFileControl.ImagePath = UIImage(named: "btn_issue_audiovideo_play")
            
            cell.AttactFileControl.VideoPath = AttactFileItem.FilePath
            break
        default:
            break
        }

        cell.Btn_Delete.tag = indexPath.row
        
        cell.Btn_Delete.addTarget(self, action: #selector(AttactFileDelete(button:)), for: .touchUpInside)
        
        return cell
    }
    
    func Take_Video(_ Video:AnyObject)
    {
        startCameraFromViewController(self, withDelegate: self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
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
                
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(WriteIssueViewController.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                
                let _AttactFileItem = AttactFileItem()
                
                _AttactFileItem.FilePath = path
                
                _AttactFileItem._FileType = AppClass.FileType.Video
                
                AttactFileList.append(_AttactFileItem)
                
                dismiss(animated: true, completion: nil)
                
                Col_FileAttact.reloadData()
                
            }
        }
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.backevent()
    }
    
    
    func Take_Photo(_ Photo:AnyObject)
    {
        
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.2
        
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func Finish_Issue()
    {
        
        //防止多次送出
        
        navigationItem.rightBarButtonItem = nil
        
        let Subject = txt_Subject.text
        
        let Priority = "1"
        
        New_Issue(IssueNo!, ModelName: ModelName!, MarketName: MarketName!, Priority: "1", Subject: Subject!)
    
        if(AttactFileList.count > 0)
        {
            Upload_Issue_File(AppUser.WorkID!, IssueID: IssueNo!)
        }
        else
        {
            _ = navigationController?.popViewController(animated: true)
            
            self.tabBarController?.selectedIndex = 1
        }
        
        
        
        
        
        
        
        //performSegue(withIdentifier: "NewIssueToEditIssue", sender: self)
    }
    
    func play(){
        //进度条开始转动
        Vw_Progress.isHidden = false
    }
    
    func stop(){
        //进度条停止转动
        Vw_Progress.isHidden = true
    }
    
    func Upload_Issue_File(_ WorkID:String,IssueID:String)
    {
        self.play()
        
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File_MultiPart"
        
        Alamofire.upload(
            
            multipartFormData: { multipartFormData in
                for filePath in self.AttactFileList
                {
                    let theFileName = (filePath.FilePath! as NSString).lastPathComponent
                    
                    let fileUrl = URL(fileURLWithPath: filePath.FilePath!)
                    
                    multipartFormData.append(fileUrl, withName: theFileName)
                    
                }
                
                
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
                            
                            _ = self.navigationController?.popViewController(animated: true)
                            
                            self.tabBarController?.selectedIndex = 1
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
        for filename in self.AttactFileList
        {
            let theFileName = (filename.FilePath as! NSString).lastPathComponent
            
            Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File", parameters: ["F_Keyin": WorkID,"F_Master_ID":IssueID,"F_Master_Table":"C_Issue","File":theFileName])
                .responseJSON { response in
                    
                    
            }
        }
        
        
        
        
    }
   
    func New_Issue(_ Issue_ID:String,ModelName:String,MarketName:String,Priority:String,Subject:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/FAE_App_Service.asmx/Issue_Update", method: .post, parameters: ["F_SeqNo": Issue_ID,"ModelName":ModelName,"MarketName":MarketName,"F_Priority":Priority,"F_Subject":Subject], encoding: JSONEncoding.default).responseJSON { response in
            
            
        }
        
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

