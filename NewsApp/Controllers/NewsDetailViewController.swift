//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {    
    //MARK: Outlets
    private weak var newsDetailView: NewsDetail!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle Hooks
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @objc final private func bookmarkCurrentNews(){
        newsDetailView.getCurrentPageHTML { (html) in
            guard let news = NewsDetailPointer.getCurrentNews() else {return}
            SavedNewsStorage.save(news: news, html: html)
        }
    }
    @objc final private func removeCurrentNewsFromBookMark(){
        guard let news = NewsDetailPointer.getCurrentNews() else {return}
        SavedNewsStorage.delete(news: news)
    }
    
    //MARK: Layout
    final private func setupLayout(){
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = getCorrectBookmarkItem()
        
        setupNewsDetail()
    }
    
    final private func getCorrectBookmarkItem() -> UIBarButtonItem{
        let news_isBookmarked = false
        if news_isBookmarked {
            let removeBookmark_button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeCurrentNewsFromBookMark))
            
            return removeBookmark_button
        }else{
            let addBookmark_button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarkCurrentNews))
            return addBookmark_button
        }
    }
    final private func setupNewsDetail(){
        let newsDetail = NewsDetail()
        view.addSubview(newsDetail)
        
        newsDetail.translatesAutoresizingMaskIntoConstraints = false
        newsDetail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsDetail.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        newsDetail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsDetail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.newsDetailView = newsDetail
    }
}
