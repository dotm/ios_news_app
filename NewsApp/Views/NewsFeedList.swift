//
//  NewsFeedList.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

final class NewsFeedList: UIView {
    var query: String = "" {
        didSet {
            guard query != oldValue else {
                return
            }
            
            loadedPages = 0
            newsList = []
            loadMoreNews_andStoreTheFirstPageOffline(query: query, page: loadedPages)
        }
    }
    var newsList: [NewsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.newsCollectionView.reloadData()
            }
        }
    }
    
    //MARK: Properties
    private let CELL_ID = "My news cell"
    private var loadedPages = 0
    private var loadingMoreNews = false {
        didSet {
            if loadingMoreNews {
                blinkBackgroundColor()
            }
        }
    }
    private var defaultLoadedBackgroundColor = UIColor.white
    private func blinkBackgroundColor(){
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingIndicator.backgroundColor = .gray
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.loadingIndicator.backgroundColor = self.defaultLoadedBackgroundColor
            }, completion: { (_) in
                if self.loadingMoreNews {
                    self.blinkBackgroundColor()  //continue blinking until finish loading
                }
            })
        }
    }
    
    //MARK: Outlets
    private weak var newsCollectionView: UICollectionView!
    private weak var loadingIndicator: UIView!

    //MARK: Initializers
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: Layout
    final private func setupLayout(){
        NotificationCenter.default.addObserver(self, selector: #selector(setCollectionViewColumns), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        setupLoadingIndicator()
        setupCollectionView()
        loadMoreNews_andStoreTheFirstPageOffline(query: query, page: loadedPages)
    }
    final private func setupLoadingIndicator(){
        let view = UIView()
        view.backgroundColor = defaultLoadedBackgroundColor
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.loadingIndicator = view
    }
    final private func setupCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.newsCollectionView = collectionView
    }
    @objc final private func setCollectionViewColumns(){
        newsCollectionView.collectionViewLayout = getCollectionViewLayout()
    }
}

extension NewsFeedList: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! NewsCollectionViewCell
        
        let model = newsList[indexPath.row]
        cell.news = NewsViewModel(model: model)
        
        return cell
    }
}

fileprivate var lastLoading: Date?
fileprivate var loadingOfflineNews = false
extension NewsFeedList: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToNewsDetailPage(newsArray: newsList, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let showingLastNews = indexPath.row == newsList.count - 1
        if showingLastNews {
            //limit loading news
            let secondsLimit_beforeLoadingPost = 2.0
            let allowedToLoad: Bool
            if let lastLoading = lastLoading {
                allowedToLoad = lastLoading < (Date() - secondsLimit_beforeLoadingPost)
            }else{
                allowedToLoad = true
            }
            lastLoading = Date()
            
            if !loadingMoreNews && allowedToLoad {
                loadMoreNews_andStoreTheFirstPageOffline(query: query, page: loadedPages)
            }
        }
    }
    
    private func loadMoreNews_andStoreTheFirstPageOffline(query: String, page: Int) {
        guard !loadingMoreNews else {return}
        
        loadingMoreNews = true
        getNewsList(query: query, page: loadedPages) { (newsModels, error) in
            self.loadingMoreNews = false
            guard error == nil else {
                let storedOfflineNews: [NewsModel] = OfflineNews.getNews()
                self.newsList = storedOfflineNews
                loadingOfflineNews = true
                return
            }
            
            if let newsModels = newsModels {
                if loadingOfflineNews {
                    self.newsList = newsModels
                    loadingOfflineNews = false
                }else{
                    self.newsList += newsModels
                }
                
                if self.loadedPages == 0 && query.isEmpty {
                    OfflineNews.store(news: self.newsList)
                }
                
                self.loadedPages += 1
            }
        }
    }
}
