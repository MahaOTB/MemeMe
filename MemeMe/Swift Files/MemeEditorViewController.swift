//
//  ViewController.swift
//  MemeMe
//
//  Created by Maha on 22/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var reEditedMeme: Meme?
    var indexOfEditedMeme: Int?
    let imagePicker = UIImagePickerController()
    var defaultTextFieldTop: String?
    var defaultTextFieldTBottom: String?
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -1]
    
    // MARK: Text Field Delegate objects
    
    let PreventTextDelegate = PreventTextOfTextFieldExceedDelegate()
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imageView.contentMode = .scaleAspectFit
        
        settingTextFieldDelegate(textFieldTop)
        settingTextFieldDelegate(textFieldBottom)
        
        guard let editedmeme = reEditedMeme else {
            btnShare.isEnabled = false
            return
        }
        editedMeme(editedmeme: editedmeme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        defaultTextFieldTop = textFieldTop.text
        defaultTextFieldTBottom = textFieldBottom.text
        
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        let memeImgae = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memeImgae], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        present(activityController, animated: true)
        activityController.completionWithItemsHandler = { _, success, _, error in
            if success {
                self.saveImage()
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            } else if let errorOccur = error {
                self.showAlert(title: "Error", message: errorOccur.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelImage(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: UIImagePickerControllerDelegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
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
        let meme = Meme(topText: textFieldTop.text, bottomText: textFieldBottom.text, originalImage: imageView.image, memeImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let index = indexOfEditedMeme {
            appDelegate?.memes.remove(at: index)
        }
        
        appDelegate?.memes.append(meme)
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
    
    func settingTextFieldDelegate (_ textField: UITextField){
        textField.delegate = PreventTextDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
    }
    
    func editedMeme (editedmeme: Meme){
        imageView.image = editedmeme.originalImage
        textFieldTop.text = editedmeme.topText
        textFieldBottom.text = editedmeme.bottomText
    }
    
    //Functions to show and hide keyboard
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isEditing && self.view.frame.origin.y == 0 {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
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

