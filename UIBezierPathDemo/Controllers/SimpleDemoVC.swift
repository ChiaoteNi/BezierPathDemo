//
//  SimpleDemoVC.swift
//  UIBezierPathDemo
//
//  Created by Chiao-Te Ni on 2018/7/21.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class SimpleDemoVC: BaseVC {

    @IBOutlet var switchBtns: [UISwitch]!
    @IBOutlet var ptSliders: [UISlider]!
    @IBOutlet var locationViews: [UIView]!
    
    var path: UIBezierPath = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    
    var points = Array.init(repeating: CGPoint(x: 50, y: 50), count: 8)
    
    var startAngle: CGFloat = 0
    var endAngle = CGFloat.pi * 2
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始設定各點位置
        points[1] = CGPoint.init(x: 300, y: 50)     // addLine
        
        points[2] = CGPoint.init(x: 300, y: 300)    // addQuadCurve
        points[3] = CGPoint.init(x: 300, y: 200)
        
        points[4] = CGPoint.init(x: 50, y: 300)     // addCurve
        points[5] = CGPoint.init(x: 200, y: 300)     //
        points[6] = CGPoint.init(x: 100, y: 300)     // addCurve
        
        points[7] = CGPoint.init(x: 230, y: 230)
        
        // shapeLayer基本設定
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(shapeLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reDraw()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func reDraw() {
        drawPath()
        resetLocateView()
    }
    
    private func drawPath() {
        // 移除全部point，如果要重劃既有Path，並需調用此func進行重置
        path.removeAllPoints()
        // 移動到某點，但無畫線。UIBezierPath開始畫時必須先用此定義起點，在move to之前的設定均不會被繪製
        path.move(to: points[0])
        // 加入一條直線
        path.addLine(to: points[1])
        // 加入一條弧線
        path.addQuadCurve(to: points[2], controlPoint: points[3])
        // 加入一條兩點控制的曲線
        path.addCurve(to: points[4], controlPoint1: points[5], controlPoint2: points[6])
        // 加入一個圓
        path.addArc(withCenter: points[7], radius: 50, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 這邊在一到下一點，points[7]～CGPoint(x: 50, y: 350)之間並不繪製線條
        path.move(to: CGPoint(x: 50, y: 350))
        path.addLine(to: CGPoint(x: 300, y: 350))
        
        path.lineWidth = 10
        shapeLayer.path = path.cgPath
    }
    
    private func resetLocateView() {
        for i in 0 ..< locationViews.count {
            locationViews[i].center = points[i]
        }
    }
    
    @IBAction func ptValueChanged(_ sender: UISlider) {
        for switchBtn in switchBtns {
            guard switchBtn.isOn else { continue }
            let i = switchBtn.tag
            points[i].x = CGFloat(ptSliders[0].value)
            points[i].y = CGFloat(ptSliders[1].value)
        }
        reDraw()
    }
    
    @IBAction func angleValueChanged(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            startAngle = CGFloat(sender.value)
        case 1:
            endAngle = CGFloat(sender.value)
        default: break
        }
        drawPath()
    }
    
    @IBAction func switchBtnValueChanged(_ sender: UISwitch) {
        for btn in switchBtns {
            btn.isOn = btn == sender
        }
        
        let i = sender.tag
        for slider in ptSliders {
            let value = slider.tag == 0 ? points[i].x : points[i].y
            slider.value = Float(value)
        }
    }
}

extension CGPoint {
    init(_ xPt: CGFloat,_ yPt: CGFloat) {
        self.init(xPt, yPt)
    }
}
