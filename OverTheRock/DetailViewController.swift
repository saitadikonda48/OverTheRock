//
//  DetailViewController.swift
//  RSS
//
//  Created by Sai Tadikonda 10-20-2015
//  Copyright (c) 2015 TadCorp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var articleToDisplay:Article?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Check if there's an article to display
        if let actualArticle = self.articleToDisplay {
            
            // Create NSURL for the article url
            let url:NSURL? = NSURL(string: actualArticle.articleLink)
            
            // Check if an NSURL obj was created
            if let actualUrl = url {
                
                // Create NSURLRequest for the NSURL
                let urlRequest:NSURLRequest = NSURLRequest(URL: actualUrl)
                
                // Pass the request into the webview to load the page
                self.webView.loadRequest(urlRequest)
            }
        }
        
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
