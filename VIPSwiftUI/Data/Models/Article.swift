//
//  Article.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation
import CoreData

class Article: NSManagedObject, Decodable {
    
    required init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context) else {
            throw NSError(domain: "test", code: 400, userInfo: nil)
        }
        super.init(entity: entity, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.source = try? container.decodeIfPresent(Source.self, forKey: .source)
        self.author = try? container.decodeIfPresent(String.self, forKey: .author)
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.descriptionValue = try? container.decodeIfPresent(String.self, forKey: .description)
        self.url = try? container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try? container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try? container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.content = try? container.decodeIfPresent(String.self, forKey: .content)
    }
    
    enum CodingKeys: CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}
