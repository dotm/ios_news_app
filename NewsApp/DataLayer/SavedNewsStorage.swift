//
//  SavedNewsStorage.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import CoreData

enum SavedNewsStorage {
    //MARK: Public API
    static func save(news: NewsModel, html: String){
        save_news(news: news, html: html)
    }
    static func delete(news: NewsModel){
        delete_news(news: news)
    }
    static func getNews(news: NewsModel) -> NewsModel? {
        return getNews(newsID: news._id)
    }
    static func getNewsList() -> [NewsModel]{
        let list = getAll_savedNews() ?? []
        guard let entities = list as? [SavedNewsEntity] else {
            print("failure converting to SavedNewsEntity")
            return []
        }
        let models = entities.map({ (entity) -> NewsModel in
            return convertToModel(entity: entity)
        })
        return models
    }
    static func getNewsHTML(news: NewsModel) -> String {
        return getHTMLString(newsID: news._id)
    }
    
    //MARK: CoreData Stack
    static private let PERSISTENT_CONTAINER_NAME = "NewsApp"
    static private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: PERSISTENT_CONTAINER_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Error loading persistent store: \(error)")
            }
        })
        return container
    }()
    static private var managedObjectContext = persistentContainer.viewContext
    
    //MARK: Private Storage Layer
    private enum SAVED_NEWS {
        static let ENTITY = "SavedNewsEntity"
        static let ID = "id"
        static let TITLE = "title"
        static let WEB_URL = "webURL"
        static let IMAGE_URL = "imageURL"
        static let DATE = "date"
        static let SNIPPET = "snippet"
        static let SAVED_HTML = "savedHTML"
    }
    private enum SAVED_HTML {
        static let ENTITY = "SavedHTMLEntity"
        static let HTML_STRING = "htmlString"
    }
    
    static private func getAll_savedNews() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SAVED_NEWS.ENTITY)
        
        do {
            return try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            print("Failed fetching saved news: \(error)")
            return nil
        }
    }
    static private func convertToModel(entity: SavedNewsEntity) -> NewsModel {
        return NewsModel(
            _id: entity.id ?? emptyID,
            title: entity.title ?? "News Title",
            webURL: entity.webURL ?? URL(string: "http://dotm.github.io")!,
            imageURL: entity.imageURL,
            date: entity.date ?? "Date Unknown",
            snippet: entity.snippet ?? "No snippet found for this news."
        )
    }
    static private func getNews(newsID: String) -> NewsModel? {
        do {
            let resultArray = try managedObjectContext.fetch(newsFetchRequest(newsID: newsID)) as! [NSManagedObject]
            guard let result = resultArray.first else {return nil}
            
            let newsEntityOptional = result as? SavedNewsEntity
            guard let newsEntity = newsEntityOptional else {
                print("failure converting to SavedNewsEntity")
                return nil
            }
            
            return convertToModel(entity: newsEntity)
        } catch {
            print("Failed fetching news by id \(newsID): \(error)")
            return nil
        }
    }
    static private func getHTMLString(newsID: String) -> String {
        do {
            let resultArray = try managedObjectContext.fetch(newsFetchRequest(newsID: newsID)) as! [NSManagedObject]
            let news = resultArray.first as? SavedNewsEntity
            return news?.savedHTML?.htmlString ?? blankPage_HTMLString
        } catch {
            print("Failed fetching html string of \(newsID): \(error)")
            return blankPage_HTMLString
        }
    }
    static private func newsFetchRequest(newsID: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SAVED_NEWS.ENTITY)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "\(SAVED_NEWS.ID) == %@", newsID)
        
        return fetchRequest
    }
    static private func save_news(news: NewsModel, html: String){
        let htmlEntity = NSEntityDescription.entity(forEntityName: SAVED_HTML.ENTITY, in: managedObjectContext)!
        let htmlManagedObject = NSManagedObject(entity: htmlEntity, insertInto: managedObjectContext)
        htmlManagedObject.setValue(html, forKey: SAVED_HTML.HTML_STRING)
        
        let savedNewsEntity = NSEntityDescription.entity(forEntityName: SAVED_NEWS.ENTITY, in: managedObjectContext)!
        let savedNewsManagedObject = NSManagedObject(entity: savedNewsEntity, insertInto: managedObjectContext)
        savedNewsManagedObject.setValue(news._id, forKey: SAVED_NEWS.ID)
        savedNewsManagedObject.setValue(news.title, forKey: SAVED_NEWS.TITLE)
        savedNewsManagedObject.setValue(news.webURL, forKey: SAVED_NEWS.WEB_URL)
        savedNewsManagedObject.setValue(news.imageURL, forKey: SAVED_NEWS.IMAGE_URL)
        savedNewsManagedObject.setValue(news.date, forKey: SAVED_NEWS.DATE)
        savedNewsManagedObject.setValue(news.snippet, forKey: SAVED_NEWS.SNIPPET)
        savedNewsManagedObject.setValue(htmlManagedObject, forKey: SAVED_NEWS.SAVED_HTML)
        
        do {
            try managedObjectContext.save()
            Alert.bookmarkNews_success()
        } catch {
            print("Could not save news: \(error)")
            Alert.bookmarkNews_failed()
        }
    }
    static private func delete_news(news: NewsModel){
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: newsFetchRequest(newsID: news._id))
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            Alert.undo_bookmarkNews_success()
        } catch {
            print("Failed deleting saved news: \(error)")
            Alert.undo_bookmarkNews_failed()
        }
    }
}
