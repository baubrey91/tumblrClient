//
//  PhotoDetailsViewController.swift
//  tumblrClient
//
//  Created by Brandon Aubrey on 3/29/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var imgURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imgURL != "" {
            let imageUrl = URL(string: imgURL)!
            imgView.setImageWith(imageUrl)
        }

         //test.text = testInfo
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
