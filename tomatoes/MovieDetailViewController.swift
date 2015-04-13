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
  var lowResPicture: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var synopsisLabel: UILabel!
  @IBOutlet var posterImage: UIImageView!
  @IBOutlet var ratingLabel: UILabel!
  @IBOutlet var ratingImage: UIImageView!
  var videoID: NSString!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      println(movie)
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
      var url = movie.valueForKeyPath("posters.original") as? String
      var range = url!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
      if let range = range {
        url = url!.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
      }
      // placeholder image
      posterImage.setImageWithURL(NSURL(string: url!)!, placeholderImage: lowResPicture.image!)
      
      // get rating
      var rating = movie.valueForKeyPath("ratings.audience_score") as? Int
      if (rating > 50) {
        ratingImage.image = UIImage(named: "fresh")
      } else {
        ratingImage.image = UIImage(named: "rotten")
      }
      ratingLabel.text = String(rating!)
      
      // search YT for a trailer link
      var query = movie["title"] as? String
      var toArray = query!.componentsSeparatedByString(" ")
      query = join("+", toArray)
      var API_KEY = "AIzaSyDDP01Gnj3-wfoqM59xQz6pryJQhmYWCt8"
      var full_request = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDDP01Gnj3-wfoqM59xQz6pryJQhmYWCt8&type=video&part=snippet&q=" + query!
      var YT_url = NSURL(string: full_request)!
      var request = NSURLRequest(URL: YT_url)
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        var results = json["items"] as [NSDictionary]
        self.videoID = results[0].valueForKeyPath("id.videoId") as? String
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation
*/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      var trailerView = segue.destinationViewController as TrailerViewController
      trailerView.videoID = videoID
      trailerView.synopsisText = synopsisLabel.text
      trailerView.titleText = titleLabel.text
    }


}
