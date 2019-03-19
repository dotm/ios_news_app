//
//  AsynchronousImageView.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

let globalImageCache = NSCache<AnyObject,UIImage>()

fileprivate let defaultImage = UIImage(named:"default")!
final class AsynchronousImageView: UIImageView {
    var key: String = emptyID   //always set .key before the .imageURL for correct caching behavior
    init(url: URL?){
        super.init(image: defaultImage)
        
        imageURL = url
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //always set .key before the .imageURL for correct caching behavior
    var imageURL: URL? {
        didSet {
            let cachedImage = globalImageCache.object(forKey: key as AnyObject)
            
            if let cachedImage = cachedImage {
                image = cachedImage
                return
            }
            
            if let url = imageURL {
                loadImageAsnychronously_thenCacheIt(url: url)
            }else{
                image = defaultImage
                cacheImage(defaultImage, key: key as AnyObject)
            }
        }
    }
    private func loadImageAsnychronously_thenCacheIt(url: URL){
        DispatchQueue.global(qos: .background).async {
            do {
                let image = try UIImage(data: Data(contentsOf: url))
                DispatchQueue.main.async {
                    self.image = image
                    self.cacheImage(image, key: self.key as AnyObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func cacheImage(_ image: UIImage?, key: AnyObject){
        globalImageCache.setObject(image ?? defaultImage, forKey: key)
    }
}
