//
//  DwiftController.swift
//  natcode_0101_CAVersion
//
//  Created by Carlyn Maw on 6/24/17.
//  Copyright © 2017 carlynorama. All rights reserved.
//

//https://stackoverflow.com/questions/38112061/correct-handling-cleanup-etc-of-cadisplaylink-in-swift-custom-animation
//https://www.raywenderlich.com/100939/how-to-create-an-elastic-animation-with-swift
//https://stackoverflow.com/questions/34054861/uiimageview-rotation-animation-using-cadisplaylink-tracking-rotation
//http://stylekit.org/blog/2016/02/20/Core-animation/
//https://marcosantadev.com/calayer-auto-layout-swift/
//https://stackoverflow.com/questions/37767336/cashapelayer-driving-me-bonkers

import UIKit

class DwiftController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var dwiftView: DwiftView!
    
    var dwiftLayer:CALayer {
        get { return dwiftView.layer }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dwiftView.startUpdateLoop()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dwiftView.stopUpdateLoop()
    
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
