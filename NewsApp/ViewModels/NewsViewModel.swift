//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

struct NewsViewModel: Codable {
    let _id: String
    let title: String
    let webURL: URL
    let imageURL: URL?
    let date: String
    let snippet: String
}

let emptyID = "null"
let defaultNewsViewModel = NewsViewModel(_id: emptyID, title: "News Title", webURL: URL(string: "http://dotm.github.io")!, imageURL: nil, date: "Date Unknown", snippet: "No snippet found for this news. No snippet found for this news. No snippet found for this news. No snippet found for this news. No snippet found for this news.")
