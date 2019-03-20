//
//  NewsList.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

final class NewsList: UIView {
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
    var newsList: [NewsViewModel] = [] {
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

extension NewsList: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! NewsCollectionViewCell
        
        cell.news = newsList[indexPath.row]
        
        return cell
    }
}
#warning("rename NewsList to NewsFeedList")
extension NewsList: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        goToNewsDetailPage(news: news)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let showingLastNews = indexPath.row == newsList.count - 1
        if showingLastNews {
            if !loadingMoreNews {
                loadMoreNews_andStoreTheFirstPageOffline(query: query, page: loadedPages)
            }
        }
    }
    
    func loadMoreNews_andStoreTheFirstPageOffline(query: String, page: Int) {
        guard !loadingMoreNews else {return}
        
        loadingMoreNews = true
        getNewsList(query: query, page: loadedPages) { (newsViewModels, error) in
            self.loadingMoreNews = false
            guard error == nil else {
                #warning("implement this")
                let storedOfflineNews: [NewsViewModel] = []
                self.newsList = storedOfflineNews
                return
            }
            
            if let newsViewModels = newsViewModels {
                self.newsList += newsViewModels
                
                if self.loadedPages == 0 && query.isEmpty {
                    #warning("implement this in background thread")
                    print("store news")
                }
                
                self.loadedPages += 1
            }
        }
    }
}
