import SwiftUI

struct MainFeature: View {
    @State private var isSubscribed: Bool = false
    @State private var subscriberCount: Int = 68
    
    let articles = [
        (author: "김승찬", title: "내가 피부가 까만 이유는?", date: "2일전", views: "123", content: "이것은 내가 피부가 까만 이유에 대한 글입니다."),
        (author: "김재관", title: "그림을 그리는 방법", date: "5일전", views: "234", content: "그림을 그리는 기본 방법에 대해 알려드립니다."),
        (author: "이산", title: "여행의 즐거움", date: "1주일 전", views: "345", content: "ㅁㄴㅇㄹㅁㄴㅇㄹㄴㅁㅇㄹㄴㅁㄹㅁㄴㅇㄹㅁㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㄹㅇㅁㅇㄴㄹㅁㄴㄹㅁㅇㄹㅁㄴㅇㄹ"),
        (author: "박정우", title: "요리의 기초", date: "2주 전", views: "456", content: "요리를 처음 시작하는 사람들을 위한 기초 가이드를 제공합니다."),
        (author: "정재원", title: "운동의 중요성", date: "3주 전", views: "567", content: "운동이 건강에 왜 중요한지에 대해 설명합니다.")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack(spacing: 200) {
                        Image("GistoryLogo")
                            .resizable()
                            .frame(width: 95, height: 25)
                        
                        HStack(spacing: 24) {
                            NavigationLink(destination: SearchFeature()) {
                                Image("Search")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Image("TeamLogo")
                                .background(
                                    Circle()
                                        .fill(.gray)
                                        .opacity(0.2)
                                        .frame(width: 24, height: 24)
                                )
                        }
                    }
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(articles.indices, id: \.self) { index in
                                NavigationLink(destination: DetailFeature(article: articles[index])) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("\(index + 1)")
                                                .foregroundColor(.black)
                                            Text(articles[index].author)
                                                .foregroundColor(.black)
                                        }
                                        Text(articles[index].title)
                                            .foregroundColor(.black)
                                            .fontWeight(.semibold)
                                        HStack {
                                            Image("heart")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                            Text("조회 \(articles[index].views)")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                                .fontWeight(.light)
                                            Text(articles[index].date)
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                                .fontWeight(.light)
                                        }
                                        .padding(.vertical, 15)
                                        Rectangle()
                                            .foregroundColor(.black)
                                            .frame(height: 0.5)
                                            .opacity(0.5)
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("구독자 왕 👑")
                                    .font(.system(size: 24))
                                    .fontWeight(.heavy)
                                    .padding(.leading, 24)
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("김승찬")
                                            .font(.system(size: 24))
                                            .fontWeight(.semibold)
                                        Text("✅ 구독자 \(subscriberCount)명")
                                            .font(.system(size: 12))
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            isSubscribed.toggle()
                                            if isSubscribed {
                                                subscriberCount += 1
                                            } else {
                                                subscriberCount -= 1
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Text(isSubscribed ? "구독 중" : "+ 구독")
                                                .font(.system(size: 16))
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: 80, height: 35)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DetailFeature: View {
    @State private var isSubscribed: Bool = false
    @State private var subscriberCount: Int = 68
    @Environment(\.presentationMode) var presentationMode
    let article: (author: String, title: String, date: String, views: String, content: String)
    
    var body: some View {
        ZStack{
            VStack{
                VStack(alignment: .leading){
                    HStack(spacing: 300) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 10, height: 20)
                                .foregroundColor(.black)
                        }
                        
                        Image("TeamLogo")
                            .background(
                                Circle()
                                    .fill(.gray)
                                    .opacity(0.2)
                                    .frame(width: 24, height: 24)
                            )
                    }
                    .padding(.bottom, 28)
                    
                    Text(article.title)
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .padding(.bottom, 12)
                    
                    HStack {
                        Text("\(article.author)")
                            .font(.system(size: 12))
                            .opacity(0.5)
                        
                        Rectangle()
                            .frame(width: 1, height: 10)
                            .opacity(0.5)
                        
                        Text("작성일: \(article.date)")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    .padding(.bottom, 25)
                    
                    
                    Text(article.content)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                        .frame(width: 345, height: 300)
                }
                Rectangle()
                    .fill(Color(UIColor.systemGray6))
                    .frame(width: 500, height:  90)
                    .overlay(
                        HStack(spacing: 130){
                            VStack(alignment: .leading, spacing: 8){
                                Text("이름")
                                    .font(.system(size: 18))
                                Text("안녕하세요. 이릉 입니다.")
                                    .font(.system(size: 12))
                                    .opacity(0.5)
                            }
                            Button(action: {
                                withAnimation {
                                    isSubscribed.toggle()
                                    if isSubscribed {
                                        subscriberCount += 1
                                    } else {
                                        subscriberCount -= 1
                                    }
                                }
                            }) {
                                HStack {
                                    Text(isSubscribed ? "구독 중" : "+ 구독하기")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                        .fontWeight(.light)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            }
                        }
                    )
                HStack{
                    Text("이름")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                    Text("님의 다른 글")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 24)
            .navigationBarBackButtonHidden(true)
            
            
        }
    }
}

#Preview {
    MainFeature()
}

