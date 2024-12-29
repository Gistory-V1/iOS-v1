//
//  SignUp.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//

import SwiftUI

struct SignUpFeature: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Text("SIGN UP")
                .font(.system(size: 32))
                .fontWeight(.semibold)
        }
        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 숨김
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss() // 뒤로가기 기능
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 10, height: 20)
                .padding(.leading, 15)
                .foregroundColor(.black)
        })
    }
    
}

#Preview {
    SignUpFeature()
}
