//
//  TFJunYou_SelectLabelsVC.m
//  TFJunYouChat
//
//  Created by p on 2018/7/19.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_SelectLabelsVC.h"
#import "TFJunYou_LabelObject.h"
#import "QCheckBox.h"
#import "TFJunYou_SelectLabelGroupCell.h"
#define HEIGHT 60

@interface TFJunYou_SelectLabelsVC ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *checkBoxArr;

@end

@implementation TFJunYou_SelectLabelsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = Localized(@"JX_SelectionLabel");
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    self.isShowFooterPull = NO;
    self.isShowHeaderPull = NO;
    
    [self createHeadAndFoot];
    
    _array = [[TFJunYou_LabelObject sharedInstance] fetchAllLabelsFromLocal];
    for (TFJunYou_LabelObject *labelObj in _array) {
        NSString *userIdStr = labelObj.userIdList;
        NSArray *userIds = [userIdStr componentsSeparatedByString:@","];
        if (userIdStr.length <= 0) {
            userIds = nil;
        }
        
        NSMutableArray *newUserIds = [userIds mutableCopy];
        for (NSInteger i = 0; i < userIds.count; i ++) {
            NSString *userId = userIds[i];
            NSString *userName = [TFJunYou_UserObject getUserNameWithUserId:userId];
            
            if (!userName || userName.length <= 0) {
                [newUserIds removeObject:userId];
            }
            
        }
        
        NSString *string = [newUserIds componentsJoinedByString:@","];
        
        labelObj.userIdList = string;
        
        [labelObj update];
    }
    _checkBoxArr = [NSMutableArray array];
    
    UIButton *allSelect = [UIButton buttonWithType:UIButtonTypeSystem];
    [allSelect setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
    [allSelect setTitleColor:THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    allSelect.tintColor = [UIColor clearColor];
    allSelect.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 70, TFJunYou__SCREEN_TOP - 34, 60, 24);
    [allSelect addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:allSelect];

}

- (void)confirmBtnAction:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(selectLabelsVC:selectLabelsArray:)]) {
        [self.delegate selectLabelsVC:self selectLabelsArray:_selLabels];
    }
    [self actionQuit];
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    TFJunYou_LabelObject *labelObj = _array[checkbox.tag];
    
    if(checked){

        [_selLabels addObject:labelObj];
    }
    else{
        NSInteger index = -1;
        for (NSInteger i = 0; i < _selLabels.count; i ++) {
            TFJunYou_LabelObject *selLabel = _selLabels[i];
            if ([selLabel.groupId isEqualToString:labelObj.groupId]) {
                index = i;
                break;
            }
        }
        if (index >= 0) {
            [_selLabels removeObjectAtIndex:index];
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFJunYou_LabelObject *label = _array[indexPath.row];
    NSString *userIdStr = label.userIdList;
    NSArray *userIds = [userIdStr componentsSeparatedByString:@","];
    if (userIdStr.length <= 0) {
        userIds = nil;
    }
    
    NSMutableString *userNameStr = [NSMutableString string];
    for (NSInteger i = 0; i < userIds.count; i ++) {
        NSString *userId = userIds[i];
        NSString *userName = [TFJunYou_UserObject getUserNameWithUserId:userId];
        if (i == 0) {
            [userNameStr appendFormat:@"%@", userName];
        }else {
            [userNameStr appendFormat:@", %@", userName];
        }
        
    }
    
    TFJunYou_SelectLabelGroupCell *cell=nil;
    NSString* cellName = @"labelCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell==nil){
        
        cell = [[TFJunYou_SelectLabelGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        [_table addToPool:cell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",label.groupName, userIds.count];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    cell.detailTextLabel.text = userNameStr;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font= [UIFont systemFontOfSize:15.0];
    
    BOOL flag = NO;
    for (NSInteger i = 0; i < _selLabels.count; i ++) {
        TFJunYou_LabelObject *selLabelObj = _selLabels[i];
        if ([selLabelObj.groupId isEqualToString:label.groupId]) {
            flag = YES;
            break;
        }
    }
    
    QCheckBox* btn = [[QCheckBox alloc] initWithDelegate:self];
    btn.tag = indexPath.row;
    btn.frame = CGRectMake(15, 17, 25, 25);
    btn.selected = flag;
    [cell addSubview:btn];
    [_checkBoxArr addObject:btn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - LINE_WH, TFJunYou__SCREEN_WIDTH, LINE_WH)];
    view.backgroundColor = THE_LINE_COLOR;
    [cell addSubview:view];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QCheckBox *checkBox = nil;
    for (NSInteger i = 0; i < _checkBoxArr.count; i ++) {
        QCheckBox *btn = _checkBoxArr[i];
        if (btn.tag == indexPath.row) {
            checkBox = btn;
            break;
        }
    }
    checkBox.selected = !checkBox.selected;
    [self didSelectedCheckBox:checkBox checked:checkBox.selected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
