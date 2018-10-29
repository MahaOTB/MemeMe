//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Maha on 29/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {
    
    // MARK: Outlet
    
    @IBOutlet var memesTable: UITableView!
    
    // MARK: Properties
    
    let cellIdentity = "memesCells"
    var memes: [Meme]?
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAndSetAppDelegateArray(set: false)
    }
    
    // MARK: UITableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let meme = memes else { return 0}
        return meme.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity)
        cell?.textLabel?.text = ("\(memes![indexPath.row].topText!) | \(memes![indexPath.row].botoomText!)")
        cell?.imageView?.image = memes![indexPath.row].memoImage
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ShowMemeImageIdentity") as! ShowMemeImageViewController
        viewController.meme = self.memes![indexPath.row]
        viewController.indexOfmeme = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            memes?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            getAndSetAppDelegateArray(set: true)
        }
    }
    
    // MARK: Functions
    
    func getAndSetAppDelegateArray (set: Bool){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if set {
            appDelegate?.memes = memes!
        } else {
            guard let memeArray = appDelegate?.memes else { return }
            memes = memeArray
        }
        memesTable.reloadData()
    }
    
}
