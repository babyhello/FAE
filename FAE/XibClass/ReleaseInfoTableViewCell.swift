//
//  ReleaseInfoTableViewCell.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/8.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit

class ReleaseInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var Img_Expend_Flag: UIImageView!
    
    @IBOutlet weak var VW_SectionContent: UIView!
    
    func Expend_Set(Expend:Bool)
    {
        if Expend {
            Img_Expend_Flag.image = UIImage(named: "btn_news_unfolded")
        }
        else
        {
             Img_Expend_Flag.image =  UIImage(named: "btn_news_collapse")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let path = UIBezierPath(roundedRect:VW_SectionContent.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 10, height:  10))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//
//        VW_SectionContent.layer.mask = maskLayer

    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
