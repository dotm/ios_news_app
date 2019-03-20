//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//
import Foundation

struct NewsViewModel {
    let _id: String
    let title: String
    let webURL: URL
    let imageURL: URL?
    let date: String
    let snippet: String
    
    init(model: NewsModel) {
        _id = model._id
        title = model.title
        webURL = model.webURL
        imageURL = model.imageURL
        date = formatISODateString(model.date)
        snippet = model.snippet
    }
}

fileprivate func formatISODateString(_ str: String) -> String {
    let toDateFormatter = ISO8601DateFormatter()
    guard let date = toDateFormatter.date(from:str) else {
        return "Date Unknown"
    }
    
    let toStringFormatter = DateFormatter()
    toStringFormatter.dateFormat = "dd MMM yyyy, hh:mm"
    return toStringFormatter.string(from: date)
}
