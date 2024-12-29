import SwiftUI

struct SearchFeature: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var search: String = ""
    @State private var recentSearches: [SearchItem] = [
        SearchItem(keyword: "타투", date: "12.17."),
        SearchItem(keyword: "디자인", date: "12.17.")
    ]
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 30) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                
                TextField("지스토리에서 검색", text: $search, onCommit: addSearch)
                    .frame(width: 270)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    )
            }
            .padding(.horizontal, 18)
            
            HStack(spacing: 170){
                Text("최근 검색어")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                Button(action: {
                    showAlert = true
                }) {
                    Text("전체 삭제")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 10)
                        .foregroundColor(.red)
                }
            }
            
            // 최근 검색어 리스트
            List {
                ForEach(recentSearches, id: \.id) { search in
                    HStack {
                        Text(search.keyword)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text(search.date)
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        
                        Button(action: {
                            deleteSearch(item: search)
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, 16)
            
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("전체 삭제"),
                message: Text("최근 검색어를 모두 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제하기")) {
                    recentSearches.removeAll()
                },
                secondaryButton: .cancel(Text("아니요"))
            )
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    

    private func addSearch() {
        let trimmedSearch = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedSearch.isEmpty {
            let newSearch = SearchItem(keyword: trimmedSearch, date: currentDate())
            recentSearches.insert(newSearch, at: 0)
            search = "" // 입력창 초기화
        }
    }
    

    private func deleteSearch(item: SearchItem) {
        if let index = recentSearches.firstIndex(where: { $0.id == item.id }) {
            recentSearches.remove(at: index)
        }
    }
    
 
    private func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd."
        return formatter.string(from: Date())
    }
    

    struct SearchItem: Identifiable {
        let id = UUID()
        let keyword: String
        let date: String
    }
}

#Preview {
    SearchFeature()
}

