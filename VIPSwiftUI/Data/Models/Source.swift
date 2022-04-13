//
//  Source.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import Foundation
import CoreData

class Source: NSManagedObject, Decodable {
    
    required init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context) else {
            throw NSError(domain: "test", code: 400, userInfo: nil)
        }
        super.init(entity: entity, insertInto: nil)
        let container = try? decoder.container(keyedBy: CodingKeys.self)
//        self.id = try? container?.decodeIfPresent(Int32.self, forKey: .id)
        self.name = try? container?.decodeIfPresent(String.self, forKey: .name)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}
