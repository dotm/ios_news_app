//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import WebKit

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
        setCorrectBookmarkItem()
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
            self.setCorrectBookmarkItem()
        }
    }
    @objc final private func removeCurrentNewsFromBookMark(){
        guard let news = NewsDetailPointer.getCurrentNews() else {return}
        SavedNewsStorage.delete(news: news)
        setCorrectBookmarkItem()
    }
    
    //MARK: Layout
    final private func setupLayout(){
        self.view.backgroundColor = .white
        setCorrectBookmarkItem()
        
        setupNewsDetail()
    }
    final private func setCorrectBookmarkItem(){
        self.navigationItem.rightBarButtonItem = getCorrectBookmarkItem()
    }
    private var newsLoaded = false {
        didSet {setCorrectBookmarkItem()}
    }
    final private func getCorrectBookmarkItem() -> UIBarButtonItem{
        let news_isBookmarked: Bool
        if let currentNews = NewsDetailPointer.getCurrentNews() {
            news_isBookmarked = SavedNewsStorage.getNews(news: currentNews) != nil
        }else{
            news_isBookmarked = false
        }
        
        guard !news_isBookmarked else {
            let removeBookmark_button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeCurrentNewsFromBookMark))
            return removeBookmark_button
        }
        
        let addBookmark_button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarkCurrentNews))
        return addBookmark_button
        
        /* uncomment this after 'save news offline' feature works correctly
        if newsLoaded {
            let addBookmark_button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarkCurrentNews))
            return addBookmark_button
        }else{
            return UIBarButtonItem(title: "Loading", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
         */
    }
    final private func setupNewsDetail(){
        let newsDetail = NewsDetail(webViewDelegate: self)
        view.addSubview(newsDetail)
        
        newsDetail.translatesAutoresizingMaskIntoConstraints = false
        newsDetail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsDetail.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        newsDetail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsDetail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.newsDetailView = newsDetail
    }
}

extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        newsLoaded = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        newsLoaded = true
    }
}
