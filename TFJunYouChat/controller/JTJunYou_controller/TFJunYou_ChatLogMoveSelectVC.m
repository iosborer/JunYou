//
//  TFJunYou_ChatLogMoveSelectVC.m
//  TFJunYouChat
//
//  Created by p on 2019/6/5.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_ChatLogMoveSelectVC.h"
#import "TFJunYou_Cell.h"
#import "QCheckBox.h"
#import "TFJunYou_ChatLogQRCodeVC.h"

@interface TFJunYou_ChatLogMoveSelectVC ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSSet * existSet;
@property (nonatomic, strong) NSMutableArray *selUserIdArray;
@property (nonatomic, strong) NSMutableArray *selUserNameArray;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *checkBoxArr;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TFJunYou_ChatLogMoveSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = TFJunYou__SCREEN_BOTTOM;
    self.isGotoBack   = YES;
    //self.view.frame = g_window.bounds;
    self.isShowFooterPull = NO;
    [self createHeadAndFoot];
    
    _array = [NSMutableArray array];
    _selUserIdArray = [NSMutableArray array];
    _selUserNameArray = [NSMutableArray array];
    _checkBoxArr = [NSMutableArray array];
    self.title = Localized(@"JX_ChooseAChat");
    
    UIButton *allSelect = [UIButton buttonWithType:UIButtonTypeSystem];
    [allSelect setTitle:Localized(@"JX_CheckAll") forState:UIControlStateNormal];
    [allSelect setTitle:Localized(@"JX_Cencal") forState:UIControlStateSelected];
    [allSelect setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [allSelect setTitleColor:THEMECOLOR forState:UIControlStateSelected];
    allSelect.tintColor = [UIColor clearColor];
    allSelect.titleLabel.font = [UIFont systemFontOfSize:14.0];
    allSelect.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-27-15, TFJunYou__SCREEN_TOP-15-14, 30, 14);
    [allSelect addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:allSelect];
    
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 14)];
    self.countLabel.textColor = THEMECOLOR;
    self.countLabel.font = SYSFONT(14);
    self.countLabel.text = @"迁移数量(0)";
    [self.tableFooter addSubview:self.countLabel];

    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 60-15, 9, 60, 27)];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.nextBtn.backgroundColor = THEMECOLOR;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 2.f;
    [self.nextBtn setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFooter addSubview:self.nextBtn];
    
    
    [self getArrayData];
    
}
- (void)allSelect:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    [_selUserIdArray removeAllObjects];
    [_selUserNameArray removeAllObjects];
    if (btn.selected) {
        for (TFJunYou_MsgAndUserObject *userObj in _array) {
            [_selUserIdArray addObject:userObj.user.userId];
            [_selUserNameArray addObject:userObj.user.userNickname];
        }
    }
    
    [_checkBoxArr removeAllObjects];
    [self showCountLabelText];
    [self.tableView reloadData];
}

- (void)nextBtnAction:(UIButton *)btn {
    
    if (!_selUserIdArray.count) {
        [g_App showAlert:Localized(@"JX_SelectGroupUsers")];
        return;
    }
    
    TFJunYou_ChatLogQRCodeVC *vc = [[TFJunYou_ChatLogQRCodeVC alloc] init];
    vc.selUserIdArray = [_selUserIdArray copy];
    [g_navigation pushViewController:vc animated:YES];
    
    [self actionQuit];
}
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    TFJunYou_MsgAndUserObject *userObj = _array[checkbox.tag % 10000];
    
    if(checked){
        BOOL flag = NO;
        for (NSInteger i = 0; i < _selUserIdArray.count; i ++) {
            NSString *selUserId = _selUserIdArray[i];
            if ([selUserId isEqualToString:userObj.user.userId]) {
                flag = YES;
                return;
            }
        }
        [_selUserIdArray addObject:userObj.user.userId];
        [_selUserNameArray addObject:userObj.user.userNickname];
    }
    else{
        [_selUserIdArray removeObject:userObj.user.userId];
        [_selUserNameArray removeObject:userObj.user.userNickname];
    }
    [self showCountLabelText];
}

-(void)getArrayData{
    _array=[[TFJunYou_MessageObject sharedInstance] fetchRecentChat];
    
}

#pragma mark   ---------tableView协议----------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    TFJunYou_Cell *cell=nil;
    NSString* cellName = [NSString stringWithFormat:@"selVC_%d",(int)indexPath.row];
    //    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    //    QCheckBox* btn;
    //    if (!cell) {
    cell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QCheckBox* btn = [[QCheckBox alloc] initWithDelegate:self];
    btn.frame = CGRectMake(13, 18.5, 22, 22);
    [cell addSubview:btn];
    //    }
    
    TFJunYou_MsgAndUserObject *userObj=_array[indexPath.row];
    
    btn.tag = indexPath.section * 10000 + indexPath.row;
    BOOL flag = NO;
    for (NSInteger i = 0; i < _selUserIdArray.count; i ++) {
        NSString *selUserId = _selUserIdArray [i];
        if ([userObj.user.userId isEqualToString:selUserId]) {
            flag = YES;
            break;
        }
    }
    btn.checked = flag;
    
    [_checkBoxArr addObject:btn];
    //            cell = [[TFJunYou_Cell alloc] init];
    [_table addToPool:cell];
    cell.title = userObj.user.userNickname;
    //            cell.subtitle = user.userId;
    cell.bottomTitle = [TimeUtil formatDate:userObj.user.timeCreate format:@"MM-dd HH:mm"];
    cell.userId = userObj.user.userId;
    cell.isSmall = YES;
    [cell headImageViewImageWithUserId:nil roomId:nil];
    
    CGFloat headX = 13*2+22;
    
    cell.headImageView.frame = CGRectMake(headX,9.5,40,40);
    cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
    cell.lbTitle.frame = CGRectMake(CGRectGetMaxX(cell.headImageView.frame)+15, 21.5, TFJunYou__SCREEN_WIDTH - 115 -CGRectGetMaxX(cell.headImageView.frame)-14, 16);
    cell.lbSubTitle.frame = CGRectMake(CGRectGetMaxX(cell.headImageView.frame)+15, cell.lbSubTitle.frame.origin.y, TFJunYou__SCREEN_WIDTH - 55 -CGRectGetMaxX(cell.headImageView.frame)-14, cell.lbSubTitle.frame.size.height);
    cell.lineView.frame = CGRectMake(CGRectGetMaxX(cell.headImageView.frame)+15,59-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH);
    
    
//    cell.headImageView.frame = CGRectMake(cell.headImageView.frame.origin.x + 50, cell.headImageView.frame.origin.y, cell.headImageView.frame.size.width, cell.headImageView.frame.size.height);
//    cell.lbTitle.frame = CGRectMake(cell.lbTitle.frame.origin.x + 50, cell.lbTitle.frame.origin.y, cell.lbTitle.frame.size.width, cell.lbTitle.frame.size.height);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCheckBox *checkBox = nil;
    for (NSInteger i = 0; i < _checkBoxArr.count; i ++) {
        QCheckBox *btn = _checkBoxArr[i];
        if (btn.tag / 10000 == indexPath.section && btn.tag % 10000 == indexPath.row) {
            checkBox = btn;
            break;
        }
    }
    checkBox.selected = !checkBox.selected;
    [self didSelectedCheckBox:checkBox checked:checkBox.selected];
    [self showCountLabelText];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}


- (void)showCountLabelText {
    self.countLabel.text = [NSString stringWithFormat:@"迁移数量(%ld)",_selUserIdArray.count];
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
