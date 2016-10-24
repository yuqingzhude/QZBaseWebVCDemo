//
//  QZBaseWKWebVC.m
//  QZBaseWKWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import "QZBaseWebVC.h"
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
    self.timeOut = 30;
    
    if (Version >= 8.0) {
        [self createWKWeb];
        self.webView = _wkWebView;
        NSLog(@"use WKWebView");
    }else{
        [self createUIWeb];
        self.webView = _uiWebView;
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
    _wkWebView.navigationDelegate = self;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.scrollView.delegate = self;
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_wkWebView];
}

- (void)createUIWeb
{
    _uiWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _uiWebView.scrollView.delegate = self;
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
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    mRequest.timeoutInterval = self.timeOut;
    NSLog(@"%@",self.url);
    if (_wkWebView) {
        [_wkWebView loadRequest:mRequest];
    }else{
        [_uiWebView loadRequest:mRequest];
    }
    
}

- (void)loadRequest:(NSString *)url
{
    self.url = url;
    [self loadUrl];
}

#pragma mark - 清除缓存&Cookie
- (void)cleanCacheAndCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - js
- (void)evaluateJavaScript:(NSString *)javaScript
{
    if (_wkWebView) {
        [_wkWebView evaluateJavaScript:javaScript completionHandler:^(id result, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else{
        [_uiWebView stringByEvaluatingJavaScriptFromString:javaScript];
    }
}
#pragma mark - 返回顶端
- (void)scrollToTop
{
    UIScrollView *scrollView;
    if (_wkWebView) {
        scrollView = (UIScrollView *)[[_wkWebView subviews] objectAtIndex:0];
    }else{
        scrollView = (UIScrollView *)[[_uiWebView subviews] objectAtIndex:0];
    }
    [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
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
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.startLoadBlock) {
        self.startLoadBlock(webView);
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigatio
{
//    self.title = webView.title;
    if (self.finishLoadBlock) {
        self.finishLoadBlock(webView);
    }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@",error);
    if (self.finishLoadBlock) {
        self.failLoadBlock(webView);
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.startLoadBlock) {
        self.startLoadBlock(webView);
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    ((UIScrollView *)[[webView subviews] firstObject]).contentSize=CGSizeMake(SCREEN_WIDTH, height);
//    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.finishLoadBlock) {
        self.finishLoadBlock(webView);
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    if (self.failLoadBlock) {
        self.failLoadBlock(webView);
    }
}
#pragma mark - 返回是什么类型的web
- (BOOL)isWKWebView
{
    if (_wkWebView) {
        return YES;
    }
    return NO;
}

- (BOOL)isUIWebView
{
    return ![self isWKWebView];
}

#pragma mark - 添加Bridge

- (void)addBridge
{
    if (!self.handler) {
        return;
    }
    if (_wkWebView) {
        [self.wkBridge registerHandler:@"handler" handler:self.handler];
    }else{
        [self.uiBridge registerHandler:@"handler" handler:self.handler];
    }
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

- (WebViewJavascriptBridge *)uiBridge
{
    if (!_uiBridge) {
        // 设置能够进行桥接
        [WebViewJavascriptBridge enableLogging];
#warning self.progressProxy
        WebViewJavascriptBridge *uiBridge= [WebViewJavascriptBridge bridgeForWebView:_uiWebView];
        [uiBridge setWebViewDelegate:self];
        _uiBridge = uiBridge;
    }
    return _uiBridge;
}

- (WKWebViewJavascriptBridge *)wkBridge
{
    if (!_wkBridge) {
        [WKWebViewJavascriptBridge enableLogging];
        WKWebViewJavascriptBridge *wkBridge=[WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
        [wkBridge setWebViewDelegate:self];
        _wkBridge = wkBridge;
    }
    return _wkBridge;
}
#pragma mark - otherMethod
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
        _wkWebView.scrollView.delegate = nil;
    }else{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [_uiWebView loadHTMLString:@"" baseURL:nil];
        [_uiWebView stopLoading];
        _uiWebView.delegate=nil;
        _uiWebView.scrollView.delegate = nil;
        [_uiWebView removeFromSuperview];
        _uiWebView=nil;
    }
}
@end
