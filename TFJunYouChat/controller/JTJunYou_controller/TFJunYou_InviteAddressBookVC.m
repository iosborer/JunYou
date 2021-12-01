//
//  TFJunYou_InviteAddressBookVC.m
//  TFJunYouChat
//
//  Created by p on 2019/3/30.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_InviteAddressBookVC.h"
#import "QCheckBox.h"
#import "BMChineseSort.h"
#import "TFJunYou_AddressBookCell.h"
#import <MessageUI/MessageUI.h>


@interface TFJunYou_InviteAddressBookVC ()<TFJunYou_AddressBookCellDelegate, QCheckBoxDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic,strong)NSMutableArray *array;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong)NSMutableArray *abUreadArr;


@property (nonatomic, assign) BOOL isShowSelect;
@property (nonatomic, assign) BOOL isAllSelect; // YES:全选  // NO:全不选
@property (nonatomic, strong) NSMutableArray *selectABs;
@property (nonatomic, strong) UIView *doneBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSDictionary *phoneNumDict;
@property (nonatomic, strong) NSMutableArray *headerCheckBoxs;
@property (nonatomic, strong) NSMutableArray *allAbArr;

@property (nonatomic, strong) TFJunYou_UserObject *addressBookUser;

@end

@implementation TFJunYou_InviteAddressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    //self.view.frame = g_window.bounds;
    self.isShowFooterPull = NO;
    
    [self createHeadAndFoot];
    
    _phoneNumDict = [[TFJunYou_AddressBook sharedInstance] getMyAddressBook];
    _headerCheckBoxs = [NSMutableArray array];
    
    self.title = Localized(@"JX_MobilePhoneContacts");
    
    _array = [NSMutableArray array];
    _indexArray = [NSMutableArray array];
    _letterResultArr = [NSMutableArray array];
    _selectABs = [NSMutableArray array];
    _allAbArr = [NSMutableArray array];
    
    self.isShowSelect = NO;
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_selectBtn setTitle:Localized(@"JX_BatchInvite") forState:UIControlStateNormal];
    [_selectBtn setTitleColor:THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    _selectBtn.tintColor = [UIColor clearColor];
    _selectBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 62-15, TFJunYou__SCREEN_TOP - 30, 62, 15);
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:_selectBtn];
    
    _doneBtn = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - TFJunYou__SCREEN_BOTTOM, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_BOTTOM)];
    _doneBtn.backgroundColor = HEXCOLOR(0xf0f0f0);
    _doneBtn.hidden = YES;
    [self.view addSubview:_doneBtn];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_BOTTOM/2-49/2, TFJunYou__SCREEN_WIDTH, 49)];
    [btn setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x55BEB8) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = HEXCOLOR(0xf0f0f0);
    [_doneBtn addSubview:btn];
    
    [self getServerData];
    
    [self createTableHeadView];
}

- (void)createTableHeadView {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 65)];
    [btn addTarget:self action:@selector(shareFriend) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = btn;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 23, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ic_cs"];
    [btn addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, 200, btn.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%@%@",Localized(@"JX_small_share"),APP_NAME];
    [btn addSubview:label];
}

- (void)shareFriend {
    NSString *testToShare = APP_NAME;
    
//    UIImage *imageToShare = [UIImage imageNamed:@"client"];

    NSURL *urlToShare = [NSURL URLWithString:g_config.website];

    NSArray *activityItems = @[testToShare,urlToShare];
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityVc animated:YES completion:nil];
    
    activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
    
        if (completed) {
        
            NSLog(@"分享成功");
        
        }else{
            
            NSLog(@"分享取消");
            
        }
    
    };
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    [self addressBookCell:nil checkBoxSelectIndexNum:checkbox.tag isSelect:checked];
}

- (void)selectBtnAction:(UIButton *)btn {
    
    self.isShowSelect = YES;
    
    if (self.doneBtn.hidden == YES) {
        self.doneBtn.hidden = NO;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - TFJunYou__SCREEN_BOTTOM);
        [self.gotoBackBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.gotoBackBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
        [btn setTitle:Localized(@"JX_CheckAll") forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    }else {
        self.isAllSelect = !self.isAllSelect;
        if (self.isAllSelect) {
            for (int i = 0 ; i < self.letterResultArr.count; i++) {
                NSArray *arr = [self.letterResultArr objectAtIndex:i];
                if (arr.count > 1) {
                    for (TFJunYou_AddressBook *ad in arr) {
                        [_selectABs addObject:ad];
                    }
                }else {
                    [_selectABs addObject:[arr firstObject]];
                }
            }
        }else {
            [_selectABs removeAllObjects];
        }
    }
    [self.tableView reloadData];

}

- (void)actionQuit {
    if (self.isShowSelect) {
        self.isShowSelect = NO;
        self.isAllSelect = NO;
        [_selectABs removeAllObjects];
        _selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_selectBtn setTitle:Localized(@"JX_BatchInvite") forState:UIControlStateNormal];
        [self.gotoBackBtn setTitle:nil forState:UIControlStateNormal];
        [self.gotoBackBtn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
        [_selectABs removeAllObjects];
        self.doneBtn.hidden = YES;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self_height-self.heightHeader-self.heightFooter);
        [self.tableView reloadData];
        return;
    }
    
    [super actionQuit];
}

