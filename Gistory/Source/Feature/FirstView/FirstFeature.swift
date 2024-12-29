//
//  LoginFeature.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//

import SwiftUI

struct FirstFeature: View {
    var body: some View {
        NavigationView {
            VStack{
                Image("GistoryLogo")
                Text("GSM에서만 볼 수 있는 특별한 블로그")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .padding(.top, 24)
                Image("GistoryImage")
                    .resizable()
                    .frame(width: 340, height: 340)
                    .padding(.bottom, 92)
                
                GtButton(
                    text: "로그인",
                    //destination: AnyView(SignInFeature())
                    destination: AnyView(TabFeature().navigationBarBackButtonHidden(true))
                )
                GtButton(
                    text: "회원가입",
                    destination: AnyView(SignUpFeature())
                )
            }
        }
        
    }
}

#Preview {
    FirstFeature()
}
