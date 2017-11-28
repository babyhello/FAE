//
//  MainTabBar.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/15.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.bool(forKey: "QRCodeScan")){
           self.selectedIndex = 1
        }
    }
}
