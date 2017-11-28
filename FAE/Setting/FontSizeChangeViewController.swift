//
//  FontSizeChangeViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/13.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit

class FontSizeChangeViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    
  
    @IBAction func sliderAction(_ sender: Any) {
        print("Slider value \(slider.value)")
        
        self.label.font = UIFont.systemFont(ofSize: CGFloat(slider.value * 40.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "FontSizeChange"
        // Do any additional setup after loading the view.
        
//        let backgroundImage = UIImage(named: "bg_dragon")
//        let imageView = UIImageView(image: backgroundImage)
//        self.view.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
