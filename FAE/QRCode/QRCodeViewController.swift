//
//  QRCodeViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/10/6.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit
import AVFoundation

import Alamofire
import AlamofireImage

class QRCodeViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate,WriteIssueViewControllerDelegate
{
    
    @IBOutlet weak var lblQRCodeResult: UILabel!
    @IBOutlet weak var lblQRCodeLabel: UILabel!
    @IBOutlet weak var VW_QRCode: UIView!
    
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    var GoWriteIssue:Bool? = false
    var model:String = ""
    var marketName:String = ""
    
    var produceDate:String = ""
    var price:String = ""
    var lob:String = ""
    var ext_sn:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Scan barcode"
        
        VW_QRCode.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: VW_QRCode.frame.height)
        
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_head_flashsymbol"), style: .plain, target: self, action: #selector(openFlash))
        
        
        
        
    }
    
    func backevent()
    {
        objCaptureSession?.startRunning()
        
        
    }
    
    func Find_Model_Info(_ SN:String)
    {
        
        //        "model": "601-7817-060",
        //        "itemID": "151851",
        //        "marketName": "H81M-P33",
        //        "description": "MS-7817 12 OPT:H H81M-P33 H81,2DDR3,1PCI-Ex16,1PCI-Ex1,2SATA3,2USB3,HD Audio,Gb LAN,DVI,D-sub,C2",
        //        "produceDate": "2018/12/28",
        //        "price": "1700",
        //        "lob": "MB",
        //        "ext_sn": "601-7817-060B1511090594",
        //        "in_sn": "FB16830309"
      
        
        
        Alamofire.request(AppClass.ServerPath + "/FAE_App_Service.asmx/Find_Model_Info", parameters: ["SN": SN])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for ModelInfo in (ObjectString )! {
                            
                            
                            
                            if (ModelInfo["model"] as? String) != nil {
                                
                                self.model = (ModelInfo["model"] as? String)!
                                
                            }
                            
                            if (ModelInfo["marketName"] as? String) != nil {
                                
                                self.marketName = (ModelInfo["marketName"] as? String)!
                                
                            }
                            
                            //                            if (ModelInfo["description"] as? String) != nil {
                            //
                            //                                self.description = (ModelInfo["description"] as? String)!
                            //
                            //                            }
                            
                            if (ModelInfo["produceDate"] as? String) != nil {
                                
                                self.produceDate = (ModelInfo["produceDate"] as? String)!
                                
                            }
                            
                            if (ModelInfo["price"] as? String) != nil {
                                
                                self.price = (ModelInfo["price"] as? String)!
                                
                            }
                            
                            if (ModelInfo["lob"] as? String) != nil {
                                
                                self.lob = (ModelInfo["lob"] as? String)!
                                
                            }
                            
                            if (ModelInfo["ext_sn"] as? String) != nil {
                                
                                self.ext_sn = (ModelInfo["ext_sn"] as? String)!
                                
                            }
                            
                        }
                        
                        self.performSegue(withIdentifier: "write_issue", sender: self)
                        
                        
                    }
                    
                    
                    
                }
                
        }
    }
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode ,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "write_issue" {
            
            let ViewController = segue.destination as! WriteIssueViewController
            
            ViewController.ModelName = model
            
            ViewController.MarketName = marketName
            
            ViewController.delegate = self
            
            if(!UserDefaults.standard.bool(forKey: "QRCodeScan")){
                UserDefaults.standard.set(true, forKey: "QRCodeScan")
            }
            
        }
        
    }
    
    func addVideoPreviewLayer() {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = VW_QRCode.layer.bounds
        VW_QRCode.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
       
    }
    
//    func addVideoPreviewLayer() {
//        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
//        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
//        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
//        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
//        objCaptureSession?.startRunning()
//    }
//
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.red.cgColor
        vwQRCode?.layer.borderWidth = 5
        VW_QRCode.addSubview(vwQRCode!)
        VW_QRCode.bringSubview(toFront: vwQRCode!)

        VW_QRCode.layer.addSublayer(createFrame())
    }
    
