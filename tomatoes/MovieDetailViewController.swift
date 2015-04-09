//
//  MovieDetailViewController.swift
//  tomatoes
//
//  Created by Sherman Leung on 4/8/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

  var movie: NSDictionary!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var synopsisLabel: UILabel!
  @IBOutlet var posterImage: UIImageView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
      var url = movie.valueForKeyPath("posters.original") as? String
      posterImage.setImageWithURL(NSURL(string: url!)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
