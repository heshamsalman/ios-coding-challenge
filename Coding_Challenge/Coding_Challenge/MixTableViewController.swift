//
//  MixTableViewController.swift
//  Coding_Challenge
//
//  TODO: Cache the images for each cell, retrieve cached image
//  Created by Hesham Salman on 10/15/15.
//  Copyright © 2015 Hesham Salman. All rights reserved.
//

import UIKit

class MixTableViewController: UIViewController {
    var mixes: [Mix] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        RestApiManager.sharedInstance.getMixSet { response, error in
            if let m = response.mixSet?.mixes {
                self.mixes = m
                self.tableView.reloadData()
            } else {
                print("Houston, we have a problem (unable to get mixes)");
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "MixTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "MixTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MixTableViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentMix = mixes[indexPath.item]
        let cell: MixTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("MixTableViewCell") as! MixTableViewCell
        cell.avatarImage.image = nil
        cell.mixCoverImage.image = nil
        
        
        ImageLoader.sharedLoader.imageForUrl((currentMix.coverUrls?.croppedImgixUrl)!, completionHandler: { (image: UIImage?, url: String) in
            cell.mixCoverImage.image = image
        })
        
        ImageLoader.sharedLoader.imageForUrl((currentMix.user!.avatarUrls?.croppedImgixUrl)!, completionHandler: { (image: UIImage?, url: String) in
            cell.avatarImage.image = image
        })
        
        cell.loadItem(mix: currentMix)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixes.count
    }
}

extension MixTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 406.0;
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showMix", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMix" {
            let controller = segue.destinationViewController as! MixViewController
            let index = (sender as! NSIndexPath).item
            controller.mix = mixes[index]
        }
    }
}