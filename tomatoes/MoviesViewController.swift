//
//  MoviesViewController.swift
//  tomatoes
//
//  Created by Sherman Leung on 4/8/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet var errorView: UIView!
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  var movies: [NSDictionary]! = [NSDictionary]()
  var refreshControl: UIRefreshControl!
  
  var searchActive : Bool = false
  var filtered:[NSDictionary] = [NSDictionary]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorView.hidden = true
    var nav = navigationController
    nav?.navigationBar.tintColor = UIColor(red: 255/255, green: 223/255, blue: 0, alpha: 1)
    // adds HUD for loading purposes
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ta5dbe46br3y5s3enkz2nxk9&limit=20&country=us")!
    var request = NSURLRequest(URL: url)
    
    // for pull to refresh
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
      self.movies = json["movies"] as [NSDictionary]
      self.tableView.reloadData()
      // hides the HUD
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    searchBar.delegate = self;
  }
  
  func onRefresh() {
    var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ta5dbe46br3y5s3enkz2nxk9&limit=20&country=us")!
    var request = NSURLRequest(URL: url)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
      if (error != nil) {
        //show error bar
        self.errorView.hidden = false
      } else {
        self.errorView.hidden = true
      }
      self.movies = json["movies"] as [NSDictionary]
      self.tableView.reloadData()
      // hides the HUD
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      self.refreshControl.endRefreshing()
    }
  }
  
  // search bar 
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchActive = true
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false
  }

  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filtered.removeAll(keepCapacity: false)
    for (var index=0; index<movies.count; index++) {
      var movie = movies[index]
      var title = movie["title"] as? String
      var synopsis = movie["synopsis"] as? String
      if (title!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || synopsis!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ){
        filtered.append(movie)
      }
    }
    if(filtered.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (searchActive) {
      return filtered.count
    }
    return movies.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as MovieCell
    cell.selectedBackgroundView = UIView()
    var movie: NSDictionary
    if(searchActive){
      movie = filtered[indexPath.row]
    } else {
      movie = movies[indexPath.row]
    }
    cell.titleLabel.text = movie["title"] as? String
    cell.synopsisLabel.text = movie["synopsis"] as? String
    var url = movie.valueForKeyPath("posters.thumbnail") as? String
    cell.moviePicture.setImageWithURL(NSURL(string: url!)!)
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var movieDetailViewController = segue.destinationViewController as MovieDetailViewController
    var cell = sender as MovieCell
    movieDetailViewController.lowResPicture = cell.moviePicture
    var indexPath = tableView.indexPathForCell(cell)!
    if(searchActive){
      movieDetailViewController.movie = filtered[indexPath.row]
    } else {
      movieDetailViewController.movie = movies[indexPath.row]
    }
    
  }
  
}
