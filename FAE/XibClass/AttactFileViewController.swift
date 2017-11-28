//
//  AttactFileViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/10/13.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import AVKit

@IBDesignable class AttactFileViewController: UIView {
    
    @IBOutlet var VW_Content: UIView!
    
    var Img_Attact: UIImageView!
    
    var MyCustview:UIView!
    
    var CreateIndex:IndexPath?
    
    var player: AVPlayer?
    
    @IBInspectable var VideoPath: String? {
        didSet {
            for view in MyCustview.subviews {
                view.removeFromSuperview()
            }
      
            
            Img_Attact = UIImageView(image: getThumbnailFrom(path: URL(fileURLWithPath: VideoPath!)))
            
            //Img_Attact = UIImageView(image: UIImage(named: "btn_issue_audiovideo_play"))
            Img_Attact.frame = self.bounds
            Img_Attact.backgroundColor = UIColor(hexString: "#18171A")
            let tapVideoPlay = UITapGestureRecognizer(target:self, action:#selector(AttactFileViewController.Video_Play(_:)))
            Img_Attact?.isUserInteractionEnabled = true
            Img_Attact?.addGestureRecognizer(tapVideoPlay)
            Img_Attact.contentMode = UIViewContentMode.scaleAspectFit
            MyCustview.addSubview(Img_Attact)
            
            
            
           
        }
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
    
    @IBInspectable var VW_Background_Color: UIColor? {
        didSet {
            
            VW_Content.backgroundColor = VW_Background_Color
        }
    }
    
    @IBInspectable var ImagePath: String? {
        didSet {
            for view in MyCustview.subviews {
                view.removeFromSuperview()
            }
            Img_Attact = UIImageView(image: UIImage(named: "btn_issue_audiovideo_play"))
            Img_Attact.frame = self.bounds
            AppClass.WebImgGet(ImagePath!,ImageView: Img_Attact)
            Img_Attact.contentMode = UIViewContentMode.scaleAspectFit
            let Img_EditGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AttactFileViewController.GoToZoome(sender:)))
            Img_Attact?.isUserInteractionEnabled = true
            Img_Attact?.addGestureRecognizer(Img_EditGestureRecognizer)
            MyCustview.addSubview(Img_Attact)
        }
    }
    
    @IBInspectable var PictureImage: UIImageView? {
        didSet {
            for view in MyCustview.subviews {
                view.removeFromSuperview()
            }
            Img_Attact = PictureImage
            Img_Attact.frame = self.bounds
           
            Img_Attact.contentMode = UIViewContentMode.scaleAspectFit
            let Img_EditGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AttactFileViewController.GoToZoome(sender:)))
            Img_Attact?.isUserInteractionEnabled = true
            Img_Attact?.addGestureRecognizer(Img_EditGestureRecognizer)
            MyCustview.addSubview(Img_Attact)
        }
    }
    
    @IBInspectable var VoicePath: String? {
        didSet {
            for view in MyCustview.subviews {
                view.removeFromSuperview()
            }
            Img_Attact = UIImageView(image: UIImage(named: "btn_issue_audiovideo_play"))
            Img_Attact.frame = self.bounds
            Img_Attact.backgroundColor = UIColor(hexString: "#18171A")
            let tapVoicePlay = UITapGestureRecognizer(target:self, action:#selector(AttactFileViewController.Voice_Play(_:)))
            Img_Attact?.isUserInteractionEnabled = true
            Img_Attact?.addGestureRecognizer(tapVoicePlay)
            Img_Attact.contentMode = UIViewContentMode.scaleAspectFit
            MyCustview.addSubview(Img_Attact)
        }
    }
    
    func GoToZoome(sender:UITapGestureRecognizer)
    {
        let displacedView = sender.view as! UIImageView
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ZoomViewController
        popOverVC.ZoomImage = displacedView.image
        let nav = UINavigationController(rootViewController: popOverVC)
        getCurrentViewController()?.present(nav, animated: true, completion: nil)
    }
    
    
    override init(frame: CGRect){
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
      
        MyCustview = loadViewFromNib()
        
//        Img_Attact = UIImageView(image: UIImage(named: "btn_issue_audiovideo_play"))
//
//        MyCustview.addSubview(Img_Attact)
        // use bounds not frame or it'll be offset
        MyCustview.frame = bounds
        // Make the view stretch with containing view
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(MyCustview)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AttactFile", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func Voice_Play(_ Video:AnyObject)
    {
        do {
            
            let VideoNSUrl  = URL(fileURLWithPath: VoicePath!)
            
            let item = AVPlayerItem(url: VideoNSUrl)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AttactFileViewController.Play_Finish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            
            player = AVPlayer(playerItem: item)
            
            Img_Attact.backgroundColor = UIColor(hexString: "#18171A")
            
            player!.play()
            
            Img_Attact.image = UIImage(named: "btn_issue_audiovideo_pause")
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
        
    }
    
    func Video_Play(_ Video:AnyObject)
    {
        //        let videoURL = NSURL(string: VideoPath!)
        let player = AVPlayer(url: URL(fileURLWithPath: VideoPath!))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        getCurrentViewController()?.present(playerViewController, animated: true)
        {
            playerViewController.player!.play()
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
    func Play_Finish(){
        Img_Attact.backgroundColor = UIColor(hexString: "#18171A")
        
        Img_Attact.image = UIImage(named: "btn_issue_audiovideo_play")
    }
    
}
