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
    [self makeSubview];
    [self setStartLoadBlock:^(id webView) {
        NSLog(@"block success");
    }];
    [self setFinishLoadBlock:^(id webView) {
        NSLog(@"block finish");
    }];
    
}

- (void)makeSubview
{
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

- (void)addBridge
{
    self.handler = ^(id data, WVJBResponseCallback responseCallback){
        
    };
    [super addBridge];
}
- (void)gotop
{
    [self scrollToTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
