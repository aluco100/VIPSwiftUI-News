//
//  ArticlesInteractor.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation

class ArticlesInteractor {
    var repo: ArticleRepositoryInterface
    
    init() {
        repo = ArticleAPIRepository()
    }
    
    func retrieveData() async -> Result<[Article], Error> {
        repo = ArticleAPIRepository()
        let result = await repo.getArticles()
        switch result {
        case .success(let articles):
            return .success(articles)
        case .failure:
            repo = ArticleCoreDataRepository()
            let coreDataResult = await repo.getArticles()
            return coreDataResult
        }
    }
    
    func searchArticles(_ search: String, _ page: Int, _ limit: Int) async -> Result<[Article], Error> {
        repo = ArticleAPIRepository()
        let result = await repo.searchArticles(search, page, limit)
        switch result {
        case .success(let articles):
            return .success(articles)
        case .failure:
            repo = ArticleCoreDataRepository()
            let coreDataResult = await repo.searchArticles(search, page, limit)
            return coreDataResult
        }
    }
}
