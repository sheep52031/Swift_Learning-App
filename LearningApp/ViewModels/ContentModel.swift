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
    
    //Current question
    @Published var currentQuestion:Question?
    @Published var currentQuestionIndex = 0
    
    //Current lesson explanation and current question content
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    //Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    

    init(){
        
        // Parse local included json data
        getLocalData()
        // Download remote json file and parse data
        getRemoteData()
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
    
    func getRemoteData(){
        
        //String path
        let urlString = "https://sheep52031.github.io/Swift_Learning-App/data2.json"
        
        //Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else{
            
            //Couldn't create url
            return
        }
        
        //Create a URLRequest object
        let request = URLRequest(url: url!)
        
        //Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            //Check if there's an error
            guard error == nil else{
                //There was an error
                return
            }
            
            do{
                //Create json decorder
                let decoder = JSONDecoder()
                
                //Decoode
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    // Append parsed modules into modules property
                    self.modules += modules
                }
                
            }
            catch{
                //Couldn't parse json
                print("Couldn't parse json")
            }
        }
        //Kick off data task
        dataTask.resume()
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
        codeText = addStyling(currentLesson!.explanation)
    }
    
    
    func nextLesson(){
        
        //Advance the lesson index
        currentLessonIndex += 1
    
        
        //Check that it within range
        if currentLessonIndex < currentModule!.content.lessons.count{
            
            //Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
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

    func beginTest(_ moduleId:Int){
        
        //set the current module
        beginModule(moduleId)
        
        //set the current question index
        currentQuestionIndex = 0
        
        //If there are question ,set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
             
             //Set the question content
            codeText = addStyling(currentQuestion!.content)
            
        }
    }
    
    func nextQuestion(){
  
        //Advance the question index
        currentQuestionIndex += 1
        //Check that it's within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count{
            
            //Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else{
            //If not,then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
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


