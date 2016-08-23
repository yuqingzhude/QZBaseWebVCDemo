//
//  WebViewVC.m
//  QZBaseWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import "WebViewVC.h"
//#import <WebKit/WebKit.h>

@interface WebViewVC ()

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn1 = [[UIButton alloc] init];
    btn1.frame = CGRectMake(self.view.bounds.size.width - 80, self.view.bounds.size.height - 80, 50, 50);
    [btn1 setTitle:@"top" forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 25;
    btn1.clipsToBounds = YES;
    [self.view addSubview:btn1];
    [self.view bringSubviewToFront:btn1];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(gotop) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotop
{
    [self scrollToTop];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigatio
{
    WKWebView *wk = [[WKWebView alloc] init];
    wk = self.webView;
    self.title = wk.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
