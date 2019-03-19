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
    var image: UIImage = UIImage(named:"default")!
    
    init(title: String) {
        self.title = title
    }
}
let defaultNewsViewModel = NewsViewModel(title: "News Title")
