//
//  Util.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

func getTopNavigationController() -> UINavigationController? {
    let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
    return tab?.selectedViewController as? UINavigationController
}
func goToNewsDetailPage(newsArray: [NewsViewModel], index: Int){
    NewsDetailPointer.list = newsArray
    NewsDetailPointer.pointer = index
    
    let newsDetail = NewsDetailViewController()
    getTopNavigationController()?.pushViewController(newsDetail, animated: true)
}

enum NewsDetailPointer {
    static func getCurrentNews() -> NewsViewModel? {
        let currentNews = list[safe: pointer]
        return currentNews
    }
    static func moveToPreviousNews() {
        pointer -= 1
        
        //infinite scroll
        if pointer < 0 {
           pointer += list.count
        }
    }
    static func moveToNextNews(){
        pointer += 1
        
        //infinite scroll
        if pointer >= list.count {
            pointer -= list.count
        }
    }

    fileprivate static var list: [NewsViewModel] = []
    fileprivate static var pointer: Int = 0
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
