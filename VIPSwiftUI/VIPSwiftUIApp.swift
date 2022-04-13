//
//  VIPSwiftUIApp.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import SwiftUI

@main
struct VIPSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ArticleList()
        }
    }
}
