//
//  SearchHistoryData.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import Foundation

enum SearchHistoryData {
    static private var history: [String] = loadSearchHistory_fromLocalStorage()
    static private let historyLimit = 10
    
    static func save(query: String?){
        guard let query = query else {return}
        guard !query.isEmpty else {return}
        
        //keep query on search history unique
        let index = history.firstIndex(of: query)
        if index != nil {
            history.remove(at: index!)
        }
        
        history.append(query)
        if history.count > historyLimit {
            let sliced = history[history.count-historyLimit..<history.count]
            history = Array(sliced)
        }
        
        saveSearchHistory_toLocalStorage()
    }
    static func getHistory() -> [String]{
        if history.count > historyLimit {
            let sliced = history[history.count-historyLimit..<history.count]
            history = Array(sliced)
            
            saveSearchHistory_toLocalStorage()
        }
        return history.reversed()
    }
    
    private static let SEARCH_HISTORY_ARRAY_KEY = "Search History Array"
    private static func saveSearchHistory_toLocalStorage(){
        UserDefaults.standard.set(history, forKey: SEARCH_HISTORY_ARRAY_KEY)
    }
    private static func loadSearchHistory_fromLocalStorage() -> [String] {
        let array = UserDefaults.standard.array(forKey: SEARCH_HISTORY_ARRAY_KEY) as? [String]
        return array ?? []
    }
}
