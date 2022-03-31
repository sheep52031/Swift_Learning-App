//
//  TestView.swift
//  LearningApp
//
//  Created by 林家任 on 2022/3/30.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
            if model.currentQuestion != nil {
                
                VStack{
                    
                    //Question number
                    Text("Question \(model.currentModuleIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    
                    
                    //Question
                    CodeTextView()
                    
                    
                    //Answers
                    
                    //Button
                 
                }
                .navigationBarTitle(" \(model.currentModule?.category ?? "")Test ")
            }
            else{
                //Test hasn't loaded yet
                ProgressView()
            }
            
        
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
