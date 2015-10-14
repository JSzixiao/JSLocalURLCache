//
//  ViewController.m
//  JSLocalURLCacheDemo
//
//  Created by jason on 15/9/29.
//  Copyright © 2015年 jason. All rights reserved.
//

#import "ViewController.h"

#import "JSLocalURLCache.h"

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self refreshFunction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  清理缓存
 *
 *  @param sender
 */
- (IBAction)clearCacheFunction:(id)sender
{
    NSLog(@"清空缓存");
    
    [[JSLocalURLCache sharedURLCache] removeAllCachedResponses];
}

/**
 *  显示缓存大小
 *
 *  @param sender
 */
- (IBAction)showCacheSizeFunction:(id)sender
{
    UIButton *tmpButton = (UIButton *)sender;
    [tmpButton setTitle:[JSLocalURLCache getCachedResponsesSizeToShow] forState:UIControlStateNormal];
}


- (NSURLRequest *)getCurrentRequest
{
    NSString *tmpUrlString = @"http://www.baidu.com";
    NSURL * url = [NSURL URLWithString:tmpUrlString];
    return [NSMutableURLRequest requestWithURL:url];
}

/**
 *  刷新方法
 *
 *  @param sender
 */
- (IBAction)refreshFunction:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"开始加载");
    
    NSURLRequest *urlRequest = [self getCurrentRequest];
    
    [self.webView loadRequest:urlRequest];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"加载完毕");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"加载失败");
}

@end
