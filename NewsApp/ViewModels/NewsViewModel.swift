//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

struct NewsViewModel {
    let title: String
    let image: UIImage
    let date: String
    let snippet: String
}

let defaultNewsViewModel = NewsViewModel(title: "News Title", image: UIImage(named:"default")!, date: "Date Unknown", snippet: "No snippet found for this news. No snippet found for this news. No snippet found for this news. No snippet found for this news. No snippet found for this news.")
