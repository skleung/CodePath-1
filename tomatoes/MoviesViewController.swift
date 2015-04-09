//
//  MoviesViewController.swift
//  tomatoes
//
//  Created by Sherman Leung on 4/8/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  var movies: [NSDictionary]! = [NSDictionary]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ta5dbe46br3y5s3enkz2nxk9&limit=20&country=us")!
    var request = NSURLRequest(URL: url)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
      self.movies = json["movies"] as [NSDictionary]
      self.tableView.reloadData()
    }
    tableView.delegate = self;
    tableView.dataSource = self;
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as MovieCell
    
    var movie = movies[indexPath.row]
    cell.titleLabel.text = movie["title"] as? String
    cell.synopsisLabel.text = movie["synopsis"] as? String
    var url = movie.valueForKeyPath("posters.thumbnail") as? String
    cell.moviePicture.setImageWithURL(NSURL(string: url!)!)
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var movieDetailViewController = segue.destinationViewController as MovieDetailViewController
    var cell = sender as MovieCell
    var indexPath = tableView.indexPathForCell(cell)!
    movieDetailViewController.movie = movies[indexPath.row]
    
  }
  
}
