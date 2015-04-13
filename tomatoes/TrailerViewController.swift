//
//  TrailerViewController.swift
//  tomatoes
//
//  Created by Sherman Leung on 4/9/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var synopsisLabel: UILabel!
  var videoID: NSString!
  var synopsisText: NSString!
  var titleText: NSString!
  
  @IBOutlet var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
      titleLabel.text = titleText
      synopsisLabel.text = synopsisText
      let playerVars:NSDictionary = ["autoplay" : 1]
    playerView.loadWithVideoId(videoID, playerVars: playerVars)
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
