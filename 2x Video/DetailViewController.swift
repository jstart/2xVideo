//
//  VideoViewController.swift
//  2x Video
//
//  Created by Christopher Truman on 6/7/14.
//  Copyright (c) 2014 Truman. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class VideoViewController: MasterViewController {

	@IBOutlet var detailDescriptionLabel: UILabel
	var player: AVPlayerViewController?
	var window: UIWindow?
	
	@lazy var playbackSpeedToolbar: UIToolbar = {
		let toolbar = UIToolbar(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.size.width, 40))
        var isiPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        var alpha:CGFloat
        if isiPad{
            alpha = 0.75
        }else{
            alpha = 0.25
        }
		toolbar.barTintColor = UIColor(white: alpha, alpha: alpha)
		return toolbar
	}()
	
	@lazy var playbackSpeedSlider: UISlider = {
        var isiPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        var width:CGFloat
        var alpha:AnyObject
        if isiPad{
            width = 650.0
        }else{
            width = 200.0
        }
		let slider = UISlider(frame: CGRectMake(60, 8, width, 25))
		slider.minimumValue = 0.1
		slider.value = 1.0
		slider.maximumValue = 4.0
		slider.tintColor = UIColor.blackColor()
		slider.addTarget(self, action: "speedButtonValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
		slider.backgroundColor = UIColor.clearColor()
		return slider
	}()
	
	@lazy var playbackSpeedLabel: UILabel = {
		let label = UILabel(frame: CGRectMake(10, 8, 60, 25))
		label.text = "1x"
		label.backgroundColor = UIColor.clearColor()
		return label
	}()
    
    var detailItem: Movie?
	
	func getKeyWindow() -> UIWindow	{
		return  UIApplication.sharedApplication().keyWindow
	}
	
	func speedButtonValueChanged(sender: UISlider){
		var text = "\(sender.value)" as NSString
		if text.length >= 3{
			text = text.stringByReplacingCharactersInRange(NSMakeRange(3, text.length-3), withString: "")
		}
		player!.player.rate = text.floatValue
		
		text = "\(text)x"
		playbackSpeedLabel.text = text
	}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = objects[indexPath.row] as Movie
        self.detailItem = object
        if var detail = self.detailItem! as Movie? {
            if var url = detail.URL as NSURL? {
                player = AVPlayerViewController()
                player!.player = AVPlayer(URL: url)
                player!.player.play()
                
                self.presentViewController(player, animated: true, completion: {
                    for subview in self.player!.view.subviews as UIView[] {
                        for subsubview in subview.subviews as UIView[] {
                            for subsubsubview in subsubview.subviews as UIView[] {
                                for subsubsubsubview in subsubsubview.subviews as UIView[] {
                                    if subsubsubsubview.frame.origin.y == UIScreen.mainScreen().bounds.size.height - 50{
                                        UIView.animateWithDuration(0.3, animations: {
                                            var frame:CGRect = subsubsubsubview.frame
                                            frame.origin.y -= self.playbackSpeedToolbar.frame.size.height
                                            frame.size.height += self.playbackSpeedToolbar.frame.size.height
                                            subsubsubsubview.frame = frame
                                        })
                                    }
                                    println(subsubsubsubview)
                                    if subsubsubsubview.frame.size.height == 50 + self.playbackSpeedToolbar.frame.size.height && subsubsubsubview.frame.origin.y == UIScreen.mainScreen().bounds.size.height - 90{
                                        for toolbarView in subsubsubsubview.subviews as UIView[] {
                                            UIView.animateWithDuration(0.3, animations: {
                                                var frame:CGRect = toolbarView.frame
                                                frame.origin.y -= self.playbackSpeedToolbar.frame.size.height
                                                frame.size.height += self.playbackSpeedToolbar.frame.size.height
                                                toolbarView.frame = frame
                                            })
                                        }
                                        self.playbackSpeedToolbar.alpha = 0.0
                                        subsubsubsubview.addSubview(self.playbackSpeedToolbar)
                                        UIView.animateWithDuration(0.3, animations: {
                                            self.playbackSpeedToolbar.alpha = 1.0
                                            self.playbackSpeedToolbar.addSubview(self.playbackSpeedSlider)
                                            self.playbackSpeedToolbar.addSubview(self.playbackSpeedLabel)
                                        })
                                    }
                                }
                            }
                        }
                    }
                    })
            }
        }
    }
}

