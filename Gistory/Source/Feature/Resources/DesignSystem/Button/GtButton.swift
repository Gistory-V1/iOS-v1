//
//  GtButton.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//

import SwiftUI

struct GtButton: View {
    let text: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            Rectangle()
                .fill(Color.white)
                .frame(width: 345, height: 47)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 0.5)
                )
                .overlay(
                    Text(text)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .light))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
