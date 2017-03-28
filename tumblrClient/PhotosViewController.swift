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
    var posts: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        self.posts = (response["posts"] as? [NSDictionary])
                    }
                    print(self.posts)

                }

            }
        });
        task.resume()
        
        tableView.rowHeight = 320
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
}*/

