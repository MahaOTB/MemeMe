//
//  ShowHideKeyboardDelegate.swift
//  MemeMe
//
//  Created by Maha on 25/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import UIKit

class PreventTextOfTextFieldExceedDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Prevent users from entring text width more than text field width
        if textField.font!.pointSize == textField.minimumFontSize {
            
            // Construct the text that will be in the field if this change is accepted
            var newText = textField.text! as NSString
            newText = newText.replacingCharacters(in: range, with: string) as NSString
            
            //Get the size of new text entered
            let currentAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: textField.font!]
            let sizeOfText = newText.size(withAttributes: currentAttributes).width
            
            //Get size of text field
            let sizeOfTextField = textField.frame.size.width
            
            return sizeOfTextField >= sizeOfText
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        // became first responder
        if textField.tag == 0 && textField.text == "TOP" {
            textField.text?.removeAll()
        } else if textField.tag == 1 && textField.text == "BOTTOM" {
            textField.text?.removeAll()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let viewController = ViewController()
        viewController.unsubscribeFromKeyboardNotifications()
    }
    
}
