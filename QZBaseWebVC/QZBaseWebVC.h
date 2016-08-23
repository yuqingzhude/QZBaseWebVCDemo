//
//  QZBaseWKWebVC.h
//  QZBaseWKWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import <WebKit/WebKit.h>

/**
 *  系统大于ios8 使用wkwebView加载页面
 *             否则使用uiwebView加载页面
 */

@interface QZBaseWebVC : UIViewController
/** 子类类型转换*/
@property (nonatomic,weak) id webView;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) NJKWebViewProgressView *progressView;

@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

- (void)hideProgressView;

- (void)loadRequest:(NSString *)url;

- (void)scrollToTop;

- (void)evaluateJavaScript:(NSString *)javaScript;

@end
