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
    
    private var strPoint: CGPoint!
    private var originPoint: CGPoint!
    private var displayLink: CADisplayLink!
    
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
        
        pointView.backgroundColor = UIColor.red //這邊可以設定顏色把控制點可視化/不可視化
        addSubview(pointView)
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateLayer))
        displayLink.add(to: .main, forMode: .defaultRunLoopMode)
        displayLink.isPaused = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            strPoint = gesture.translation(in: self)
            displayLink.isPaused = true
        case .changed:
            let currPt = gesture.translation(in: self)
            let ptOffset = currPt - strPoint
            pointView.center = originPoint + ptOffset
            updateLayer()
        case .ended, .cancelled, .failed:
            displayLink.isPaused = false
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.pointView.center = self.originPoint
            })
        default: break
        }
    }
    
    @objc private func updateLayer() {
        guard let ctrlPoint = pointView.layer.presentation()?.position else { return }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width,
                                 y: frame.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: frame.height),
                          controlPoint: ctrlPoint)
        path.close()
        shapeLayer.path = path.cgPath
    }

//    @objc private func updateLayer() {
//        guard let ctrlPoint = pointView.layer.presentation()?.position else { return }
//
//        let height = frame.size.height
//        let width = frame.size.width
//
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: width, y: 0))
//        path.addLine(to: CGPoint(x: width, y: height))
//        path.addLine(to: CGPoint(x: width - 20, y: height))
//
//        let pt1 = CGPoint(x: width - 50, y: height)
//        let pt2 = CGPoint(x: width - 100, y: ctrlPoint.y * 0.5)
//        path.addCurve(to: CGPoint(x: ctrlPoint.x + 100, y: ctrlPoint.y * 0.8), controlPoint1: pt1, controlPoint2: pt2)
//
//        path.addQuadCurve(to: CGPoint(x: ctrlPoint.x - 100, y: ctrlPoint.y * 0.8), controlPoint: ctrlPoint)
//
//        let pt3 = CGPoint(x: 100, y: ctrlPoint.y * 0.5)
//        let pt4 = CGPoint(x: 50, y: height)
//        path.addCurve(to: CGPoint(x: 20, y: height), controlPoint1: pt3, controlPoint2: pt4)
//
//        path.addLine(to: CGPoint(x: 0, y: height))
//        //        path.addQuadCurve(to: CGPoint(x: 0, y: height), controlPoint: ctrlPoint)
//        path.close()
//        shapeLayer.path = path.cgPath
//    }
}
