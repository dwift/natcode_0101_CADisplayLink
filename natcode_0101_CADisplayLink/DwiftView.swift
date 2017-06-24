//
//  DwiftView.swift
//  natcode_0101_CAVersion
//
//  Created by Carlyn Maw on 6/24/17.
//  Copyright © 2017 carlynorama. All rights reserved.
//

//
//  DwiftView.swift
//  natcode_0101_ghostkiller
//
//  Created by Carlyn Maw on 6/23/17.
//  Copyright © 2017 carlynorama. No rights reserved
//

import UIKit

//https://marcosantadev.com/calayer-auto-layout-swift/

@IBDesignable
class DwiftView: UIView {
    
    
    //MARK: Inspectables
    
    @IBInspectable
    internal var colorForBackground: UIColor = UIColor(colorLiteralRed: 0.90, green: 0.90, blue: 0.90, alpha: 1) {
        didSet {
            self.backgroundColor = self.colorForBackground
        }
    }
    
    @IBInspectable
    internal var colorForBorder: UIColor = UIColor(colorLiteralRed: 0.80, green: 0.80, blue: 0.80, alpha: 1) {
        didSet {
            self.layer.borderColor = self.colorForBorder.cgColor
        }}
    
    @IBInspectable
    internal var sizeForBorder: CGFloat = 5 {
        didSet {
            self.layer.borderWidth = self.sizeForBorder
        }
    }
    
    //MARK: Initializers
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func setNeedsLayout() {
        setUp()
    }
    
    //MARK: Private Vars
    
    private let ball = CAShapeLayer()
    
    //MARK: SetUp
    func setUp() {
        self.backgroundColor = colorForBackground
        layer.borderWidth = sizeForBorder
        layer.borderColor = colorForBorder.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10.0
        
        ball.fillColor = UIColor.blue.cgColor
        ball.path = getBallPath().cgPath
        layer.addSublayer(ball)

        
    }
    
//    override func draw(_ rect: CGRect) {
//        //updateBall(moveTo: convert(center, from: superview))
//    }
    
    
    private func getBallPath(location: CGPoint? = nil, in view: UIView? = nil) -> UIBezierPath {
        var middle:CGPoint? = location
        if middle == nil { middle = CGPoint(x: bounds.midX, y: bounds.midY) }
        if view != nil { middle = self.convert(middle!, to: view) }
        let radius = min(bounds.size.width, bounds.size.height) / 10
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat.pi*2
        let path = UIBezierPath(arcCenter: middle!, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        path.lineWidth = radius/10
        return path
    }
    
    
    
}

