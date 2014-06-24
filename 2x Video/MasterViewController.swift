//
//  MasterViewController.swift
//  2x Video
//
//  Created by Christopher Truman on 6/7/14.
//  Copyright (c) 2014 Truman. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreMedia

class Movie {
	var title:NSString?
	var URL:NSURL?
	var asset:AVAsset?
	var image:UIImage?
	init(title:NSString, URL:NSURL, asset:AVAsset, image:UIImage){
		self.title = title
		self.URL = URL
		self.asset = asset
		self.image = image
	}
}

class MasterViewController: UITableViewController {

	var objects = Movie[]()

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.registerNib(UINib(nibName: "MovieTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "Cell")

		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.clearsSelectionOnViewWillAppear = false
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}
		
		var predicateHomeVideo = MPMediaPropertyPredicate(value: MPMediaType.HomeVideo.value, forProperty: MPMediaItemPropertyMediaType)
		var predicateItunesU = MPMediaPropertyPredicate(value: MPMediaType.VideoITunesU.value, forProperty: MPMediaItemPropertyMediaType)
		var predicatePodcast = MPMediaPropertyPredicate(value: MPMediaType.VideoPodcast.value, forProperty: MPMediaItemPropertyMediaType)
		var predicateAssetURL = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)

		var query = MPMediaQuery(filterPredicates: NSSet(array: [predicateHomeVideo, predicateItunesU, predicatePodcast, predicateAssetURL]))
		
		var items = query.items
		var mediaItems = items
		
		if mediaItems.count == 0{
			var fileArray = NSBundle.mainBundle().pathsForResourcesOfType(".mov", inDirectory: "")
			for moviePath : AnyObject in fileArray {
				
				var url = NSURL(fileURLWithPath: moviePath as NSString)
				var asset = AVAsset.assetWithURL(url) as AVAsset
				
				var object:CGImageRef = AVAssetImageGenerator(asset: asset).copyCGImageAtTime(CMTimeMakeWithSeconds(30.0, 600), actualTime: nil, error: nil)
				var image = UIImage(CGImage: object)
				var movie:Movie = Movie(title: url.lastPathComponent, URL: url, asset: asset, image: image)
				objects.append(movie)
			}
		}
		
		for item : AnyObject in items
		{
			var mediaItem : MPMediaItem = item as MPMediaItem
			
			var title : AnyObject! = item.valueForProperty(MPMediaItemPropertyTitle)
			
			var assetURL : AnyObject! = mediaItem.valueForProperty(MPMediaItemPropertyAssetURL)
			
			var artwork : AnyObject? = mediaItem.valueForProperty(MPMediaItemPropertyArtwork)
			
			if assetURL != nil{
				var asset = AVAsset.assetWithURL(assetURL as NSURL) as AVAsset
				var object:CGImageRef = AVAssetImageGenerator(asset: asset).copyCGImageAtTime(CMTimeMakeWithSeconds(30.0, 600), actualTime: nil, error: nil)
				var image = UIImage(CGImage: object)
				var movie:Movie = Movie(title: title as NSString, URL: assetURL as NSURL, asset: asset, image: image)
				objects.append(movie)
			}
		}
		self.tableView.reloadData()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		// Do any additional setup after loading the view, typically from a nib.
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// #pragma mark - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
		var cell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as MovieTableViewCell

		let object = objects[indexPath!.row] as Movie
		if object.image != nil {
			cell.backgroundImageView.image = object.image!
		}
//		var moviePlayer = AVPlayer(URL: object.URL)
//		var playerLayer = AVPlayerLayer(player: moviePlayer)
//		playerLayer.frame = cell.contentView.bounds;
//		playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//		playerLayer.needsDisplayOnBoundsChange = true;
//		moviePlayer.play()
//		cell.contentView.layer.addSublayer(playerLayer)
		
		cell.overlayLabel.text = object.title
		return cell
	}
	
	override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
		return 250.0
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
		    objects.removeAtIndex(indexPath.row)
		    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
}

