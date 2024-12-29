//
//  GtTextField.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//

import SwiftUI

struct GtTextField: View {
    @Binding var text: String
    var bigtitle: String
    var placeholder: String
    var errorText: String
    var isError: Bool
    var isSecure: Bool // SecureField 여부 추가
    var onSubmit: () -> Void
    
    @State private var isPasswordVisible: Bool = false // 비밀번호 표시 토글 상태
    
    public init(
        _ placeholder: String = "",
        text: Binding<String>,
        bigtitle: String = "",
        errorText: String = "",
        isError: Bool = false,
        isSecure: Bool = false,
        onSubmit: @escaping () -> Void = {}
    ) {
        self._text = text
        self.placeholder = placeholder
        self.bigtitle = bigtitle
        self.errorText = errorText
        self.isError = isError
        self.isSecure = isSecure
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(bigtitle)
                .font(.system(size: 14))
            
            ZStack(alignment: .trailing) {
                // 일반 텍스트 필드 또는 SecureField 전환
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .onSubmit(onSubmit)
                } else {
                    TextField(placeholder, text: $text)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .onSubmit(onSubmit)
                }
                
                // 눈 모양 버튼 (isSecure가 true일 때만 보임)
//                if isSecure {
//                    Button(action: {
//                        isPasswordVisible.toggle()
//                    }) {
//                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
//                            .foregroundColor(.gray)
//                            .padding(.trailing, 20)
//                    }
//                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black, lineWidth: 1)
                    .opacity(0.5)
            )
            
            if isError {
                Text(errorText)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 16)
    }
}
