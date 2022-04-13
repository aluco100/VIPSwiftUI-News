//
//  SyncManager.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation
import CoreData

class SyncManager {
    
    static let shared: SyncManager = SyncManager()
    private init() { }
    
    func syncArticles(_ data: [Article]) {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Article> = NSFetchRequest(entityName: String(describing: Article.self))
        do {
            let articles = try fetchRequest.execute()
            var articleSet: Set<String> = []
            for i in articles {
                articleSet.insert(i.title ?? "")
            }
            var dataToSave: [Article] = []
            for j in data {
                if articleSet.contains(j.title ?? "") {
                    continue
                }
                dataToSave.append(j)
            }
            for i in dataToSave {
                context.insert(i)
            }
            try context.save()
        } catch let error {
            print(error)
        }
    }
}
