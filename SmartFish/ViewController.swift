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
        self.onOffButton.backgroundColor = UIColor.darkGray
        
        // get firebase data
        let ref = Database.database().reference()
        ref.child("led").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            let state = value?["state"] as? Int ?? 0
            let red = value?["red"] as? Int ?? 255
            let blue = value?["blue"] as? Int ?? 255
            let green = value?["green"] as? Int ?? 255
            let brightness = value?["brightness"] as? Int ?? 100
            
            //print("red: \(red) + blue: \(blue) + green: \(green) + brightness: \(brightness)")
            var stateString = "OFF"
            if state == 1
            {
                stateString = "ON"
            }
            else
            {
                stateString = "OFF"
            }
            
            // update buttons
            self.onOffButton.setTitle(stateString, for: .normal)
            if state == 1
            {
                self.isOn = true
                self.onOffButton.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.7333333333, blue: 0.4352941176, alpha: 1)
            }
            else
            {
                self.isOn = false
                self.onOffButton.backgroundColor = UIColor.darkGray
            }
            // update color button
            let color = UIColor(red: CGFloat(Float(red)/255), green: CGFloat(Float(green)/255), blue: CGFloat(Float(blue)/255), alpha: CGFloat(Float(brightness)/100))
            self.colorButton.backgroundColor = color
            
            if red + blue + green > 600 || brightness < 25
            {
                self.colorButton.setTitleColor(UIColor.black, for: .normal)
            }
            else
            {
                self.colorButton.setTitleColor(UIColor.white, for: .normal)
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // update Firebase
    func led(state:Int)
    {
        let ref = Database.database().reference()
        let post: [String: AnyObject] = ["state": state as AnyObject]
        ref.child("led").updateChildValues(post) // this updates values in post, but does not delete.
        //        ref.child("led").setValue(post) // this updates and deletes values not in post.
    }
    
    
    @IBAction func onButtonTapped(_ sender: UIButton)
    {
        if isOn
        {
            sender.setTitle("OFF", for: .normal)
            sender.backgroundColor = UIColor.darkGray
            led(state: 0)
        } else
        {
            sender.setTitle("ON", for: .normal)
            sender.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.7333333333, blue: 0.4352941176, alpha: 1)
            led(state: 1)
        }
        isOn = !isOn
        
    }
    
    // this is used to recieve the color from colorPickerView.
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ColorPickerViewController {
            let color = sourceViewController.color
            colorButton.backgroundColor = color
            
            let tuple = color?.rgb()
            let red = tuple?.red ?? 0
            let green = tuple?.green ?? 0
            let blue = tuple?.blue ?? 0
            let alpha = tuple?.alpha ?? 0
            if red + blue + green > 600 || alpha < 50
            {
                colorButton.setTitleColor(UIColor.black, for: .normal)
            }
            else
            {
                colorButton.setTitleColor(UIColor.white, for: .normal)
            }
            //            dataRecieved = sourceViewController.dataPassed
        }
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorPickerSegue"
        {
            let destVC = segue.destination as? ColorPickerViewController
            destVC?.color = colorButton.backgroundColor
            // also pass the state of led. ON or OFF
            
            
            
            
        }
    }
}

