//
//  ViewController.swift
//  SmartFish
//
//  Created by Christopher Walter on 9/19/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    // MARK: Properties
    var isOn = false
    
    // MARK: Outlets
    @IBOutlet weak var onOffButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        led(state: "OFF")
        
        
    }
    
    func led(state:String)
    {
        let ref = Database.database().reference()
        let post: [String: AnyObject] = ["state": state as AnyObject]
        ref.child("led").setValue(post)
    }


    @IBAction func onButtonTapped(_ sender: UIButton)
    {
        if isOn
        {
            sender.setTitle("OFF", for: .normal)
            sender.backgroundColor = UIColor.red
            led(state: "OFF")
        } else
        {
            sender.setTitle("ON", for: .normal)
            sender.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.7333333333, blue: 0.4352941176, alpha: 1)
            led(state: "ON")
        }
        isOn = !isOn
        
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorPickerSegue"
        {
            let destVC = segue.destination as? ColorPickerViewController
            destVC?.color = colorButton.backgroundColor
            
        }
    }
}