- (void)doneBtnAction:(UIButton *)btn {
    if (_selectABs.count <= 0) {
        [g_App showAlert:Localized(@"JX_PleaseSelectContacts")];
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < _selectABs.count; i ++) {
        TFJunYou_AddressBook *ab = _selectABs[i];
        
        [arr addObject:ab.toTelephone];
    }
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc]init];
    //设置短信内容
    vc.body = [NSString stringWithFormat:@"嗨，我正在使用%@。快来和我一起试试吧~ 下载地址：\n%@",APP_NAME,g_config.website];
    //设置收件人列表
    vc.recipients = arr;
    //设置代理
    vc.messageComposeDelegate = self;
    //显示控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)getServerData {
    [_array removeAllObjects];
    [_allAbArr removeAllObjects];
    NSMutableArray *arr = [[TFJunYou_AddressBook sharedInstance] fetchAllAddressBook];
    
    for (NSString *key in _phoneNumDict.allKeys) {
        BOOL flag = NO;
        for (TFJunYou_AddressBook *obj in arr) {
            if ([obj.toTelephone isEqualToString:key]) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            TFJunYou_AddressBook *ab = [[TFJunYou_AddressBook alloc] init];
            ab.toTelephone = key;
            ab.addressBookName = _phoneNumDict[key];
            [_array addObject:ab];
        }
    }

    //选择拼音 转换的 方法
    BMChineseSortSetting.share.sortMode = 2; // 1或2
    //排序 Person对象
    [BMChineseSort sortAndGroup:_array key:@"addressBookName" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (isSuccess) {
            self.indexArray = sectionTitleArr;
            self.letterResultArr = sortedObjArr;
            [_table reloadData];
        }
    }];
    
    //    //根据Person对象的 name 属性 按中文 对 Person数组 排序
    //    self.indexArray = [BMChineseSort IndexWithArray:_array Key:@"addressBookName"];
    //    self.letterResultArr = [BMChineseSort sortObjectArray:_array Key:@"addressBookName"];
}
#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.indexArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.indexArray objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = HEXCOLOR(0xF2F2F2);
    [header.textLabel setTextColor:HEXCOLOR(0x999999)];
    [header.textLabel setFont:SYSFONT(15)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[self.letterResultArr objectAtIndex:section] count];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.indexArray;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"TFJunYou_AddressBookCell";
    TFJunYou_AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    TFJunYou_AddressBook *addressBook = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[TFJunYou_AddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.isInvite = YES;
    cell.delegate = self;
    cell.index = indexPath.section * 1000 + indexPath.row;
    if (self.isAllSelect) {
        cell.isShowSelect = YES;
        cell.checkBox.selected = YES;
    }else {
        cell.isShowSelect = self.isShowSelect;
        if ([_selectABs containsObject:addressBook]) {
            cell.checkBox.selected = YES;
        }else {
            cell.checkBox.selected = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressBook = addressBook;
    cell.headImage.userInteractionEnabled = NO;
    
    if (indexPath.row == [(NSArray *)[self.letterResultArr objectAtIndex:indexPath.section] count]-1) {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width,0);
    }else {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width,LINE_WH);
    }

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_AddressBookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.isShowSelect) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:cell.addressBook.toUserId];
        if ([user.status intValue] != 2) {
            cell.checkBox.selected = !cell.checkBox.selected;
            [self addressBookCell:cell checkBoxSelectIndexNum:cell.index isSelect:cell.checkBox.selected];
        }
    }else {
//        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
//        vc.userId       = cell.addressBook.toUserId;
//        vc = [vc init];
//        [g_navigation pushViewController:vc animated:YES];
    }
}

- (void)addressBookCell:(TFJunYou_AddressBookCell *)abCell checkBoxSelectIndexNum:(NSInteger)indexNum isSelect:(BOOL)isSelect {
    
    TFJunYou_AddressBook *ab;
    if (abCell) {
        ab = [[self.letterResultArr objectAtIndex:abCell.index / 1000] objectAtIndex:abCell.index % 1000];
    }else {
        ab = self.abUreadArr[indexNum];
    }
    if (isSelect) {
        [_selectABs addObject:ab];
    }else {
        [_selectABs removeObject:ab];
    }
}

- (void)addressBookCell:(TFJunYou_AddressBookCell *)abCell addBtnAction:(TFJunYou_AddressBook *)addressBook {
    
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc]init];
    //设置短信内容
    vc.body = [NSString stringWithFormat:@"嗨，我正在使用%@。快来和我一起试试吧~ 下载地址：\n%@",APP_NAME,g_config.website];
    //设置收件人列表
    vc.recipients = @[addressBook.toTelephone];
    //设置代理
    vc.messageComposeDelegate = self;
    //显示控制器
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
// 实现代理函数: 点击取消按钮会自动调用
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_FriendsAttentionBatchAdd] ){
        [g_notify postNotificationName:kFriendListRefresh object:nil];
        
        self.isShowSelect = NO;
        [_selectBtn setTitle:Localized(@"JX_BatchAddition") forState:UIControlStateNormal];
        [_selectABs removeAllObjects];
        self.doneBtn.hidden = YES;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self_height-self.heightHeader-self.heightFooter);
        [self getServerData];
        
//        if (self.abUreadArr.count > 0) {
//            [self createHeaderView:self.abUreadArr];
//        }
        [g_App showAlert:Localized(@"JX_AddSuccess")];
    }
    
}


-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return show_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return show_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
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
