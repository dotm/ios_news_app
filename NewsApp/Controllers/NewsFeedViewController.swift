//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    //MARK: Outlets
    private weak var newsList: NewsList!

    //MARK: Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupLayout()
    }
    
    //MARK: Action
    final private func goToNewsDetailPage(){
        let newsDetail = NewsDetailViewController()
        self.navigationController?.pushViewController(newsDetail, animated: true)
    }

    //MARK: Layout
    final private func setupLayout(){
        self.title = "News Feed"
        
        setupNewsList()
    }
    final private func setupNewsList(){
        let newsList = NewsList()
        view.addSubview(newsList)
        
        newsList.translatesAutoresizingMaskIntoConstraints = false
        newsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        newsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.newsList = newsList
    }
}

