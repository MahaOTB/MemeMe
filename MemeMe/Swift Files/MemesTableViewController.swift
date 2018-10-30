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
    var memes =  [Meme]()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let memeArray = appDelegate?.memes else { return }
        memes = memeArray
        memesTable.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity)
        cell?.textLabel?.text = ("\(memes[indexPath.row].topText!) | \(memes[indexPath.row].bottomText!)")
        cell?.imageView?.image = memes[indexPath.row].memeImage
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ShowMemeImageIdentity") as! ShowMemeImageViewController
        viewController.meme = self.memes[indexPath.row]
        viewController.indexOfmeme = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateAppDelegateArray(set: true)
        }
    }
    
    // MARK: Functions
    
    func updateAppDelegateArray (set: Bool){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.memes = memes
        memesTable.reloadData()
    }
    
}
