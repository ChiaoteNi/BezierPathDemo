//
//  HamburgerDemoVC.swift
//  UIBezierPathDemo
//
//  Created by Chiao-Te Ni on 2018/7/24.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class HamburgerDemoVC: BaseVC {

    @IBOutlet weak var hamburgerView: HamburgerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        hamburgerView.isOn = !hamburgerView.isOn
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
