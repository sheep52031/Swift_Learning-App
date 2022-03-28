//
//  ContentView.swift
//  LearningApp
//
//  Created by 林家任 on 2022/3/26.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
      
        ScrollView {
            
            LazyVStack {
                
                if model.currentModule != nil {
                    
                    ForEach(0..<model.currentModule!.content.lessons.count) {index in
                        NavigationLink(destination: ContentDetailView()
                                        .onAppear(perform:{ model.beginLesson(index)}),
                        label: { ContentViewRow(index:index)})
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Learning \(model.currentModule?.category ?? "   ")")
        }  
    }
}

