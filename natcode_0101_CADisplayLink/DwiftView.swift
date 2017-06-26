//
//  DwiftView.swift
//  natcode_0101_CAVersion
//
//  Created by Carlyn Maw on 6/24/17.
//  Copyright © 2017 carlynorama. No rights reserved.
//
//

import UIKit



@IBDesignable
class DwiftView: UIView {
    
    //MARK: CADisplayLink
    private lazy var displayLink : CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(DwiftView.updateLoop))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        return displayLink
    }()
    
    
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
    private lazy var ballRadius:CGFloat = (min(self.bounds.size.width, self.bounds.size.height) / 10)
    private let ballColor = UIColor(colorLiteralRed: 0.270271, green: 0.451499, blue: 0.616321, alpha: 1)
    private var bounceVector:CGVector = CGVector(dx:1.0, dy:3.0)
    
    //MARK: SetUp
    func setUp() {
        self.backgroundColor = colorForBackground
        layer.borderWidth = sizeForBorder
        layer.borderColor = colorForBorder.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10.0
        
        ball.fillColor = ballColor.cgColor
        //ball.path = getBallPath().cgPath
        ball.path = getBallPath(location: CGPoint(x: 0, y: 0)).cgPath
        layer.addSublayer(ball)
        ball.position = CGPoint(x: ballRadius, y:ballRadius)
        
    }
    
    //MARK: Display Link Update and Control
    func updateLoop() {
        //print("Hi!")
        move(item: ball, vector: bounceVector)
        bounceVector = getUpdatedVectorInCaseOfBoundsCollision(bounceVector)
        
    }
    
    //TODO: make these two private and tap based like example?
    func startUpdateLoop() {
        displayLink.isPaused = false
    }
    
    func stopUpdateLoop() {
        displayLink.isPaused = true
    }
    
    
    //MARK: Paths
    
    //Okay
    
    private func getBallPath(location: CGPoint? = nil, in view: UIView? = nil) -> UIBezierPath {
        var startPoint:CGPoint? = location
        if startPoint == nil { startPoint = CGPoint(x: bounds.midX, y: bounds.midY) }
        if view != nil { startPoint = self.convert(startPoint!, to: view) }
        let radius = min(bounds.size.width, bounds.size.height) / 10
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat.pi*2
        let path = UIBezierPath(arcCenter: startPoint!, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        path.lineWidth = radius/10
        print("Got the ball path", startPoint!)
        return path
    }
    
    
    //MARK: Behaviors
    func move(item:CALayer, vector:CGVector) {
        let calculatedPosition = applyVector(startPosition: item.position, vector: vector)
        
        //turn off implicit layer animations by using transaction
        //necessary so can do the reset jump
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        item.position = calculatedPosition
        CATransaction.commit()
        
    }
    
    func getUpdatedVectorInCaseOfBoundsCollision(_ vector:CGVector) -> CGVector {
        
        //seed with current value
        var newVector = vector
        
        //bounds detection
        if ((ball.position.x >= (bounds.maxX - ballRadius)) || (ball.position.x <= (bounds.minX + ballRadius))) {
            newVector.dx = vector.dx * -1;
        }
        if ((ball.position.y >= (bounds.maxY - ballRadius)) || (ball.position.y <= (bounds.minY + ballRadius))) {
            newVector.dy = vector.dy * -1;
        }
        
        return newVector
    }
    
    func applyVector(startPosition:CGPoint, vector:CGVector) -> CGPoint {
        let deltaX:CGFloat = vector.dx
        let deltaY:CGFloat = vector.dy
        let newPoint:CGPoint = CGPoint(x: startPosition.x+deltaX, y: startPosition.y+deltaY)
        return newPoint
    }
    
    
    
    
    
}

