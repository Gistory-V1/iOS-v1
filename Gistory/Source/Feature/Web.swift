//
//  Web.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//


import SwiftUI
import WebKit

struct MyWebView: UIViewRepresentable {
    var urlToLoad: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }

        let webView = WKWebView()

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebView>) {

    }
}

struct MyWebViewContainer: View {
    var urlToLoad: String

    var body: some View {
        MyWebView(urlToLoad: urlToLoad)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyWebViewContainer(urlToLoad: "https://www.google.com")
}
