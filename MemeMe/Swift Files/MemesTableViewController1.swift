//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Maha on 28/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class MemesTableViewController1: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var tvAllMemes: UITableView!
    
    // MARK: Properties
    
    let cellIdentity = "memesCells"
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let memeArray = appDelegate?.memes else { return [] }
        return (memeArray)
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tvAllMemes.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity)
        cell?.textLabel?.text = ("\(memes[indexPath.row].topText!) | \(memes[indexPath.row].botoomText!)")
        cell?.imageView?.image = memes[indexPath.row].memoImage
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ShowMemeImageIdentity") as? ShowMemeImageViewController
        viewController?.meme = self.memes[indexPath.row]
        navigationController?.pushViewController(viewController!, animated: true)
    }
}
