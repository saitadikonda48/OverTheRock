//
//  FeedHelper.swift
//  RSS
//
//  Created by Sai Tadikonda 10-20-2015
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit

class FeedHelper: NSObject, NSXMLParserDelegate {
    
    var articles:[Article] = [Article]()
    
    // Parser vars
    var currentElement:String = ""
    var foundCharacters:String = ""
    var attributes:[NSObject:AnyObject]?
    var currentlyConstructingArticle:Article = Article()
    
    override init() {
        super.init()
    }
    
    func startParsing(feedUrl:NSURL) {
        
        let feedParser:NSXMLParser? = NSXMLParser(contentsOfURL: feedUrl)
        
        if let actualFeedParser = feedParser {
            
            // Download feed and parse out articles
            actualFeedParser.delegate = self
            actualFeedParser.parse()
            
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == "entry" ||
            elementName == "item" ||
            elementName == "title" ||
            elementName == "content" ||
            elementName == "guid" ||
            elementName == "link" {
                
                self.currentElement = elementName
                self.attributes = attributeDict
        }
        
        if elementName == "entry" || elementName == "item" {
            
            // Start new article
            self.currentlyConstructingArticle = Article()
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        if let chars = string {
            
            if self.currentElement == "entry" ||
                self.currentElement == "item" ||
                self.currentElement == "guid" ||
                self.currentElement == "title" ||
                self.currentElement == "content" ||
                self.currentElement == "link" {
                    
                    self.foundCharacters += chars
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "title" {
            
            // Parsing of the title element is complete, save the data into the article obj
            let title:String = foundCharacters.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            self.currentlyConstructingArticle.articleTitle = title
        }
        else if elementName == "content" {
            
            // Parsing of the content element is complete, save the data into the article obj
            self.currentlyConstructingArticle.articleDesc = foundCharacters
            
            // Extract out article image from the content and save it to the articleImageUrl property of the article obj
            
            // Search for http
            if let startRange = foundCharacters.rangeOfString("http", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                
                // If found, search for .jpg
                if let endRange = foundCharacters.rangeOfString(".jpg", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    
                    // Take the substring out from startrange to endrange
                    let imgString:String = foundCharacters.substringWithRange(Range<String.Index>(start: startRange.startIndex, end: endRange.endIndex))
                    
                    // Assign to article property
                    self.currentlyConstructingArticle.articleImageUrl = imgString
                }
                    // If .jpg is not found, then search for .png
                else if let endRange = foundCharacters.rangeOfString(".png", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    
                    // Take the substring out from startrange to endrange
                    let imgString:String = foundCharacters.substringWithRange(Range<String.Index>(start: startRange.startIndex, end: endRange.endIndex))
                    
                    // Assign to article property
                    self.currentlyConstructingArticle.articleImageUrl = imgString
                }
            }
        }
            
        else if elementName == "guid" {
            
            // Parsing of the title element is complete, save the data into the article obj
            let linkString:String = foundCharacters.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            self.currentlyConstructingArticle.articleLink = linkString
        }
            
        else if elementName == "link" {
            
            if(self.attributes!["href"] != nil) {
                // Parsing of the link element is complete, grab the href kvp out of the attributes dict
                self.currentlyConstructingArticle.articleLink = self.attributes!["href"] as! String
            }
        }
        else if elementName == "entry" || elementName == "item" {
            
            // Parsing of an entry element is complete, append the article obj to our array and start a new article obj
            self.articles.append(self.currentlyConstructingArticle)
        }
        
        // Reset found characters
        self.foundCharacters = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        // Use notification center to notify FeedModel
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("feedHelperFinished", object: self)
    }
}
