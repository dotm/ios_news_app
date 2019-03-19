//
//  ExternalAPI.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import Foundation

let NEW_YORK_TIMES_API_KEY = "pe0F0AWLBNiNzAAj9IZnGtK1XUeBG1uS"

func getNewsList(query: String?,page: Int){
    let emptyQuery = ""
    let urlString = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(query ?? emptyQuery)&page=\(page)&api-key=\(NEW_YORK_TIMES_API_KEY)"
    let url = URL(string: urlString)!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            print("Error fetching news list data:", error!.localizedDescription)
            return
        }
        
        print(String(data: data, encoding: .utf8)!)
    }
    task.resume()
}
