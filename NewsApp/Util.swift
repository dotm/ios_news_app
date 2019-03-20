//
//  Util.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

func getTopNavigationController() -> UINavigationController? {
    return UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
}
func goToNewsDetailPage(newsArray: [NewsViewModel], index: Int){
    let newsDetail = NewsDetailViewController()
    NewsDetailPointer.list = newsArray
    NewsDetailPointer.pointer = index
    getTopNavigationController()?.pushViewController(newsDetail, animated: true)
}
func getCurrentNews() -> NewsViewModel? {
    return NewsDetailPointer.list[safe: NewsDetailPointer.pointer]
}
fileprivate enum NewsDetailPointer {
    fileprivate static var list: [NewsViewModel] = []
    fileprivate static var pointer: Int = 0
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
