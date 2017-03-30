//
//  ViewController.swift
//  tumblrClient
//
//  Created by Brandon Aubrey on 3/28/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [NSDictionary]()
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)


    
        refreshControlAction(refreshControl: refreshControl)
        
        tableView.rowHeight = 10
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let response = (responseDictionary["response"] as? NSDictionary) {
                    //NSLog("response: \(responseDictionary)")
                    self.posts = (response["posts"] as? [NSDictionary])!
                    self.tableView.reloadData()
                    
                    refreshControl.endRefreshing()
                    
                }
            }
        });
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let post = posts[indexPath.row]
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            vc.imgURL = (photos[0].value(forKeyPath: "original_size.url") as? String)!
            
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
    }
}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tumblrCell", for: indexPath) as! tumblrCell

        let post = posts[indexPath.row]
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            let imageUrl = URL(string: imageUrlString!)!
            cell.photoImageView.setImageWith(imageUrl)

        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        return cell
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // set the avatar
        profileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        let label = "hello"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "photoDetailsViewController") as! PhotoDetailsViewController
//        //vc.movie = moviesArray[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
}

extension PhotosViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
            }
        }
    }
}

