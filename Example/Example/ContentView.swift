//
//  ContentView.swift
//  Example
//
//  Created by 崔志伟 on 2023/5/4.
//

import SwiftUI
import LJSwiftPackage

// MARK: - ContentView

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                doPost()
            } label: {
                Text("行政区域 Post request")
            }

            Button {
                LJNetwork.post(
                    "/simpleWeather/query",
                    params: [
                        //                        "key1": 1,
//                        "key2": "2",
                        "key": "f359141d6b74e818a1bfc813b0e3fcb6",
                        "city": "石家庄",
                    ],
                    extraHeaders: ["header1": "3", "header2": "4"]
                ) { model in // 不声明类型返回字典
                    print(model)
                } failure: { error in
                    print(error)
                }

            } label: {
                Text("天气 Post request")
            }
        }
        .padding()
    }

    func doPost() {
        LJNetwork.post(
            "/xzqh/query",
            params: [
                "key": "b0f6256515bfc7ae93ab3a48835bf91d",
                "fid": 130000,
            ]
        ) { (model: AreaModel) in // 声明Decodable的Model返回Model
            debugPrint(model)
        } failure: { error in
            debugPrint(error)
        }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
