//
//  ArticleList.swift
//  VIPSwiftUI
//
//  Created by Alfredo Luco Gordon on 12-04-22.
//

import SwiftUI

struct ArticleList: View {
    
    @ObservedObject var vm: ArticlesViewModel
    @State var filter: String = ""
    
    init() {
        vm = ArticlesViewModel()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(vm.articles) { article in
                            Text(article.title ?? "")
                        }
                        
                        if filter != "" && vm.hasMoreItems {
                            ProgressView()
                                .task {
                                    await vm.searchMoreNews(filter)
                                }
                        }
                    }
                }
            }
            .task {
                await vm.retrieveTopNews()
            }
            .searchable(text: $filter)
            .onSubmit(of: .search) {
                Task {
                    await vm.searchNews(filter)
                }
            }
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
