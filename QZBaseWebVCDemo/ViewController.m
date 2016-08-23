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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    btn.center = self.view.center;
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 100;
    [btn setTitle:@"go" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:50];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
}

- (void)go
{
    WebViewVC *vc = [[WebViewVC alloc] init];
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
