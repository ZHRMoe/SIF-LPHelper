//
//  CardCheckViewController.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/9.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "CardCheckViewController.h"
#import "UIKit+AFNetworking.h"

@interface CardCheckViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITableView *cardTableView;

@property (nonatomic, copy) NSDictionary *cardDic;
@property (nonatomic, copy) NSMutableArray *selectedCards;
@property (nonatomic, copy) NSArray *characterArr;
@property (nonatomic, copy) NSArray *jpcharacterArr;
@property (nonatomic, copy) NSArray *attributeArr;
@property (nonatomic, copy) NSArray *gradingArr;

@property (nonatomic) NSInteger selectedCharacter;
@property (nonatomic) NSInteger selectedAttribute;
@property (nonatomic) NSInteger selectedGrading;

@end

@implementation CardCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cardJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    self.cardDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    self.selectedCharacter = 0;
    self.selectedAttribute = 0;
    self.selectedGrading = 0;
    
    self.characterArr = @[@"高坂穗乃果", @"绚濑绘里", @"南小鸟", @"园田海未", @"星空凛", @"西木野真姬", @"东条希", @"小泉花阳", @"矢泽妮可"];
    self.jpcharacterArr = @[@"高坂穂乃果", @"絢瀬絵里", @"南ことり", @"園田海未", @"星空凛", @"西木野真姫", @"東條希", @"小泉花陽", @"矢澤にこ"];
    self.attributeArr = @[@"smile", @"pure", @"cool"];
    self.gradingArr = @[@"", @"SS", @"S+", @"S", @"A+", @"A", @"A-", @"B+", @"B", @"B-", @"C+", @"C", @"C-", @"D+", @"D"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 50)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];
    
    
    self.cardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height - 105)];
    self.cardTableView.delegate = self;
    self.cardTableView.dataSource = self;
    [self.view addSubview:self.cardTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)searchCards {
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (int i = 1; i <= self.cardDic.count; ++i) {
        NSDictionary *cardInfo = [self.cardDic valueForKey:[NSString stringWithFormat:@"%d", i]];
        if (([[cardInfo valueForKey:@"name"] isEqualToString:self.characterArr[self.selectedCharacter]] || [[cardInfo valueForKey:@"name"] isEqualToString:self.jpcharacterArr[self.selectedCharacter]]) && [[cardInfo valueForKey:@"attribute"] isEqualToString:self.attributeArr[self.selectedAttribute]]) {
            [selectedArr addObject:[NSNumber numberWithInt:i]];
        }
    }
    return selectedArr;
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
        return 15;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return  self.view.frame.size.width / 3;
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
        self.selectedCharacter = row;
    } else if (component == 1) {
        self.selectedAttribute = row;
    } else {
        self.selectedGrading = row;
    }
    [self.cardTableView reloadData];
}

//TablevView data source and delegate

- (UITableViewCell *)customCellByXib:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardCell" owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.cardCell;
        }
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[self.cardDic valueForKey:[NSString stringWithFormat:@"%@", self.selectedCards[indexPath.row]]] valueForKey:@"avatarpluspath"]]];
    [((UIImageView *)[cell.contentView viewWithTag:avatarImage]) setImageWithURLRequest:request
                                                                       placeholderImage:nil
                                                                                success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                        ((UIImageView *)[cell.contentView viewWithTag:avatarImage]).image = image;
                                                                                }
                                                                                failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                                                    NSLog(@"%@", error);
                                                                                }];
    NSString *cardName = [[self.cardDic valueForKey:[NSString stringWithFormat:@"%@", self.selectedCards[indexPath.row]]] valueForKey:@"eponym"];
    NSArray *series = [[self.cardDic valueForKey:[NSString stringWithFormat:@"%@", self.selectedCards[indexPath.row]]] valueForKey:@"series"];
    NSString *cardSeries;
    if ([series isKindOfClass:[NSArray class]]) {
        cardSeries = series.firstObject;
    } else if ([series isKindOfClass:[NSString class]]) {
        cardSeries = (NSString *)series;
    }
    if (![cardName isKindOfClass:[NSNull class]]) {
        ((UILabel *)[cell.contentView viewWithTag:characterLabel]).text = [NSString stringWithFormat:@"%@ %@", self.characterArr[self.selectedCharacter], cardName];
    } else if (cardSeries){
        ((UILabel *)[cell.contentView viewWithTag:characterLabel]).text = [NSString stringWithFormat:@"%@ %@", self.characterArr[self.selectedCharacter], cardSeries];
    } else {
        ((UILabel *)[cell.contentView viewWithTag:characterLabel]).text = [NSString stringWithFormat:@"%@", self.characterArr[self.selectedCharacter]];
    }
    
    ((UILabel *)[cell.contentView viewWithTag:smileLabel]).text = [NSString stringWithFormat:@"%@", [[self.cardDic valueForKey:[NSString stringWithFormat:@"%@", self.selectedCards[indexPath.row]]] valueForKey:@"smile2"]];
    ((UILabel *)[cell.contentView viewWithTag:pureLabel]).text = [NSString stringWithFormat:@"%@", [[self.cardDic valueForKey:[NSString stringWithFormat:@"%@", self.selectedCards[indexPath.row]]] valueForKey:@"pure2"]];
    ((UILabel *)[cell.contentView viewWithTag:coolLabel]).text = [NSString stringWithFormat:@"%@", [[self.cardDic valueForKey:[NSString stringWithFormat:@"%@", self.selectedCards[indexPath.row]]] valueForKey:@"cool2"]];
    ((UILabel *)[cell.contentView viewWithTag:strengthLabel]).text = @"";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self customCellByXib:tableView withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.selectedCards = [self searchCards];
    return self.selectedCards.count;
}

@end
