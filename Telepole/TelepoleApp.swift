//
//  TelepoleApp.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI

let HOSTNAME = "https://app.wakanda.vip"

@main
struct TelepoleApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MapView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
