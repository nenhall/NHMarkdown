//
//  NHMarkdown.swift
//  NHMarkdown
//
//  Created by nenhall_work on 2018/10/12.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

import Foundation
import UIKit
import WebKit

@objc public class NHMarkdown: EFMarkdown {
    
    /// markdown 转换成 html
    ///
    /// - Parameter markdown: markdown原文
    /// - Returns: html
    @objc public func markdownToHTML(_ markdown: String) -> String {
        var html : String?
        do {
            html = try markdownToHTML(markdown, options: .safe)
            
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }
        return html ?? ""
    }
}


@objc public class NHMarkdownView: EFMarkdownView {
    
    /// 在safari浏览器上打开
    public var openOnSafari: Bool = false
    
    /// 加载markdown文档：如果是swift请调用：load(markdown:, options:.safe, completionHandler:）
    ///
    /// - Parameters:
    ///   - markdown: markdown原文
    ///   - completionHandler: 交互回调
    @objc public func load(markdown: String?, completionHandler: ((WKWebView, WKNavigation?) -> Void)? = nil) {
        load(markdown: markdown, options: .safe, completionHandler: completionHandler)
    }
    
    @objc public override func setFontSize(percent: CGFloat, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        super .setFontSize(percent: percent, completionHandler: completionHandler)
    }
    
}

extension NHMarkdownView {
    
    public override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        
        switch navigationAction.navigationType {
        case .linkActivated:
            if let onTouchLink = onTouchLink {
                if onTouchLink(navigationAction.request) {
                    if openOnSafari {
                        decisionHandler(.cancel)
                        onSafariWithUrl(url: url)
                    } else {
                        decisionHandler(.allow)
                    }
                } else {
                    decisionHandler(.cancel)
                    print("open url failed on WKWebView ：",url)
                }
            } else {
                if openOnSafari {
                    decisionHandler(.cancel)
                    onSafariWithUrl(url: url)
                } else {
                    decisionHandler(.allow)
                }
            }
        default:
            decisionHandler(.allow)
        }
    }
    
    @objc public func onSafariWithUrl(url: URL) {
        var canOpen: Bool = false
        #if os(iOS)
        canOpen = UIApplication.shared.canOpenURL(url)
        if canOpen {
            UIApplication.shared.openURL(url)
        } else {
            print("open url failed on Safari ：",url)
        }
        #elseif os(OSX)
        NSWorkspace.shared.open(url)
        #endif
    }
    
}
