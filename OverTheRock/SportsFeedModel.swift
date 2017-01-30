//
//  SportsFeedModel.swift
//  Stuff
//
//  Created by Sai Tadikonda on 11/8/15.
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit

protocol SportsFeedModelDelegate {
    
    // Any FeedModelDelegate must implement this method
    // FeedModel will call this method when article array is ready
    func articlesReady()
}

class SportsFeedModel: NSObject {
    
    var feedUrlString:String = "http://api.foxsports.com/v1/rss?partnerKey=zBaFxRyGKCfxBagJG9b8pqLyndmvo7UU"
//    var feedUrlString:String = "http://www.espn.com/espn/rss/news"
    var articles:[Article] = [Article]()
    var delegate:SportsFeedModelDelegate?
    var feedHelper:FeedHelper = FeedHelper()
    
    func getArticles() {
        
        // Create url
        let feedUrl:NSURL? = NSURL(string: feedUrlString)
        
        // Listen to notification center
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("parserFinished"), name: "feedHelperFinished", object: self.feedHelper)
        
        // Kick off feed helper to parse nsurl
        self.feedHelper.startParsing(feedUrl!)
        
        
    } // getArticles
    
    func parserFinished() {
        
        // assign parsers list of articles to self.articles
        self.articles = self.feedHelper.articles
        
        // Notify the view controller that the array of articles is ready
        
        // Check if there's an object assigned as the delegate
        // If so, call the articlesReady method on the delegate
        if let actualdelegate = self.delegate {
            
            // This means there is an obj assigned to the delegate property
            actualdelegate.articlesReady()
        }
        
    }
    
}
