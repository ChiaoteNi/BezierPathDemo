//
//  ElasticityView.swift
//  UIBezierPathDemo
//
//  Created by Chiao-Te Ni on 2018/7/23.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class ElasticityView: UIView {
    
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    private var pointView: UIView = UIView()
    private var displayLink: CADisplayLink!
    
    private var originPoint: CGPoint!
    
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
        let width: CGFloat = 2
        originPoint = CGPoint(x: (rect.width) / 2, y: rect.height)
        pointView.center = originPoint
        pointView.frame.size = CGSize(width: width, height: width)
        pointView.backgroundColor = .clear
        
        shapeLayer.frame = rect
        shapeLayer.path = UIBezierPath(rect: rect).cgPath
        shapeLayer.fillColor = UIColor.orange.cgColor
    }
    
    private func setup() {
        backgroundColor = .clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
        
        pointView.backgroundColor = UIColor.orange
        addSubview(pointView)
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateLayer))
        displayLink.add(to: .main, forMode: .defaultRunLoopMode)
        displayLink.isPaused = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            displayLink.isPaused = true
            pointView.center = gesture.location(in: self)
            updateLayer()
        case .began, .ended, .cancelled, .failed:
            displayLink.isPaused = false
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.pointView.center = self.originPoint
            })
        default: break
        }
    }
    
    @objc private func updateLayer() {
        guard let ctrlPoint = pointView.layer.presentation()?.position else { return }
        
        let origin = CGPoint(x: 0, y: frame.height)
        let path = UIBezierPath()
        
        path.move(to: origin)
        path.addQuadCurve(to: CGPoint(x: frame.width, y: origin.y),
                          controlPoint: ctrlPoint)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        shapeLayer.path = path.cgPath
    }
}
