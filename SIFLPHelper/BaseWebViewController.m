//
//  BaseWebViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/6.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()

@property (nonatomic) BOOL loaded;

@end

@implementation BaseWebViewController

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loaded = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.loaded) {
        self.webView.frame = self.view.bounds;
        [self.view addSubview:self.webView];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_requestURL
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:20];
        [self.webView loadRequest:req];
        self.loaded = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
