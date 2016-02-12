//
//  CardCheckViewController.h
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/9.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define avatarImage 1
#define characterLabel 2
#define smileLabel 3
#define pureLabel 4
#define coolLabel 5
#define skillLabel 6

@interface CardCheckViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableViewCell *cardCell;

@end
