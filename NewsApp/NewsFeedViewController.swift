//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "News Feed"
        self.view.backgroundColor = .white
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            self.goToNewsDetailPage()
        }
    }
    
    final private func goToNewsDetailPage(){
        let newsDetail = NewsDetailViewController()
        self.navigationController?.pushViewController(newsDetail, animated: true)
    }

}

