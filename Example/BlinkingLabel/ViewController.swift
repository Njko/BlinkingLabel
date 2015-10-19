//
//  ViewController.swift
//  BlinkingLabel
//
//  Created by nicolas.linard on 09/21/2015.
//  Copyright (c) 2015 nicolas.linard. All rights reserved.
//

import UIKit
import BlinkingLabel

class ViewController: UIViewController {

    var isBlinking = false
    
    let blinkinLabel = BlinkingLabel(frame: CGRectMake(10, 20, 200, 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blinkinLabel.text = "I blink!"
        blinkinLabel.font = UIFont.systemFontOfSize(20)
        view.addSubview(blinkinLabel)
        blinkinLabel.startBlinking()
        isBlinking = true
        
        let toggleButton = UIButton(frame: CGRectMake(10, 60, 125, 30))
        toggleButton.setTitle("Toggle Blinking", forState: .Normal)
        toggleButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        toggleButton.addTarget(self, action: "toggleBlinking", forControlEvents: .TouchUpInside)
        view.addSubview(toggleButton)
    }
    
    func toggleBlinking() {
        if (isBlinking) {
            blinkinLabel.stopBlinking()
        } else {
            blinkinLabel.startBlinking()
        }
        isBlinking = !isBlinking
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

