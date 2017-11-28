//
//  NewsViewController.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/7.
//  Copyright © 2017年 俞兆. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var SegmentControl: UISegmentedControl!
    
    @IBOutlet weak var VW_Content: UIView!
    
    @IBAction func SegmentChange(_ sender: UISegmentedControl) {
        
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
        
    }
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ReleaseInfoVW")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductVW")
        
        return secondChildTabVC
    }()
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case 0 :
            vc = firstChildTabVC
        case 1 :
            vc = secondChildTabVC
        default:
            return nil
        }
        
        return vc
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.VW_Content.bounds
            self.VW_Content.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(hexString: "#FFFFFF")]
        SegmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        
        displayCurrentTab(0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
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
