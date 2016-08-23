//
//  QZBaseWKWebVC.m
//  QZBaseWKWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import "QZBaseWebVC.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define progressBarHeight  2.f
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define Version [[UIDevice currentDevice].systemVersion floatValue]

@interface QZBaseWebVC ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate,UIScrollViewDelegate,NJKWebViewProgressDelegate>
{
    WKWebView *_wkWebView;
    UIWebView *_uiWebView;
}
@end

@implementation QZBaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (Version >= 8.0) {
        [self createWKWeb];
        NSLog(@"use WKWebView");
    }else{
        [self createUIWeb];
        NSLog(@"use UIWebView");
    }
    [self addProgressView];
    [self loadUrl];
    
}

#pragma mark - create WK OR UI web
- (void)createWKWeb
{
    WKWebViewConfiguration *configuration=[[WKWebViewConfiguration alloc] init];
    // Webview的偏好设置
    configuration.preferences.minimumFontSize = 10;
    configuration.preferences.javaScriptEnabled = YES;
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKUserContentController *ucController = [[WKUserContentController alloc] init];
    WKProcessPool *processPool = [[WKProcessPool alloc] init];
    configuration.processPool = processPool;
    configuration.userContentController = ucController;
    
    for (NSHTTPCookie* cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies)
    {
        NSString *javascript = [NSString stringWithFormat:@"document.cookie = '%@=%@';", [cookie name], [cookie value]];
        [ucController addUserScript:[[WKUserScript  alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO]];
    }
    
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    _wkWebView.navigationDelegate=self;
    _wkWebView.allowsBackForwardNavigationGestures=YES;
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_wkWebView];
    
}

- (void)createUIWeb
{
    _uiWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_uiWebView];
    _uiWebView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
#pragma mark - 添加progressView
- (void)addProgressView
{
    [self.view addSubview:self.progressView];
}
- (void)hideProgressView
{
    [self.progressView removeFromSuperview];
}
#pragma mark - 加载url
- (void)loadUrl
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    NSLog(@"%@",self.url);
    if (_wkWebView) {
        [_wkWebView loadRequest:req];
    }else{
        [_uiWebView loadRequest:req];
    }
    
}

- (void)loadRequest:(NSString *)url
{
    self.url = url;
    [self loadUrl];
}
#pragma mark - 监听mk progress
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [_progressView setProgress:_wkWebView.estimatedProgress animated:YES];
        self.progressView.hidden = _wkWebView.estimatedProgress == 1.0;
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.progressView.hidden = _wkWebView.estimatedProgress == 1.0;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigatio
{
    
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - lazyload
- (NJKWebViewProgressView*)progressView
{
    if (!_progressView) {
        NJKWebViewProgressView *progressView=[[NJKWebViewProgressView alloc] init];
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        progressView.frame = CGRectMake(0, 64, navigationBarBounds.size.width, progressBarHeight);
        _progressView = progressView;
    }
    return _progressView;
}

- (NJKWebViewProgress*)progressProxy
{
    if (!_progressProxy) {
        NJKWebViewProgress *progressProxy=[[NJKWebViewProgress alloc] init];
        _progressProxy = progressProxy;
    }
    return _progressProxy;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)dealloc
{
    if (_wkWebView) {
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_wkWebView removeFromSuperview];
        _wkWebView = nil;
        [_wkWebView stopLoading];
    }else{
        [_uiWebView removeFromSuperview];
        _uiWebView = nil;
        [_uiWebView stopLoading];

    }
}
@end
