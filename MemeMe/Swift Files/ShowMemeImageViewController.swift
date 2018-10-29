//
//  ShowMemeImageViewController.swift
//  MemeMe
//
//  Created by Maha on 29/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class ShowMemeImageViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme?
    var indexOfmeme: Int?
    let viewControllerIdentity = "MemeEditorIdentity"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        memeImage.image = meme?.memoImage
        imageView.contentMode = .scaleAspectFit
    }
    
    @IBAction func reEditmeme(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentity) as! MemeEditorViewController
        viewController.reEditedMeme = self.meme
        viewController.indexOfEditedMeme = self.indexOfmeme
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    

}
