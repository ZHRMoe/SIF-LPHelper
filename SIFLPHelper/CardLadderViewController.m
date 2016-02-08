//
//  CardLadderViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/9.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "CardLadderViewController.h"

@interface CardLadderViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITableView *cardTableView;

@property (nonatomic, copy) NSDictionary *cardDic;
@property (nonatomic, copy) NSArray *characterArr;
@property (nonatomic, copy) NSArray *attributeArr;
@property (nonatomic, copy) NSArray *gradingArr;

@property (nonatomic, copy) NSString *selectedCharacter;
@property (nonatomic, copy) NSString *selectedAttribute;
@property (nonatomic, copy) NSString *selectedGrading;

@end

@implementation CardLadderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cardJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    self.cardDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    self.selectedCharacter = @"高坂穗乃果";
    self.selectedAttribute = @"smile";
    self.selectedGrading = @"SS";
    
    self.characterArr = @[@"高坂穗乃果", @"绚濑绘里", @"南小鸟", @"园田海未", @"星空凛", @"西木野真姬", @"东条希", @"小泉花阳", @"矢泽妮可"];
    self.attributeArr = @[@"smile", @"pure", @"cool"];
    self.gradingArr = @[@"SS", @"S+", @"S", @"A+", @"A", @"A-", @"B+", @"B", @"B-", @"C+", @"C", @"C-", @"D+", @"D"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 50)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];
    
    self.cardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, self.view.frame.size.width, self.view.frame.size.height - 115)];
    self.cardTableView.delegate = self;
    self.cardTableView.dataSource = self;
    [self.view addSubview:self.cardTableView];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ごめんなさい"
                                                 message:@"卡片天梯功能正在测试中"
                                                delegate:nil
                                       cancelButtonTitle:@"好"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//PickerView data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 9;
    } else if (component == 1) {
        return 3;
    } else {
        return 14;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return  self.view.frame.size.width/3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3, 20)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        textLabel.text = self.characterArr[row];
    } else if (component == 1) {
        textLabel.text = self.attributeArr[row];
    } else {
        textLabel.text = self.gradingArr[row];
    }
    [view addSubview:textLabel];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedCharacter = self.characterArr[row];
    } else if (component == 1) {
        self.selectedAttribute = self.attributeArr[row];
    } else {
        self.selectedGrading = self.gradingArr[row];
    }
    [self.cardTableView reloadData];
}

//TablevView data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"card";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"角色：%@ 属性：%@ 等级：%@", self.selectedCharacter, self.selectedAttribute, self.selectedGrading];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
