//
//  NewsList.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

final class NewsList: UIView {
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
        UIView.animate(withDuration: 1, animations: {
            self.loadingIndicator.backgroundColor = .gray
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
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
        loadMoreNews(page: loadedPages)
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
    final private func getCollectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing = CGFloat(20)
        let margins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let cellsPerRow: Int
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let deviceOrientation_isLandscape = screenWidth > screenHeight
        if deviceOrientation_isLandscape {
            cellsPerRow = 4
        }else{
            cellsPerRow = 1
        }
        
        let layout = ColumnFlowLayout(cellsPerRow: cellsPerRow, minimumInteritemSpacing: spacing, minimumLineSpacing: spacing, sectionInset: margins)
        return layout
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
extension NewsList: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let showingLastNews = indexPath.row == newsList.count - 1
        if showingLastNews {
            if !loadingMoreNews {
                loadMoreNews(page: loadedPages)
            }
        }
    }
    
    func loadMoreNews(page: Int) {
        guard !loadingMoreNews else {return}
        
        loadingMoreNews = true
        getNewsList(query: nil, page: loadedPages) { (newsViewModels, error) in
            self.loadingMoreNews = false
            guard error == nil else {return}
            
            if let newsViewModels = newsViewModels {
                self.newsList += newsViewModels
                self.loadedPages += 1
            }
        }
    }
}


final class NewsCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    var news: NewsViewModel = defaultNewsViewModel{
        didSet {
            newsTitleLabel.text = news.title
            newsDateLabel.text = news.date
            newsSnippet.text = news.snippet
            
            //always set .key before the .imageURL for correct caching behavior
            newsImageView.key = news._id
            newsImageView.imageURL = news.imageURL
        }
    }
    
    //MARK: Outlets
    private weak var newsTitleLabel: UILabel!
    private weak var newsImageView: AsynchronousImageView!
    private weak var newsDateLabel: UILabel!
    private weak var newsSnippet: UITextView!
    
    //MARK: Lifecycle Hook
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK: Setup Layout
    private func setupLayout(){
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        
        setupNewsTitleLabel()
        setupNewsImageView(previousElement: newsTitleLabel)
        setupNewsDate(previousElement: newsImageView)
        setupNewsSnippet(previousElement: newsDateLabel)
    }
    private func setupNewsTitleLabel(){
        let label = UILabel()
        label.text = news.title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        let parent = self
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        label.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor).isActive = true
        
        self.newsTitleLabel = label
    }
    private func setupNewsImageView(previousElement: UIView){
        let imageView = AsynchronousImageView(url: news.imageURL)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let parent = self
        parent.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor, multiplier: 0.5).isActive = true
        
        self.newsImageView = imageView
    }
    private func setupNewsDate(previousElement: UIView){
        let label = UILabel()
        label.text = news.date
        
        let parent = self
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        label.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor).isActive = true
        
        self.newsDateLabel = label
    }
    private func setupNewsSnippet(previousElement: UIView){
        let snippet = UITextView()
        snippet.isEditable = false
        snippet.isScrollEnabled = false
        
        snippet.text = news.snippet
        snippet.font = UIFont.systemFont(ofSize: 20)
        
        let parent = self
        parent.addSubview(snippet)
        snippet.translatesAutoresizingMaskIntoConstraints = false
        snippet.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        snippet.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        snippet.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        snippet.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor).isActive = true
        
        self.newsSnippet = snippet
    }
}

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}
