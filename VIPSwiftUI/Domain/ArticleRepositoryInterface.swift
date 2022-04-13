//
//  ArticleRepositoryInterface.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation

protocol ArticleRepositoryInterface: AnyObject {
    func getArticles() async -> Result<[Article], Error>
    func searchArticles(_ search: String, _ page: Int, _ limit: Int) async -> Result<[Article], Error>
}
