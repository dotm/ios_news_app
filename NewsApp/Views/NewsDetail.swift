//
//  NewsDetail.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import WebKit

class NewsDetail: UIView {
    //MARK: Outlets
    private weak var webView: WKWebView!

    //MARK: Initializers
    init(webViewDelegate: WKNavigationDelegate) {
        super.init(frame: CGRect.zero)
        setupLayout()
        setWebViewDelegate(delegate: webViewDelegate)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    //MARK: Layout
    final private func setupLayout(){
        self.backgroundColor = .gray
        setupWebView()
        
        let previousNewsRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleLeftPanEdge))
        previousNewsRecognizer.edges = .left
        previousNewsRecognizer.minimumNumberOfTouches = 1
        self.addGestureRecognizer(previousNewsRecognizer)
        
        let nextNewsRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRightPanEdge))
        nextNewsRecognizer.edges = .right
        nextNewsRecognizer.minimumNumberOfTouches = 1
        self.addGestureRecognizer(nextNewsRecognizer)
    }
    final private func setupWebView(){
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.webView = webView
        loadNews()
    }
    final private func setWebViewDelegate(delegate: WKNavigationDelegate){
        webView.navigationDelegate = delegate
    }
    
    final private func loadBlankPage(){
        webView.load(URLRequest(url: URL(string: blankPage_HTMLString)!))
    }
    final func getCurrentPageHTML(completion: @escaping (String)->()){
        let js = "document.documentElement.outerHTML.toString()"
        webView.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("Error evaluating js:", error.localizedDescription)
            }
            
            guard let result = result else { return }
            let html = result as? String
            
            completion(html ?? blankPage_HTMLString)
        }
    }
    final private func loadNews(){
        guard let news = NewsDetailPointer.getCurrentNews() else {
            webView.load(URLRequest(url: defaultURL_whenNewsNotFound))
            return
        }
        
        let news_isBookmarked = SavedNewsStorage.getNews(news: news) != nil
        if news_isBookmarked {
            //webView.loadHTMLString(SavedNewsStorage.getNewsHTML(news: news), baseURL: nil)
            webView.load(URLRequest(url: news.webURL))
        }else{
            webView.load(URLRequest(url: news.webURL))
        }
    }
    
    final private var panTriggered = false
    @objc final private func handleLeftPanEdge(gesture: UIScreenEdgePanGestureRecognizer){
        singlePanEvent (gesture: gesture) {
            NewsDetailPointer.moveToPreviousNews()
            loadNews()
        }
    }
    @objc final private func handleRightPanEdge(gesture: UIScreenEdgePanGestureRecognizer){
        singlePanEvent (gesture: gesture) {
            NewsDetailPointer.moveToNextNews()
            loadNews()
        }
    }
    final private func singlePanEvent(gesture: UIScreenEdgePanGestureRecognizer, closure: ()->()){
        switch gesture.state {
        case .began, .changed:
            if !panTriggered {
                let threshold: CGFloat = 100  // you decide this
                let translation = abs(gesture.translation(in: self).x)
                if translation >= threshold  {
                    loadBlankPage()
                    closure()
                    panTriggered = true
                }
            }
            
        case .ended, .failed, .cancelled:
            panTriggered = false
            
        default: break
        }
    }

}
