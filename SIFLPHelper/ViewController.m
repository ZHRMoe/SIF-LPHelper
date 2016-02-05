//
//  ViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/5.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSTimeInterval timeSinceNow;

@property (weak, nonatomic) IBOutlet UITextField *currentLevelTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentLPTextField;
@property (weak, nonatomic) IBOutlet UILabel *maxLPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxEXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

- (IBAction)startCalculateButtonTouched:(id)sender;
- (IBAction)remindButtonTouched:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SIF LP助手";
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tgr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tgr];
    self.remindButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (double)expFunc:(NSInteger)level {
    return 0.522 * level * level + 0.522 * level + 10.0005;
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.currentLevelTextField resignFirstResponder];
    [self.currentLPTextField resignFirstResponder];
}

- (IBAction)startCalculateButtonTouched:(id)sender {
    NSInteger level = [self.currentLevelTextField.text integerValue];
    NSInteger lp = [self.currentLPTextField.text integerValue];
    NSInteger maxLP = 25 + floor(MIN(level, 300) / 2) + floor(MAX(level - 300, 0) / 3);
    NSInteger maxExp = 0;
    if (level > 33) {
        maxExp = round([self expFunc:level] - [self expFunc:level - 33]);
    } else {
        maxExp = round([self expFunc:level]);
    }
    self.maxLPLabel.text = [NSString stringWithFormat:@"%ld", (long)maxLP];
    self.maxEXPLabel.text = [NSString stringWithFormat:@"%ld", (long)maxExp];
    if (lp > maxLP) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"意味は分からない" message:@"填写的LP大于当前等级的LP上限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [av show];
        self.remindButton.hidden = YES;
        self.estimatedTimeLabel.text = @"LP填写错误";
    } else {
//        self.timeSinceNow = 360 * (maxLP - lp);
        self.timeSinceNow = 10;
        NSDate *estimatedTime = [NSDate dateWithTimeIntervalSinceNow:self.timeSinceNow];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.estimatedTimeLabel.text = [formatter stringFromDate:estimatedTime];
        self.remindButton.hidden = NO;
    }
}

- (IBAction)remindButtonTouched:(id)sender {
    [self registerLocalNotificationWithTime:self.timeSinceNow];
}

- (void)registerLocalNotificationWithTime:(NSTimeInterval)timeInterval {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = kCFCalendarUnitSecond;
    notification.alertBody = @"LP已经恢复完啦，快去肝活动吧！";
    notification.applicationIconBadgeNumber += 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // Auth for iOS 8 or later version
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    notification.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
