//
//  OfflineNews.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import Foundation

enum OfflineNews {
    static func store(news: [NewsModel]){
        DispatchQueue.global(qos: .background).async {
            saveNews_toLocalStorage(news)
        }
    }
    static func getNews() -> [NewsModel]{
        return loadNews_fromLocalStorage()
    }
    
    private static let OFFLINE_NEWS_KEY = "Offline news list"
    private static func saveNews_toLocalStorage(_ news: [NewsModel]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(news) {
            UserDefaults.standard.set(encoded, forKey: OFFLINE_NEWS_KEY)
        }
    }
    private static func loadNews_fromLocalStorage() -> [NewsModel] {
        guard let array = UserDefaults.standard.object(forKey: OFFLINE_NEWS_KEY) as? Data else {return []}
        
        let decoder = JSONDecoder()
        if let news = try? decoder.decode([NewsModel].self, from: array) {
            return news
        }else{
            return []
        }
        
    }
}
