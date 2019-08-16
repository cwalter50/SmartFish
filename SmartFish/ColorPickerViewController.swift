//
//  ColorPickerViewController.swift
//  SmartFish
//
//  Created by Christopher Walter on 1/13/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit
import Firebase

class ColorPickerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBOutlet weak var redTF: UITextField!
    @IBOutlet weak var greenTF: UITextField!
    @IBOutlet weak var blueTF: UITextField!
    @IBOutlet weak var brightnessTF: UITextField!
    @IBOutlet weak var hexTF: UITextField!
    
    // MARK: Properties
    var color: UIColor? {
        didSet {
            if let myColor = color, let theView = colorView
            {
                theView.backgroundColor = myColor
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.backgroundColor = color
        let myTuple = color?.rgb() // this is an extension which gives red, green, blue, alpha, as ints and in that order
        
        redTF.text = "\(myTuple?.red ?? 0)"
        greenTF.text = "\(myTuple?.green ?? 0)"
        blueTF.text = "\(myTuple?.blue ?? 0)"
        
        var alpha = myTuple?.alpha ?? 0
        alpha = Int(Double(alpha) / 255.0 * 100)
        brightnessTF.text = "\(alpha)"
        //
        redSlider.value = Float(myTuple?.red ?? 0)
        greenSlider.value = Float(myTuple?.green ?? 0)
        blueSlider.value = Float(myTuple?.blue ?? 0)
        brightnessSlider.value = Float(alpha)
        
        updateColorView()
        
        redTF.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
        greenTF.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
        blueTF.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
        brightnessTF.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        switch textField {
        case redTF:
            updateSlider(slider: redSlider, textField: redTF)
        case greenTF:
            updateSlider(slider: greenSlider, textField: greenTF)
        case blueTF:
            updateSlider(slider: blueSlider, textField: blueTF)
        case brightnessTF:
            updateSlider(slider: brightnessSlider, textField: brightnessTF)
        default:
            print("Error matching sliders")
        }
        
        updateColorView()
        
    }
    
    func updateSlider(slider: UISlider, textField: UITextField)
    {
        if let stringValue = textField.text{
            if let intValue = Int(stringValue){
                slider.setValue(Float(intValue), animated: true)
                
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        switch sender {
        case redSlider:
            redTF.text = "\(Int(sender.value))"
        case greenSlider:
            greenTF.text = "\(Int(sender.value))"
        case blueSlider:
            blueTF.text = "\(Int(sender.value))"
        case brightnessSlider:
            brightnessTF.text = "\(Int(sender.value))"
        default:
            print("slider values are different")
        }
        
        updateColorView()
    }
    
    func updateColorView()
    {
        guard let red = Float(redTF.text!), let green = Float(greenTF.text!), let blue = Float(blueTF.text!), let alpha = Float(brightnessTF.text!) else {
            print("error with colors")
            return
        }
        
        color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(alpha/100)) // this will also update the backgroundview with the didSet method
        
        // update firebase
        let ref = Database.database().reference()
        let post: [String: Any] = ["red": Int(red), "green": Int(green), "blue": Int(blue), "brightness": Int(alpha) ]
        ref.child("led").updateChildValues(post) // this just overwrites the values in the post
        //        ref.child("led").setValue(post) // this overwrites everything and deletes
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.isEqual(redTF) || textField.isEqual(greenTF) || textField.isEqual(blueTF))
        {
            // check to make sure that value is below 255,
            if let val = Int(textField.text!)
            {
                if val > 255 {
                    textField.text = "255"
                    
                }
                else if val < 0 {
                    textField.text = "0"
                    
                }
                else
                {
                    textField.text = "\(val)"
                }
            }
            else
            {
                textField.text = "0" // in case the value is not a valid number
            }
        }
        else if (textField.isEqual(brightnessTF))
        {
            // check to make sure that value is below 100,
            if let val = Int(textField.text!)
            {
                if val > 100 {
                    textField.text = "100"
                    
                }
                else if val < 0 {
                    textField.text = "0"
                    
                }
                else
                {
                    textField.text = "\(val)"
                }
            }
            else
            {
                textField.text = "0" // in case the value is not a valid number
            }
        }
        
        updateColorView()
        
        // figure out what to do for hex textfield
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
}
