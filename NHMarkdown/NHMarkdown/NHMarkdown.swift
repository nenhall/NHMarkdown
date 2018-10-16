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
    
    @objc public func markdownToHTML(_ markdown: String) -> String {
//        return markdownToHTML(markdown, options: .safe)
        var html : String?
        do {
            html = try EFMarkdown().markdownToHTML(markdown, options: .safe)
            
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }
        return html ?? ""
    }
}


@objc public class NHMarkdownView: EFMarkdownView {
  
    @objc public func nh_load(markdown: String?, completionHandler: ((WKWebView, WKNavigation?) -> Void)?) {
        load(markdown: markdown, options: .safe, completionHandler: completionHandler)
    }
    
    
    
    
}

