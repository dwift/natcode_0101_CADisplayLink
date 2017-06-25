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



@IBDesignable
class DwiftView: UIView {
    
    //MARK: CADisplayLink
    private lazy var displayLink : CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(DwiftView.updateLoop))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        return displayLink
    }()
    
//    private var displayLink : CADisplayLink?
//    private var startTime = 0.0
//    private let animLength = 5.0

    
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
    private let compassImage = CAShapeLayer()
    private var orbitVector:CGVector = CGVector(dx:2.0, dy:6.0)
    
    //MARK: SetUp
    func setUp() {
        self.backgroundColor = colorForBackground
        layer.borderWidth = sizeForBorder
        layer.borderColor = colorForBorder.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10.0
        
        ball.fillColor = UIColor.blue.cgColor
        ball.path = getBallPath().cgPath
        //ball.path = getBallPath(location: CGPoint(x: 0, y:0)).cgPath
        print("from superview ", self.convert(ball.position, from:superview))
        print("no conversion ", ball.position)
        layer.addSublayer(ball)
        drawCompassImage()
        
    }
    
    //MARK: Display Link Update and Control
    func updateLoop() {
        //print("Hi!")
        move(item: ball, vector: orbitVector)
        orbitVector = updateVector(orbitVector)
        move(item: compassImage, vector: orbitVector)
        

    }
    
    //TODO: make these two private and tap based like example?
    func startUpdateLoop() {
        displayLink.isPaused = false
    }
    
    func stopUpdateLoop() {
        displayLink.isPaused = true
    }
    
//    func startDisplayLink() {
//        
//        // make sure to stop a previous running display link
//        stopDisplayLink()
//        
//        // reset start time
//        startTime = CACurrentMediaTime()
//        
//        // create displayLink & add it to the run-loop
//        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire))
//        displayLink?.add(to: .main, forMode: .commonModes)
//        
//        // for Swift 2: displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:NSDefaultRunLoopMode)
//    }
//    
//    @objc func displayLinkDidFire() {
//        
//        var elapsed = CACurrentMediaTime() - startTime
//        
//        if elapsed > animLength {
//            stopDisplayLink()
//            elapsed = animLength // clamp the elapsed time to the anim length
//        }
//        
//        // do your animation logic here
//    }
//    
//    // invalidate display link if it's non-nil, then set to nil
//    func stopDisplayLink() {
//        displayLink?.invalidate()
//        displayLink = nil
//    }
    
    
    //MARK: Paths
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
    
    func drawCompassImage(){
        //https://stackoverflow.com/questions/37767336/cashapelayer-driving-me-bonkers
        //Compass Bezel Ring
        let baseCirclePath = UIBezierPath()
        let baseCircleRadius = 70
        
        baseCirclePath.addArc(withCenter: CGPoint(x: CGFloat(self.frame.width/2), y: CGFloat(self.frame.width/2)), radius: CGFloat(baseCircleRadius), startAngle: CGFloat(-1*Double.pi/2), endAngle:CGFloat((Double.pi/2)*3), clockwise: true)
        compassImage.path = baseCirclePath.cgPath
        compassImage.frame = bounds
        compassImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        compassImage.fillColor = UIColor.clear.cgColor;
        compassImage.strokeColor = UIColor.white.cgColor
        compassImage.lineDashPattern = [1.0,2.0]
        compassImage.lineWidth = 10.0
        self.layer.addSublayer(compassImage)
        
    }
    
    //MARK: Behaviors
    func move(item:CALayer, vector:CGVector) {
        let calculatedPosition = applyVector(startPosition: item.position, vector: vector)

//        if calculatedPosition.x > self.bounds.width || calculatedPosition.y > self.bounds.height {
//            calculatedPosition = CGPoint(x:0, y:0)
//
//        }
        //turn off implicit layer animations by using transaction
        //necessary so can do the reset jump
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        item.position = calculatedPosition
        CATransaction.commit()

    }
    
    func updateVector(_ vector:CGVector) -> CGVector {
        var newVector = vector
        
        //TODO: what is the size of the ball layer?
        
        //convert(center, from: superview)
        let adjustedBallPosition:CGPoint = ball.position
        
        //let adjustedBallPosition:CGPoint = convert(ball.position, from:self)
    
        let ballRadius = (min(bounds.size.width, bounds.size.height) / 10) - 10
        
        
        //Plus and minus are flipped because when they're thr right way it can't move.
        if ((adjustedBallPosition.x > (bounds.maxX + ballRadius)) || (adjustedBallPosition.x < (bounds.minX - ballRadius))) {
            newVector.dx = vector.dx * -1;
        }
        if ((adjustedBallPosition.y > (bounds.maxY + ballRadius)) || (adjustedBallPosition.y < (bounds.minY - ballRadius))) {
            newVector.dy = vector.dy * -1;
        }
        
        
//        if ((adjustedBallPosition.x > (bounds.maxX - ballRadius)) || (adjustedBallPosition.x < (bounds.minX + ballRadius))) {
//            newVector.dx = vector.dx * -1;
//        }
//        if ((adjustedBallPosition.y > (bounds.maxY - ballRadius)) || (adjustedBallPosition.y < (bounds.minY + ballRadius))) {
//            newVector.dy = vector.dy * -1;
//        }
        

        return newVector
    }

    func applyVector(startPosition:CGPoint, vector:CGVector) -> CGPoint {
        let deltaX:CGFloat = vector.dx
        let deltaY:CGFloat = vector.dy
        let newPoint:CGPoint = CGPoint(x: startPosition.x+deltaX, y: startPosition.y+deltaY)
        return newPoint
    }
    
    
    
    
    
}

