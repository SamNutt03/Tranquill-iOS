//
//  CustomTabBar.swift
//  Dissertation
//
//  Created by Sam Nuttall on 27/12/2023.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?
    
    var centeredWidth:CGFloat = 0
    
    @objc private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
        shapeLayer.fillColor = CGColor(colorSpace: sRGB, components: [0.827, 0.886, 1.0, 1.0])
        self.tintColor = .systemCyan
        shapeLayer.lineWidth = 3
        shapeLayer.shadowRadius = 7.5
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowColor = UIColor.systemBlue.cgColor
        shapeLayer.shadowOpacity = 3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
        
    }
    
    override func draw(_ rect: CGRect) {
        centeredWidth = self.bounds.width / 2
        self.addShape()
        self.clipsToBounds = false
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(addShape), userInfo: nil, repeats: true)
    }
    
    private func createPath() -> CGPath {
        let yStart:CGFloat = 10
        let height:CGFloat = 10
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: yStart))
        path.addLine(to: CGPoint(x: centeredWidth - height * 10, y: yStart))
        
        path.addCurve(to: CGPoint(x: centeredWidth, y: -height), controlPoint1: CGPoint(x: centeredWidth - 30, y: yStart), controlPoint2: CGPoint(x: centeredWidth - 35, y: -height))
        
        path.addCurve(to: CGPoint(x: centeredWidth + height * 10, y: yStart), controlPoint1: CGPoint(x: centeredWidth + 35, y: -height), controlPoint2: CGPoint(x: centeredWidth + 30, y: yStart))
        
        path.addLine(to: CGPoint(x: self.bounds.width, y: yStart))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: yStart))
        
        path.close()
        
        
        return path.cgPath
    }
    
}
