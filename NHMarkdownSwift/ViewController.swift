//
//  ViewController.swift
//  NHMarkdownSwift
//
//  Created by nenhall_work on 2018/10/16.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

import UIKit
import WebKit
import NHMarkdown

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var textView: UITextView!
    public var _content: String = "";
    public var markView: NHMarkdownView = NHMarkdownView();
    public var _htmlContent: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let content: String = getNetworkContent();
        _content = content;
        
        _htmlContent = NHMarkdown().markdownToHTML(content);
        initializeMarkdownView(content: content)
        
    }
    
    /** 初始化markdown View */
    func initializeMarkdownView(content: String) -> Void {
        let screenSize = UIScreen.main.bounds
        markView.backgroundColor = UIColor.red
        markView.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height - 64)
        markView.onRendered = {
            [weak self] (height) in
            if let _ = self {
                // Optional: you can know the change of height in this block
                print("onRendered height: \(height ?? 0)")
            }
        }
        self.view.addSubview(markView)
        markView.load(markdown: content, options: .default) { [weak self] (wkView: WKWebView, wkNav: WKNavigation?) in
            // Optional: WKUIDelegate, WKNavigationDelegate
            wkView.uiDelegate = self;
            wkView.navigationDelegate = self;
            // Optional: you can change font-size with a value of percent here
            self?.markView.setFontSize(percent: 128)
            printLog("load finish!")
        }
    }
    
    
    /** 获取网络上的内容 */
    func getNetworkContent() -> String {
        let path: String = "https://raw.githubusercontent.com/matteocrippa/awesome-swift/master/README.md"
        guard let url: URL = URL(string: path),
        let content = try? String(contentsOf: url, encoding:String.Encoding.utf8)
        else {
            return ""
        };
        return content;
    }
    
    /** 获取本地的markdown文档内容 */
    func getLocalContent() -> String {
        if let path = Bundle.main.url(forResource: "穿越318线川藏游记", withExtension: "md") {
            do{
                return try String(contentsOf: path, encoding:String.Encoding.utf8)
            } catch {
                return ""
            }
        }
        return "";
    }
    
    @IBAction func refreshMarkdown(_ sender: Any) {
        markView.isHidden = false
        textView.isHidden = true
    }
    
    @IBAction func editMarkdown(_ sender: UIBarButtonItem) {
        textView.text = _content
        markView.isHidden = true
        textView.isHidden = false
    }
    
    
    /** WKUIDelegate, WKNavigationDelegate  */
    /** WKUIDelegate, WKNavigationDelegate  */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
    }
}

