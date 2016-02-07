//
//  MainViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/5.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "MainViewController.h"
#import "LPWebViewController.h"
#import "LPCoreAlgorithm.h"

@interface MainViewController ()

@property (nonatomic) NSDate *estimatedTime;
@property (strong, nonatomic) UIViewController *llHelperVC;

@property (weak, nonatomic) IBOutlet UITextField *currentLevelTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentLPTextField;
@property (weak, nonatomic) IBOutlet UILabel *maxLPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxEXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxJPEXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

- (IBAction)startCalculateButtonTouched:(id)sender;
- (IBAction)remindButtonTouched:(id)sender;
- (IBAction)llHelperButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;

@end

@implementation MainViewController

- (UIViewController *)llHelperVC {
    if (!_llHelperVC) {
        LPWebViewController *rootVC = [[LPWebViewController alloc] init];
        rootVC.requestURLString = @"http://llhelper.duapp.com/";
        rootVC.pageTitle = @"LLHelper";
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
        _llHelperVC = naviVC;
    }
    return _llHelperVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SIF LP助手";
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tgr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tgr];
    self.remindButton.hidden = YES;
    NSArray *plistPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistName = [[plistPath objectAtIndex:0] stringByAppendingPathComponent:@"LastNote.plist"];
    NSDictionary *noteDic = [NSDictionary dictionaryWithContentsOfFile:plistName];
    if (noteDic) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.estimatedTimeLabel.text = [formatter stringFromDate:[noteDic objectForKey:@"EstimatedTime"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.currentLevelTextField resignFirstResponder];
    [self.currentLPTextField resignFirstResponder];
}

- (IBAction)startCalculateButtonTouched:(id)sender {
    NSInteger level, lp, maxLP, maxEXP;
    if (![LPCoreAlgorithm isPureInt:self.currentLevelTextField.text] || (![LPCoreAlgorithm isPureInt:self.currentLPTextField.text] && [self.currentLPTextField.text integerValue])) {
        [self dataError];
    } else {
        level = [self.currentLevelTextField.text integerValue];
        lp = [self.currentLPTextField.text integerValue];
        maxLP = 25 + floor(MIN(level, 300) / 2) + floor(MAX(level - 300, 0) / 3);
        if (level <= 0) {
            [self dataError];
        } else {
            if (level > 33) {
                maxEXP = round([LPCoreAlgorithm expFunc:level] - [LPCoreAlgorithm expFunc:level - 33]);
            } else {
                maxEXP = round([LPCoreAlgorithm expFunc:level]);
            }
            self.maxLPLabel.text = [NSString stringWithFormat:@"%ld", (long)maxLP];
            self.maxEXPLabel.text = [NSString stringWithFormat:@"%ld", (long)maxEXP];
            if (level < 100) {
                self.maxJPEXPLabel.text = [NSString stringWithFormat:@"%ld(日服)", (long)maxEXP / 2];
            } else {
                self.maxJPEXPLabel.text = @"";
            }
            if (lp > maxLP || lp < 0) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"意味は分からない" message:@"LP填写错误" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [av show];
                self.remindButton.hidden = YES;
                self.estimatedTimeLabel.text = @"Error";
            } else {
                NSTimeInterval timeSinceNow = 360 * (maxLP - lp);
                self.estimatedTime = [NSDate dateWithTimeIntervalSinceNow:timeSinceNow];
                NSDateFormatter *formatter = [NSDateFormatter new];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                self.estimatedTimeLabel.text = [formatter stringFromDate:self.estimatedTime];
                self.remindButton.hidden = NO;
            }
        }
    }
    
}

- (void)dataError {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"意味は分からない" message:@"数据填写错误" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [av show];
    self.maxLPLabel.text = @"Error";
    self.maxEXPLabel.text = @"Error";
    self.maxJPEXPLabel.text = @"";
    self.estimatedTimeLabel.text = @"Error";
}

- (IBAction)remindButtonTouched:(id)sender {
    NSArray *plistPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistName = [[plistPath objectAtIndex:0] stringByAppendingPathComponent:@"LastNote.plist"];
    NSMutableDictionary *noteDic = [NSMutableDictionary dictionaryWithObject:self.estimatedTime forKey:@"EstimatedTime"];
    [noteDic writeToFile:plistName atomically:YES];
    [self registerLocalNotificationWithTime:self.estimatedTime];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"( · 8 · )" message:@"记住了，到时候会通知你的" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [av show];
}

- (IBAction)llHelperButtonTouched:(id)sender {
    [self presentViewController:self.llHelperVC animated:YES completion:nil];
}

- (IBAction)cancelButtonTouched:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"( · 8 · )" message:@"好吧，到时候不会打搅你啦" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [av show];
}

- (void)registerLocalNotificationWithTime:(NSDate *)estimatedTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = estimatedTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.alertBody = @"LP已经恢复完啦，快去肝活动吧！Fightだよ~";
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // Auth for iOS 8 or later version
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
