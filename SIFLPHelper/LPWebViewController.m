//
//  LPWebViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/6.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "LPWebViewController.h"
#import "BaseWebViewController.h"
#import "LPNetworkCenter.h"

@interface LPWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) BaseWebViewController *baseWebVC;
@property (weak, nonatomic) NSString *currentURLString;

@end

@implementation LPWebViewController

- (BaseWebViewController *)baseWebVC {
    if (!_baseWebVC) {
        _baseWebVC = [[BaseWebViewController alloc] init];
        NSString *URLString = self.requestURLString;
        _baseWebVC.requestURL = [NSURL URLWithString:URLString];
        _baseWebVC.webView.delegate = self;
    }
    return _baseWebVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentURLString = @"";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = self.pageTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_baseWebVC) {
        __weak UIViewController *sourceViewController = self;
        __weak UIViewController *destinationViewController = self.baseWebVC;
        destinationViewController.view.frame = sourceViewController.view.bounds;
        [destinationViewController willMoveToParentViewController:sourceViewController];
        [sourceViewController.view addSubview:destinationViewController.view];
        [sourceViewController addChildViewController:destinationViewController];
        [destinationViewController didMoveToParentViewController:sourceViewController];
    }
}

- (void)back:(id)sender {
    if (self.baseWebVC.webView.canGoBack) {
        [self.baseWebVC.webView goBack];
    } else {
        _baseWebVC = nil;
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isBeingPresentedModally {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController)
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [LPNetworkCenter add];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [LPNetworkCenter del];
}

@end
