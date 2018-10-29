//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Maha on 29/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UICollectionViewController {

    // MARK: Outlet
    
    @IBOutlet var memesCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Properties
    
    var memes: [Meme]?
    let reuseIdentifier = "CollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionViewItem(space: 3.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let memeArray = appDelegate?.memes else { return }
        memes = memeArray
        memesCollection.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemesCollectionViewCell
        cell.imageView.image = memes![indexPath.row].memeImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ShowMemeImageIdentity") as! ShowMemeImageViewController
        viewController.meme = self.memes![indexPath.row]
        viewController.indexOfmeme = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Functions
    
    func setupCollectionViewItem (space: CGFloat){
        
        let dimension = (view.frame.size.width - (3 * space)) / 4
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
