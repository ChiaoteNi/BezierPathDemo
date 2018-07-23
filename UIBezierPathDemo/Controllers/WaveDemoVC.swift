//
//  WaveDemoVC.swift
//  UIBezierPathDemo
//
//  Created by Chiao-Te Ni on 2018/7/24.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class WaveDemoVC: UIViewController {

    @IBOutlet weak var waveView: WaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWaterBtnDidPressed(_ sender: UIButton) {
        let shouldIncrease = waveView.progress < 0.9
        
        print(waveView.progress)
        
        let ratio: CGFloat = 10000
        
        let runTimes = abs(Int(waveView.progress * ratio) - (shouldIncrease ? Int(ratio) : 0))
        for _ in 0 ..< runTimes {
            DispatchQueue.global().async {
                usleep(30000)
                DispatchQueue.main.async {
                    self.waveView.progress += shouldIncrease ? 1/ratio : -1/ratio
                }
            }
        }
    }
}