//    func initializeQRView() {
//        vwQRCode = UIView()
//        vwQRCode?.layer.borderColor = UIColor.red.cgColor
//        vwQRCode?.layer.borderWidth = 5
//        self.view.addSubview(vwQRCode!)
//        self.view.bringSubview(toFront: vwQRCode!)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        vwQRCode?.frame = CGRect.zero
    }
    
 func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            //            lblQRCodeResult.text = "NO QRCode text detacted"
            
            
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    
    
//        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode || {
//
//        }
    
        let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
        vwQRCode?.frame = objBarCode.bounds;
        if objMetadataMachineReadableCodeObject.stringValue != nil {
            //                lblQRCodeResult.text = objMetadataMachineReadableCodeObject.stringValue
            
            objCaptureSession?.stopRunning()
            
            Find_Model_Info(objMetadataMachineReadableCodeObject.stringValue)
            
            
            
            
            
        }
    }
    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//        if metadataObjects == nil || metadataObjects.count == 0 {
//            vwQRCode?.frame = CGRect.zero
//            return
//        }
//        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
//            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
//
//            vwQRCode?.frame = objBarCode.bounds;
//
//            if objMetadataMachineReadableCodeObject.stringValue != nil {
//                let fullString = objMetadataMachineReadableCodeObject.stringValue.components(separatedBy: ",")
//
//
//            }
//        }
//        navigationController?.popViewController(animated: true)
//    }
    
    func createFrame() -> CAShapeLayer {
        let height: CGFloat = self.VW_QRCode.frame.size.height
        let width: CGFloat = self.VW_QRCode.frame.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 100))
        path.addLine(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 100, y: 50))
        path.move(to: CGPoint(x: width - 100, y: 50))
        path.addLine(to: CGPoint(x: width - 50, y: 50))
        path.addLine(to: CGPoint(x: width - 50, y: 100))
        path.move(to: CGPoint(x: 50, y: height - 100))
        path.addLine(to: CGPoint(x: 50, y: height - 50))
        path.addLine(to: CGPoint(x: 100, y: height - 50))
        path.move(to: CGPoint(x: width - 100, y: height - 50))
        path.addLine(to: CGPoint(x: width - 50, y: height - 50))
        path.addLine(to: CGPoint(x: width - 50, y: height - 100))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 5
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }
    
    func defaultCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera,
                                                      mediaType: AVMediaTypeVideo,
                                                      position: .back) {
            return device
        } else if let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
                                                             mediaType: AVMediaTypeVideo,
                                                             position: .back) {
            return device
        } else {
            return nil
        }
    }
    
    
    @objc func openFlash(){
        
        let captureDevice = defaultCamera()
        
        if !(captureDevice?.hasTorch)! {
            
            UIAlertView(title: "提示", message:"闪光灯故障", delegate:nil, cancelButtonTitle: "确定").show()
            
        }else{
            
            if  captureDevice?.torchMode != AVCaptureDevice.TorchMode.on || captureDevice?.flashMode != AVCaptureDevice.FlashMode.on {
                
                //打开闪光灯
                
                do{
                    
                    try captureDevice?.lockForConfiguration()
                    
                    captureDevice?.torchMode = AVCaptureDevice.TorchMode.on
                    
                    captureDevice?.flashMode = AVCaptureDevice.FlashMode.on
                    
                    captureDevice?.unlockForConfiguration()
                    
                }catch
                    
                {
                    
                    print(error)
                    
                }
                
            }else{
                
                //关闭闪光灯
                
                do{
                    
                    try captureDevice?.lockForConfiguration()
                    
                    captureDevice?.torchMode = AVCaptureDevice.TorchMode.off
                    
                    captureDevice?.flashMode = AVCaptureDevice.FlashMode.off
                    
                    captureDevice?.unlockForConfiguration()
                    
                }catch
                    
                {
                    
                    print(error)
                    
                }
                
            }
            
        }
        
    }
}

