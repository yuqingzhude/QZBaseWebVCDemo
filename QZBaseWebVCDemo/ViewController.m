//
//  ViewController.m
//  QZBaseWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import "ViewController.h"
#import "WebViewVC.h"
#import "QZBaseWebVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.view.frame];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
}

- (void)go
{
    QZBaseWebVC *vc = [[QZBaseWebVC alloc] init];
    vc.url = @"http://www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
