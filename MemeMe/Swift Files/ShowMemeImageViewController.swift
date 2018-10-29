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
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        memeImage.image = meme?.memoImage
    }

}
