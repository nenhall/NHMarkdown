//
//  ViewController.m
//  NHMarkdownDemo
//
//  Created by nenhall_work on 2018/10/16.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import "ViewController.h"
#import <NHMarkdown/NHMarkdown.h>
#import "NHMarkdownDemo-Swift.h"
#import <WebKit/WebKit.h>


@interface ViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *markdownContent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (nonatomic, weak) NHMarkdownView *mdView;
@property (nonatomic, strong) NHMarkdown *mdTool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *content = [self getLocalContent];
    NHMarkdown *mdTool = [[NHMarkdown alloc] init];
    _markdownContent = [mdTool markdownToHTML:content].copy;
    
    
    NHMarkdownView *mdView = [[NHMarkdownView alloc] init];
    mdView.frame = self.view.bounds;
    mdView.backgroundColor = [UIColor redColor];
    _mdView = mdView;
    [self.view addSubview:mdView];
    __weak typeof(self)weakself = self;
    [mdView nh_loadWithMarkdown:content completionHandler:^(WKWebView * _Nonnull wkWeb, WKNavigation * _Nullable wkNav) {
        wkWeb.UIDelegate = weakself;
        wkWeb.navigationDelegate = weakself;
    }];

}


/** 获取网络上的内容 */
- (NSString *)getNetworkContent {
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/matteocrippa/awesome-swift/master/README.md"];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return content;
}

/** 获取本地的markdown文档内容 */
- (NSString *)getLocalContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"穿越318线川藏游记.md" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return content;
}

/** 编辑 */
- (IBAction)edit:(UIBarButtonItem *)sender {
    _textView.text = _markdownContent;
    [_mdView setHidden:YES];
    [_textView setHidden:NO];
}

/** 刷新 */
- (IBAction)refresh:(UIBarButtonItem *)sender {
    [_textView endEditing:YES];
    [_mdView setHidden:NO];
    [_textView setHidden:YES];
}


#pragma mark - WKNavigationDelegate 加载状态回调
//页面开始加载
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(WKNavigation*)navigation
{
    NSLog(@"%s",__func__);
}

//从一个h5 进入另一个h5
- (void)webView:(WKWebView*)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation*)navigation
{
    NSLog(@"%s",__func__);
}

- (void)userContentController:(WKUserContentController*)userContentController didReceiveScriptMessage:(WKScriptMessage*)message
{
    NSLog(@"%s",__func__);
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationResponse:(WKNavigationResponse*)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%s--%@",__func__,navigationResponse.response);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"%s--%@",__func__,navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//页面加载完成
- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation
{
    NSLog(@"%s",__func__);
    
}



//加载失败
- (void)webView:(WKWebView*)webView
didFailNavigation:(null_unspecified WKNavigation*)navigation
      withError:(nonnull NSError*)error
{
    
    if (error.code != NSURLErrorCancelled) {

    }
    NSLog(@"%@", error);
}


@end
