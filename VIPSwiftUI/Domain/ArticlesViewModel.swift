//
//  ArticlesViewModel.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation

@MainActor
class ArticlesViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var hasMoreItems: Bool = false
    private lazy var interactor: ArticlesInteractor = {
        ArticlesInteractor()
    }()
    private var page: Int = 1
    
    func retrieveTopNews() async {
        isLoading.toggle()
        let result = await interactor.retrieveData()
        isLoading.toggle()
        handleResult(result)
    }
    
    func searchNews(_ search: String) async {
        articles = []
        page = 1
        isLoading.toggle()
        await performSearch(search)
        isLoading.toggle()
    }
    
    func searchMoreNews(_ search: String) async {
        page += 1
        await performSearch(search)
    }
    
    func performSearch(_ search: String) async {
        let result = await interactor.searchArticles(search, page, 10)
        switch result {
        case .success(let articles):
            self.hasMoreItems = articles.count >= 10
            self.articles.append(contentsOf: articles)
        case .failure(let error):
            self.error = error
        }
    }
    
    private func handleResult(_ result: Result<[Article], Error>) {
        switch result {
        case .success(let articles):
            self.articles = articles
        case .failure(let error):
            self.error = error
        }
    }
}
