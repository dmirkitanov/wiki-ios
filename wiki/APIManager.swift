//
//  APIManager.swift
//  wiki
//
//  Created by dm on 10/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import AFNetworking

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    let apiURLString = "https://en.wikipedia.org/w/api.php"

    func getRandomArticles(continueMarker continueMarker: String?, success successBlock: ((articles: [Article], continueMarker: String?) -> Void)?, failure failureBlock: ((error: NSError) -> Void)?) {
        let params = [
            "action": "query",
            "generator": "random",
            "continue": (continueMarker != nil ? continueMarker! : ""),
            "format": "json",
            "grnnamespace": 0,
            "grnlimit": 10
        ]
        
        let manager = AFHTTPSessionManager()
        manager.GET(apiURLString, parameters: params, progress: nil, success: { (task: NSURLSessionTask, responseObject: AnyObject?) -> Void in
            
            print("JSON: " + (responseObject?.description)!)
            var articles: [Article] = []
            if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                if let query = jsonResult["query"] as? Dictionary<String, AnyObject> {
                    if let pages = query["pages"] as? Dictionary<String, AnyObject> {
                        for (_, pageData) in pages {
                            articles.append(Article(properties: pageData as! Dictionary<NSObject, AnyObject>))
                        }
                        
                        print(articles)
                        
                        var newContinueMarker: String?
                        if let jsonContinue = jsonResult["continue"] as? Dictionary<String, AnyObject> {
                            do {
                                let continueData = try NSJSONSerialization.dataWithJSONObject(jsonContinue, options: NSJSONWritingOptions())
                                newContinueMarker = String(data: continueData, encoding: NSUTF8StringEncoding)
                            } catch {
                            }

                        }
                        
                        successBlock?(articles: articles, continueMarker: newContinueMarker)
                        return
                    }
                }
                
                let error = NSError(domain: AppDelegate.errorDomain, code: AppDelegate.errorCodeGeneric, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
                failureBlock?(error: error)
            }
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                print("Error: " + error.localizedDescription)
                failureBlock?(error: error)
            }
        )
    }

    func getArticleSummary(pageId: Int, success successBlock: ((article: Article) -> Void)?, failure failureBlock: ((error: NSError) -> Void)?) {
        let params = [
            "action": "query",
            "prop": "extracts|pageimages",
            "format": "json",
            "exchars": 512,
            "exintro": "",
            "explaintext": "",
            "piprop": "thumbnail",
            "pithumbsize": 300,
            "pageids": pageId
        ]
        
        let manager = AFHTTPSessionManager()
        manager.GET(apiURLString, parameters: params, progress: nil, success: { (task: NSURLSessionTask, responseObject: AnyObject?) -> Void in
            
            if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                if let query = jsonResult["query"] as? Dictionary<String, AnyObject> {
                    if let pages = query["pages"] as? Dictionary<String, AnyObject> {
                        for (_, pageData) in pages {
                            let article = Article(properties: pageData as! Dictionary<NSObject, AnyObject>)
                            
                            print(article)
                            
                            successBlock?(article: article)
                            return
                        }
                    }
                }
                
                let error = NSError(domain: AppDelegate.errorDomain, code: AppDelegate.errorCodeGeneric, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
                failureBlock?(error: error)
            }
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                print("Error: " + error.localizedDescription)
                failureBlock?(error: error)
            }
        )
    }
    
    func getArticleContent(pageId: Int, success successBlock: ((article: Article) -> Void)?, failure failureBlock: ((error: NSError) -> Void)?) {
        let params = [
            "action": "query",
            "prop": "categories|revisions",
            "format": "json",
            "clshow": "!hidden",
            "rvprop": "content",
            "rvparse": "",
            "pageids": pageId
        ]
        
        let manager = AFHTTPSessionManager()
        manager.GET(apiURLString, parameters: params, progress: nil, success: { (task: NSURLSessionTask, responseObject: AnyObject?) -> Void in
            
            if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                if let query = jsonResult["query"] as? Dictionary<String, AnyObject> {
                    if let pages = query["pages"] as? Dictionary<String, AnyObject> {
                        for (_, pageData) in pages {
                            let article = Article(properties: pageData as! Dictionary<NSObject, AnyObject>)
                            
                            print(article)
                            
                            successBlock?(article: article)
                            return
                        }
                    }
                }
                
                let error = NSError(domain: AppDelegate.errorDomain, code: AppDelegate.errorCodeGeneric, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
                failureBlock?(error: error)
            }
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                print("Error: " + error.localizedDescription)
                failureBlock?(error: error)
            }
        )
    }
}

