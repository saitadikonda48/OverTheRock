//
//  GlobalNewsFeedModel.swift
//  Stuff
//
//  Created by Sai Tadikonda on 11/8/15.
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit

protocol GlobalNewsFeedModelDelegate {
    
    // Any FeedModelDelegate must implement this method
    // FeedModel will call this method when article array is ready
    func articlesReady()
}

class GlobalNewsFeedModel: NSObject {
    
    var feedUrlString:String = "http://feeds.bbci.co.uk/news/rss.xml?edition=int"
    var articles:[Article] = [Article]()
    var delegate:GlobalNewsFeedModelDelegate?
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
