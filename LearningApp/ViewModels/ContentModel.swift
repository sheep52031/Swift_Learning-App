//
//  ContentModel.swift
//  LearningApp
//
//  Created by 林家任 on 2022/3/25.
//

import Foundation


class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    //Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    //Current lesson
    @Published var currentLesson:Lesson?
    var currentLessonIndex = 0
    
    //Current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    
    
    
    var styleData: Data?
    
    init(){
    
        getLocalData()
    
    }
    
    
    //MARK: - Data Method
    
    func getLocalData(){
    
        //Get a url to the file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")

        //Read the file into a data object
        
        do{
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            
            
                let modules = try jsonDecoder.decode([Module].self, from: jsonData)
                
                //Assign parsed modules to modules property
            self.modules = modules
        }
        
        catch{
            print("Couldn't parse local data ")
        }
        
        
        //Get a url to the file
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
       
        do{
            
            //Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        
        catch{
            
            print("Couldn't parse local data ")
        }

    }
    
    //MARK: - Module navigation control methods
    
    func beginModule(_ moduleid:Int){
        
       //Find the Index for this module id
        for index in 0..<modules.count {

            if modules[index].id == moduleid {
                
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }

        //Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    //MARK: Lesson navigation control methods
    func beginLesson(_ lessonIndex:Int){
        //Check that the lesson Index is within range of module lessons
        
        if lessonIndex < currentModule!.content.lessons.count{
            currentLessonIndex = lessonIndex
        }
        else{
            currentLessonIndex = 0
        }
        
        //Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    
    func nextLesson(){
        
        //Advance the lesson index
        currentLessonIndex += 1
    
        
        //Check that it within range
        if currentLessonIndex < currentModule!.content.lessons.count{
            
            //Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        }
        else{
            //Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLeeson() -> Bool{
        
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }

    
    //MARK: Code Styling
    private func addStyling(_ htmlString: String) -> NSAttributedString{
        
        var resultString = NSAttributedString()
        var data = Data()
        
        //Add the styling data
        if styleData != nil{
            data.append(styleData!)
        }
        //Add the html data
        data.append(Data(htmlString.utf8))
        
        //Conver to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil){
            
            resultString = attributedString
        }
        return resultString
    }
}


