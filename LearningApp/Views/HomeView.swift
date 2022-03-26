//
//  ContentView.swift
//  LearningApp
//
//  Created by 林家任 on 2022/3/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        
        
        NavigationView{
            
            VStack(alignment:.leading) {
                
                Text("What do you want to today?")
                    .padding(.leading,20)
                
                ScrollView{
                    
                    LazyVStack{
                        
                        
                        ForEach(model.modules){ module in
                            
                            
                            VStack(spacing: 20){
                                
                                //Learning Card
                                
                                
                                NavigationLink(
                                    destination: ContentView().onAppear(perform: {model.beginModule(module.id)}), label: {HomeViewRow(image: module.content.image,title: "Learn \(module.category)", description: "\(module.content.description)", count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    })
                                
                                
                                //Test Card
                                HomeViewRow(image: module.test.image,title: " \(module.category) Test", description: "\(module.test.description)", count: "\(module.test.questions.count) Questionss", time: module.test.time)
                            }
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Stared")
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
