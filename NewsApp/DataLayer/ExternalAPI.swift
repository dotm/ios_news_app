//
//  ExternalAPI.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

let NEW_YORK_TIMES_API_KEY = "pe0F0AWLBNiNzAAj9IZnGtK1XUeBG1uS"
let NEW_YORK_TIMES_ABSOLUTE_URL = URL(string: "http://www.nytimes.com")

func getNewsList(query: String?, page: Int, completion: @escaping ([NewsViewModel]?)->()){
    let emptyQuery = ""
    let urlString = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(query ?? emptyQuery)&page=\(page)&api-key=\(NEW_YORK_TIMES_API_KEY)"
    let url = URL(string: urlString)!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            print("Error fetching news list data:", error!.localizedDescription)
            return
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            let response = dictionary?["response"] as? [String:Any]
            let newsList = response?["docs"] as? [[String:Any]]
            
            let arr = newsList?.map({ (news) -> NewsViewModel in
                let headline = news["headline"] as? [String:Any]
                let title = headline?["main"] as? String
                let date = news["pub_date"] as? String
                let snippet = news["snippet"] as? String
                
                let multimedia = news["multimedia"] as? [[String:Any]]
                let imageForPhone = multimedia?.first
                let image: UIImage
                
                do {
                    guard let imageURLString = imageForPhone?["url"] as? String else {
                        throw "error1"
                    }
                    guard let imageURL = URL(string: imageURLString, relativeTo: NEW_YORK_TIMES_ABSOLUTE_URL) else {
                        throw "error2"
                    }
                    guard let imageData = try UIImage(data: Data(contentsOf: imageURL)) else {
                        throw "error3"
                    }
                    image = imageData
                }catch{
                    //print(error)
                    image = defaultNewsImage
                }
                
                
                return NewsViewModel(
                    title: title ?? "Invalid Title",
                    image: image,
                    date: date ?? "Invalid Date",
                    snippet: snippet ?? "Invalid Snippet")
            })
            
            completion(arr)
        } catch {
            print(error.localizedDescription)
        }
    }
    task.resume()
}
