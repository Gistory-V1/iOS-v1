//
//  TabFeature.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//

import SwiftUI


struct TabFeature: View {
    
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
             MainFeature()
                .tabItem {
                    Image("MainTab")
                }
                .tag(0)
              WriteFeature()
                .tabItem {
                    Image("WriteTab")
                }
                .tag(1)
              BellFeature()
                .tabItem {
                    Image("BellTab")
                }
                .tag(2)
              MyBlogFeature()
                .tabItem {
                    Image("MyblogTab")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

#Preview {
    TabFeature()
}
