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
func goToNewsDetailPage(news: NewsViewModel){
    let newsDetail = NewsDetailViewController()
    newsDetail.viewedNews = news
    getTopNavigationController()?.pushViewController(newsDetail, animated: true)
}
