//
//  WaveView.swift
//  UIBezierPathDemo
//
//  Created by Chiao-Te Ni on 2018/7/24.
//  Copyright © 2018年 aaron. All rights reserved.
//

import Foundation
import UIKit

class WaveView: UIView {
    
    var progress: CGFloat = 0.5 {
        didSet { baseY = frame.height * (1 - progress) }
    }
    
    private var frontLayer: CAShapeLayer = CAShapeLayer()
    private var backLayer: CAShapeLayer = CAShapeLayer()
    private var displayLink: CADisplayLink!
    
    private var spac: CGFloat = 0
    private var baseY: CGFloat = 0
    
    deinit {
        displayLink.isPaused = true
        displayLink.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        baseY = rect.height * (1 - progress)
    }
    
    private func setup() {
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
        
        backLayer.fillColor = UIColor(red: 113/255.0, green: 205/255.0, blue: 250/255.0, alpha: 0.4).cgColor
        layer.addSublayer(backLayer)
        
        frontLayer.fillColor = UIColor(red: 113/255.0, green: 205/255.0, blue: 250/255.0, alpha: 1).cgColor
        layer.addSublayer(frontLayer)
        
        displayLink = CADisplayLink(target: self, selector: #selector(updatePath))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        displayLink.preferredFramesPerSecond = 30
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(changeBaseY(gesture:)))
        addGestureRecognizer(gesture)
    }
    
    @objc private func changeBaseY(gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }
        baseY = gesture.location(in: self).y
    }
    
    @objc private func updatePath() {
        if spac >= CGFloat.pi * 100 {
            spac = 0
        } else {
            spac += 2 // 控制速度
        }
        
        let origin = CGPoint(x: 0, y: baseY)
        let frontPath = UIBezierPath()
        let backPath = UIBezierPath()
        
        frontPath.move(to: origin)
        backPath.move(to: origin)
        
        for x in 0 ..< Int(bounds.width) where x % 2 == 0 {
            let frontX = (CGFloat(x) - spac) * 0.015 // 控制波長
            let frontY = baseY - sin(frontX) * 6 // 控制振幅
            frontPath.addLine(to: CGPoint(x: CGFloat(x), y: frontY))
            
            let backX = (CGFloat(x) - (spac - 1)) * 0.023 // 控制波長
            let backY = baseY - sin(backX) * 3 // 控制振幅
            backPath.addLine(to: CGPoint(x: CGFloat(x), y: backY))
        }
        
        let downLeftPt = CGPoint(x: bounds.width, y: bounds.height)
        let downRightPt = CGPoint(x: 0, y: bounds.height)
        
        frontPath.addLine(to: downLeftPt)
        frontPath.addLine(to: downRightPt)
        
        backPath.addLine(to: downLeftPt)
        backPath.addLine(to: downRightPt)
        
        frontLayer.path = frontPath.cgPath
        backLayer.path = backPath.cgPath
    }
}
