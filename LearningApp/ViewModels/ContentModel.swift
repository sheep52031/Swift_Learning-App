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
    
    //MARK: - Module  navigation control methods
    
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
    
    
    
    
    
    
    
    
    
    
    
}


