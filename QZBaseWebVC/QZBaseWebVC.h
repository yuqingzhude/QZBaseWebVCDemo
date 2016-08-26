//
//  QZBaseWKWebVC.h
//  QZBaseWKWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"
#import "WebViewJavascriptBridgeBase.h"

/**
 *  系统大于ios8 使用wkwebView加载页面
 *             否则使用uiwebView加载页面
 */

@interface QZBaseWebVC : UIViewController
/** 子类类型转换*/
@property (nonatomic,weak) id webView;

@property (nonatomic,copy) NSString *url;

/** request.timeoutInterval*/
@property (nonatomic,assign) double timeOut;

@property (nonatomic,strong) NJKWebViewProgressView *progressView;

@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

@property (nonatomic,strong) WebViewJavascriptBridge *uiBridge;

@property (nonatomic,strong) WKWebViewJavascriptBridge *wkBridge;

@property (nonatomic,strong) WVJBHandler handler;
/**
 *  统一wk ui加载状态代理方法，二合一
 */
@property (nonatomic,copy) void(^startLoadBlock)(id webView);
@property (nonatomic,copy) void(^finishLoadBlock)(id webView);
@property (nonatomic,copy) void(^failLoadBlock)(id webView);

- (void)hideProgressView;

- (void)loadRequest:(NSString *)url;

- (void)scrollToTop;
/**
 *  方法内部判断是什么view
 *  在外部直接传入js即可
 */
- (void)evaluateJavaScript:(NSString *)javaScript;

- (void)addBridge;

- (BOOL)isUIWebView;
- (BOOL)isWKWebView;
@end
