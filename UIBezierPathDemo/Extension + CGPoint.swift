//
//  Extension + CGPoint.swift
//  UIBezierPathDemo
//
//  Created by Chiao-Te Ni on 2018/7/23.
//  Copyright © 2018年 aaron. All rights reserved.
//

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
