//
//  Keihatsu_iOSApp.swift
//  Keihatsu-iOS
//
//  Created by admin on 5/27/26.
//

import SwiftUI

@main
struct Keihatsu_iOSApp: App {
    @StateObject private var appEnvironment = AppEnvironment()
    @StateObject private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appEnvironment)
                .environmentObject(appRouter)
                .environment(\.keihatsuTheme, appEnvironment.theme)
        }
    }
}
