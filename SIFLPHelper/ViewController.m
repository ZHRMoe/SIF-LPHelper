//
//  ViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/5.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSDate *estimatedTime;

@property (weak, nonatomic) IBOutlet UITextField *currentLevelTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentLPTextField;
@property (weak, nonatomic) IBOutlet UILabel *maxLPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxEXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxJPEXPLabel;
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
    if (level <= 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"意味は分からない" message:@"等级填写错误" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
        self.maxLPLabel.text = @"Error";
        self.maxEXPLabel.text = @"Error";
        self.estimatedTimeLabel.text = @"Error";
    } else {
        if (level > 33) {
            maxExp = round([self expFunc:level] - [self expFunc:level - 33]);
        } else {
            maxExp = round([self expFunc:level]);
        }
        self.maxLPLabel.text = [NSString stringWithFormat:@"%ld", (long)maxLP];
        self.maxEXPLabel.text = [NSString stringWithFormat:@"%ld", (long)maxExp];
        if (level < 100) {
            self.maxJPEXPLabel.text = [NSString stringWithFormat:@"%ld(日服)", (long)maxExp / 2];
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

- (IBAction)remindButtonTouched:(id)sender {
    NSArray *plistPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistName = [[plistPath objectAtIndex:0] stringByAppendingPathComponent:@"LastNote.plist"];
    NSMutableDictionary *noteDic = [NSMutableDictionary dictionaryWithObject:self.estimatedTime forKey:@"EstimatedTime"];
    [noteDic writeToFile:plistName atomically:YES];
    [self registerLocalNotificationWithTime:self.estimatedTime];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"( · 8 · )" message:@"记住了，到时候会通知你的" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [av show];
}

- (void)registerLocalNotificationWithTime:(NSDate *)estimatedTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = estimatedTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.alertBody = @"LP已经恢复完啦，快去肝活动吧！Fightだよ~";
    notification.applicationIconBadgeNumber += 1;
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
