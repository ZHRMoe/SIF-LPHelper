//
//  BaseWebViewController.h
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/6.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebViewController : UIViewController

@property (copy, nonatomic) NSURL *requestURL;
@property (strong, nonatomic) UIWebView *webView;

@end
