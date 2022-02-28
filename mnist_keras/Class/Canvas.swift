//
//  Canvas.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/12.
//

import Foundation
import UIKit

class Canvas: UIView {
    
    var lines = [[CGPoint]]()
    func clear() {
        
        lines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.butt)
        
        lines.forEach { (line) in
            
            for (i, p) in line.enumerated() {
                
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }

        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: nil) else { return }
        let cgpoint = CGPoint(x: Int(point.x) - 40, y: Int(point.y - 50))
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(cgpoint)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
}
