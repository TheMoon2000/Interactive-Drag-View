//
//  ViewController.swift
//  Drag View
//
//  Created by Jia Rui Shan on 2019/5/4.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var interactiveView: InteractiveView!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var stepper: NSStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userUpdatedTextfield(_ sender: NSTextField) {
        // update the stepper
        stepper.doubleValue = textField.doubleValue
        textField.doubleValue = stepper.doubleValue
        
        // update the square from the interactive view
        interactiveView.updateSquareSize(size: stepper.doubleValue)
    }
    
    @IBAction func userUpdatedStepper(_ sender: NSStepper) {
        textField.doubleValue = sender.doubleValue
        // update the interactive view
        interactiveView.updateSquareSize(size: sender.doubleValue)
    }
    
    func respondToWindowResize() {
        stepper.maxValue = interactiveView.maxSquareSize()
    }


}

