//
//  OfflineNews.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import Foundation

enum OfflineNews {
    static func store(news: [NewsViewModel]){
        DispatchQueue.global(qos: .background).async {
            saveNews_toLocalStorage(news)
        }
    }
    static func getNews() -> [NewsViewModel]{
        return loadNews_fromLocalStorage()
    }
    
    private static let OFFLINE_NEWS_KEY = "Offline news list"
    private static func saveNews_toLocalStorage(_ news: [NewsViewModel]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(news) {
            UserDefaults.standard.set(encoded, forKey: OFFLINE_NEWS_KEY)
        }
    }
    private static func loadNews_fromLocalStorage() -> [NewsViewModel] {
        guard let array = UserDefaults.standard.object(forKey: OFFLINE_NEWS_KEY) as? Data else {return []}
        
        let decoder = JSONDecoder()
        if let news = try? decoder.decode([NewsViewModel].self, from: array) {
            return news
        }else{
            return []
        }
        
    }
}
