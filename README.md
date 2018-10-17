# NHMarkdown

一个支持`Objective-C`、`Swift`的markdown文档显示、编辑及转换成HTML文档的工具

## Overview

sample1|sample2|sample3|  
:---------------------:|:---------------------:|:---------------------:|

![](https://github.com/nenhall/NHMarkdown/blob/master/img/preview.png)|

![](https://github.com/nenhall/NHMarkdown/blob/master/img/preview.png)|

![](https://github.com/nenhall/NHMarkdown/blob/master/img/edit.png)|



## Example

### OC：

1. 导入头文件
   ```objective-c
   #import <NHMarkdown/NHMarkdown.h>
   #import <WebKit/WebKit.h>
   ```

2. 预览markdown：
   <details><summary>方法展示</summary>

   ```objective-c
   //获取网络上的内容
   NSURL *url = [NSURL URLWithString:@"https://nenhall.github.io/2018/09/22/1677ziyouxing/"];
   NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
   //获取本地的markdown文档内容
   //NSString *path = [[NSBundle mainBundle] pathForResource:@"穿越318线川藏游记.md" ofType:nil];
   //NSURL *url = [NSURL fileURLWithPath:path];
   //NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
   NHMarkdownView *mdView = [[NHMarkdownView alloc] init];
   mdView.translatesAutoresizingMaskIntoConstraints = NO;
   [self.view addSubview:mdView];
   __weak typeof(self)weakself = self;
   [mdView nh_loadWithMarkdown:content completionHandler:^(WKWebView * _Nonnull wkWeb, WKNavigation * _Nullable wkNav) {
       // Optional: WKUIDelegate, WKNavigationDelegate
       wkWeb.UIDelegate = weakself;
       wkWeb.navigationDelegate = weakself;
   }];
   ```

   </details>

3. 编辑markdown文档：
   ```objective-c
   NSURL *url = [NSURL URLWithString:@"https://nenhall.github.io/2018/09/22/1677ziyouxing/"];
   NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];   
   _textView.text = content;
   ```

4. 转换成HTML文档：

   ```objective-c
   NSURL *url = [NSURL URLWithString:@"https://nenhall.github.io/2018/09/22/1677ziyouxing/"];
   NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];   
   NHMarkdown *mdTool = [[NHMarkdown alloc] init];
   //返回即是文档全部内容
   _markdownContent = [mdTool markdownToHTML:content].copy;
   ```


### swift：

1. 改相关头文件：

   ```swift
   import WebKit
   import NHMarkdown
   ```

2. 初始化markdown文档：
   <details><summary>方法展示</summary>

   ```swift
   /** 获取网络上的内容 */
   func getNetworkContent() -> String {
       let path: String = "https://nenhall.github.io/2018/09/22/1677ziyouxing/"
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
   ```

   </details>

3. 解析、编辑markdown：

   ```swift
   let content: String = getNetworkContent();
   textView.text = content
   ```

4. 转换成HTML文档：

   ```swift
   let content: String = NHMarkdown().markdownToHTML(getNetworkContent());
   ```

5. 初始化NHMarkdown、预览

   <details><summary>方法展示</summary>

   ```swift
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
   ```

   </details>



