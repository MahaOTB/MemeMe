//
//  ViewController.swift
//  MemeMe
//
//  Created by Maha on 22/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Alerts
    struct Alerts {
        static let AlertAction = "Ok"
        static let sourceUnavailable = "No photos in the Album"
        static let noImage = "No photo to share"
    }
    // MARK: Outlet
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    
    // MARK: Properties
    
    let imagePicker = UIImagePickerController()
    var defualtTextFieldTop: String?
    var defualtTextFieldTBottom: String?
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -1]
    
    struct Memo {
        var topText: String?
        var botoomText: String?
        var originalImage: UIImage?
        var memoImage: UIImage?
        
        init(topText: String?, botoomText: String?, originalImage: UIImage?, memoImage: UIImage?){
            self.topText = topText
            self.botoomText = botoomText
            self.originalImage = originalImage
            self.memoImage  = memoImage
        }
    }
    
    // MARK: Text Field Delegate objects
    
    let PreventTextDelegate = PreventTextOfTextFieldExceedDelegate()
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        textFieldTop.delegate = PreventTextDelegate
        textFieldBottom.delegate = PreventTextDelegate
        
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldTop.textAlignment = .center
        textFieldTop.adjustsFontSizeToFitWidth = true
        
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        textFieldBottom.textAlignment = .center
        textFieldBottom.adjustsFontSizeToFitWidth = true
        
        btnShare.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        defualtTextFieldTop = textFieldTop.text
        defualtTextFieldTBottom = textFieldBottom.text
        
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: Actions
    
    @IBAction func openPhotoAlbumAndCamera(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            //Camera button pressed
            imagePicker.sourceType = .camera
        } else {
            //photoLibrary button pressed
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(imagePicker.sourceType) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlert(title: Alerts.sourceUnavailable)
        }
    }
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        guard let _ = imageView.image else{
            showAlert(title: Alerts.noImage)
            return
        }
        let memoImgae = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memoImgae], applicationActivities: nil)
        present(activityController, animated: true)
        activityController.completionWithItemsHandler = { _, success, _, error in
            if success {
                self.saveImage()
            } else if let errorOccur = error {
                self.showAlert(title: "Error", message: errorOccur.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelImage(_ sender: UIBarButtonItem) {
        imageView.image = nil
        btnShare.isEnabled = false
        textFieldTop.text = defualtTextFieldTop
        textFieldBottom.text = defualtTextFieldTBottom
    }
    
    
    // MARK: UIImagePickerControllerDelegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            btnShare.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Functions
    
    func showAlert (title: String, message: String? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.AlertAction, style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func saveImage() {
        // Create meme object
        let _ = Memo(topText: textFieldTop.text, botoomText: textFieldBottom.text, originalImage: imageView.image, memoImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        showHideToolBar(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showHideToolBar(isHidden: false)
        
        return memedImage
    }
    
    func showHideToolBar (isHidden: Bool){
        toolBarTop.isHidden = isHidden
        toolBarBottom.isHidden = isHidden
    }
    
    //Functions to show and hide keyboard
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isEditing && self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}

