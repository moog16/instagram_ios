//
//  PhotosViewController.swift
//  instagram
//
//  Created by Matthew Goo on 9/16/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var photos: NSArray = []
    @IBOutlet var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTableView.dataSource = self
        photoTableView.delegate = self
        
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=8f4c2ea4b24b441d8b150df622faa4ff")!
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, dataOrNil, errorOrNil) -> Void in
            if let data = dataOrNil {
                let object = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
                self.photos = object["data"] as! NSArray
            } else {
                if let error = errorOrNil {
                    NSLog("Error: \(error)")
                }
            }
            self.photoTableView.reloadData()
            
            NSLog("response: \(self.photos)")
        }
        
        photoTableView.rowHeight = 320;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.codepath.InstaPhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let photo = photos[indexPath.row] as! NSDictionary
        let photoUrlString = photo.valueForKeyPath("images.low_resolution.url") as! String
        let photoUrl = NSURL(string: photoUrlString)
        print("photos : \(photoUrl)")
        cell.photoView.setImageWithURL(photoUrl!)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.photos.count
    }
    

}
