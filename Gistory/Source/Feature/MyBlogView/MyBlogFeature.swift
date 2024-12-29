import SwiftUI

struct MyBlogFeature: View {
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .edgesIgnoringSafeArea(.top)
                    .frame(width: 500, height: 374)
                
                HStack(spacing: 24) {
                    NavigationLink(destination: SearchFeature()) {
                        Image("Search")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    Image("TeamLogo")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .background(
                            Circle()
                                .fill(.gray)
                                .opacity(0.2)
                                .frame(width: 36, height: 36)
                        )
                }
                .padding(.leading, 280)
                .padding(.bottom, 300)
                
                VStack {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Name and blog text
                        Text("이름\n님의 블로그")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Text("구독자 0 - 구독중 1")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                        
                        Text("이름 님의 블로그 입니다.")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                        
                        // Buttons for Logout and Account Deletion
                        HStack(spacing: 12) {
                            Button {
                                // Logout action
                            } label: {
                                Text("로그아웃")
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                    )
                            }
                            
                            Button {
                                // Account deletion action
                            } label: {
                                Text("회원탈퇴")
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                    )
                            }
                        }
                        .padding(.bottom, 70)
                        
                        Text("MY BLOG")
                            .font(.system(size: 28))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 200)
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(1..<6, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(index)")
                                    .bold()
                                Text("김민준")
                            }
                            Text("내가 피부가 까만 이유는?")
                                .fontWeight(.semibold)
                            HStack {
                                Image("heart")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                Text("조회")
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                Text("2일전")
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                            }
                            .padding(.vertical, 15)
                            Rectangle()
                                .frame(height: 0.5)
                                .opacity(0.5)
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}

#Preview {
    MyBlogFeature()
}

