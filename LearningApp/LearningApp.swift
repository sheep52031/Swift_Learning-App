//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by 林家任 on 2022/3/25.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
