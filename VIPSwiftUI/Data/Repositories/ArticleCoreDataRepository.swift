//
//  ArticleCoreDataRepository.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation
import CoreData

class ArticleCoreDataRepository: ArticleRepositoryInterface {
    func getArticles() async -> Result<[Article], Error> {
        let fetchRequest = NSFetchRequest<Article>(entityName: String(describing: Article.self))
        do {
            let articles = try fetchRequest.execute()
            return .success(articles)
        } catch let error {
            return .failure(error)
        }
    }
    
    func searchArticles(_ search: String, _ page: Int, _ limit: Int) async -> Result<[Article], Error> {
        let fetchRequest = NSFetchRequest<Article>(entityName: String(describing: Article.self))
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", search)
        fetchRequest.fetchOffset = page * limit
        fetchRequest.fetchLimit = limit
        do {
            let articles = try fetchRequest.execute()
            return .success(articles)
        } catch let error {
            return .failure(error)
        }
    }
}
