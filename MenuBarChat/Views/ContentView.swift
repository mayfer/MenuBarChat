//
//  ContentView.swift
//

import SwiftUI
import AppKit
import WebKit
import KeyboardShortcuts

extension URL {
    func isReachable(completion: @escaping (Bool) -> ()) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }
}
class Coordinator : NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if (url.absoluteString.contains("openai.com")
            || url.absoluteString.contains("microsoft.com")
            || url.absoluteString.contains("google.com")
            || url.absoluteString.contains("live.com")
        ){
            decisionHandler(.allow)
        } else {
            url.isReachable { success in
                if success {
                    decisionHandler(.cancel)
                    DispatchQueue.main.async {
                        NSWorkspace.shared.open(url)
                        
                        let appDelegate = NSApp.delegate as! AppDelegate
                        appDelegate.closePopover(sender: nil)
                    }
                            
                } else {
                    decisionHandler(.allow)
                }
            }
        }
    }
}

struct WebView: NSViewRepresentable {
    let url: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()        
        
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            // set zoom scale:
            // /nsView.configuration.preferences.setValue(0.5, forKey: "defaultZoomFactor")
            
            nsView.load(request)
        }
        
        nsView.navigationDelegate = context.coordinator //Assign the coordinator as the view's navigation delegate

    }
}

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Shorcut:", name: .openMenuBarChat)
        }
    }
}


struct ContentView: View {
    var body: some View {
        
        let appDelegate = NSApp.delegate as! AppDelegate

        let width = CGFloat(appDelegate.width)
        let height = CGFloat(appDelegate.height)
        
        
        VStack(alignment: .trailing, spacing: 0) {
            HStack {
                WebView(url: "https://chat.openai.com")
                    .frame(width: width, height: height)
            }
            HStack {
                SettingsScreen()
                    .padding(.top)
                    .frame(alignment: .trailing)
                Spacer()
                Button(action: {
                    NSApplication.shared.terminate(self)
                })
                {
                    Text("Quit")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.top)
                .frame(alignment: .trailing)
            }
            
        }
        .frame(width: width, alignment: .trailing)
        .padding(16.0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
