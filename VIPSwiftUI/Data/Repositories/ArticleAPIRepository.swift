//
//  ArticleAPIRepository.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation

class ArticleAPIRepository: NSObject, ArticleRepositoryInterface {
    
    fileprivate let apiKey: String = "d82c4383383a488cbc020d516d7031cc"
    
    func getArticles() async -> Result<[Article], Error> {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)") else {
            return .failure(NSError(domain: "Test", code: 400, userInfo: [NSLocalizedDescriptionKey: "invalid ep"]))
        }
        let urlSession = URLSession.shared
        do {
            let (data, _) = try await urlSession.data(for: URLRequest(url: url), delegate: nil)
            let articles = try self.mapData(data)
            SyncManager.shared.syncArticles(articles)
            return .success(articles)
        } catch let error {
            return .failure(error)
        }
    }
    
    var fetchTask: Task<[Article], Error>?
    
    func searchArticles(_ search: String, _ page: Int, _ limit: Int) async -> Result<[Article], Error> {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(search)&pageSize=\(limit)&page=\(page)&sortBy=publishedAt&apiKey=\(apiKey)") else {
            return .failure(NSError(domain: "Test", code: 400, userInfo: nil))
        }
        
        fetchTask?.cancel()
        
        fetchTask = Task { () -> [Article] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
                let articles = try self.mapData(data)
                SyncManager.shared.syncArticles(articles)
                return articles
            } catch let error{
                throw error
            }
        }
        
        
        do {
            let articles = try await fetchTask?.value
            return .success(articles ?? [])
        } catch let error {
            return .failure(error)
        }
    }
    
    private func mapData(_ data: Data) throws -> [Article] {
        let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        let articlesArray = json?["articles"] as? [[String: Any]] ?? []
        let jsonData = try JSONSerialization.data(withJSONObject: articlesArray, options: .fragmentsAllowed)
        let jsonDecoder = JSONDecoder()
        let articles = try jsonDecoder.decode([Article].self, from: jsonData)
        return articles
    }
}
