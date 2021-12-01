//
//  TFJunYou_AddrBookVc.h.m
//
//  Created by flyeagleTang on 14-4-3.
//  Copyright (c) 2014年 Reese. All rights reserved.
//  [g_mainVC.friendVC showNewMsgCount:0];

#import "TFJunYou_AddrBookVc.h"
#import "XMG_AddrBookCell.h"
#import "TFJunYou_NewFriendViewController.h"
#import "TFJunYou_GroupViewController.h"
#import "TFJunYou_BlackFriendVC.h"


@interface TFJunYou_AddrBookVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation TFJunYou_AddrBookVc

 
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack=NO;
    [self createHeadAndFoot];
    self.title = Localized(@"JX_MailList");
    self.tableBody.backgroundColor=HEXCOLOR(0xF2F2F2);
     
    _dataArr = [NSMutableArray array];
    NSArray *imagesArr = @[@{@"userId":@"icon_xindpy",@"userNickname":@"新的朋友"},
                           @{@"userId":@"icon_qunz",@"userNickname":@"群组"},
                           @{@"userId":@"icon_xindpy",@"userNickname":@"黑名单"}];
    _dataArr = [TFJunYou_UserBaseObj mj_objectArrayWithKeyValuesArray:imagesArr];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP+0.5, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_TOP-TFJunYou__SCREEN_BOTTOM) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self; 
    tableView.backgroundColor = HEXCOLOR(0xF2F2F2);
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=UITableViewAutomaticDimension;
    tableView.estimatedRowHeight=100;
    [self.view addSubview:tableView];
    _tableView=tableView;
}
 
#pragma mark   ---------tableView协议----------------
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMG_AddrBookCell  *cell=[XMG_AddrBookCell cellWithTableView:tableView];
   
    cell.userBaseModel = _dataArr[indexPath.row];

    return cell;
}
 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
         
        
        TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
        newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:FRIEND_CENTER_USERID];
        newobj.message = [[TFJunYou_MessageObject alloc] init];
        newobj.message.toUserId = FRIEND_CENTER_USERID;
        newobj.user.msgsNew = [NSNumber numberWithInt:0];
        [newobj.message updateNewMsgsTo0];
        
        NSArray *friends = [[TFJunYou_FriendObject sharedInstance] fetchAllFriendsFromLocal];
        for (NSInteger i = 0; i < friends.count; i ++) {
            TFJunYou_FriendObject *friend = friends[i];
            if ([friend.msgsNew integerValue] > 0) {
                [friend updateNewMsgUserId:friend.userId num:0];
                [friend updateNewFriendLastContent];
            }
        }
        
        [self showNewMsgCount:0];

        TFJunYou_NewFriendViewController* vc = [[TFJunYou_NewFriendViewController alloc]init];
        [g_navigation pushViewController:vc animated:YES];
        
    }else if (indexPath.row==1){
        
        
        TFJunYou_GroupViewController *vc = [[TFJunYou_GroupViewController alloc] init];
        [g_navigation pushViewController:vc animated:YES];
    }else if (indexPath.row==3){
        
        TFJunYou_BlackFriendVC *vc = [[TFJunYou_BlackFriendVC alloc] init];
        vc.isDevice = YES;
        vc.title = Localized(@"JX_MyDevices");
        [g_navigation pushViewController:vc animated:YES];
    }else if (indexPath.row==2){
        
        
        TFJunYou_BlackFriendVC *vc = [[TFJunYou_BlackFriendVC alloc] init];
        vc.title = Localized(@"JX_BlackList");
        [g_navigation pushViewController:vc animated:YES];
        
    }
    
}
 
- (void) showNewMsgCount:(NSInteger)friendNewMsgNum{
    
    
}
@end
