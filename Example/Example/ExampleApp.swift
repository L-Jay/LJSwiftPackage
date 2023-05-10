//
//  ExampleApp.swift
//  Example
//
//  Created by 崔志伟 on 2023/5/4.
//

import SwiftUI
import LJSwiftPackage

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    _configNetwork()
                }
        }
    }

    func _configNetwork() {
        LJNetwork.baseUrl = "http://apis.juhe.cn"
        LJNetwork.codeKey = "error_code"
        LJNetwork.successCode = 0
        LJNetwork.messageKey = "reason"
    }
}
