//
//  TFJunYou_FriendCirleVc.m
//  JTManyChildrenSongs
//
//  Created by os on 2020/12/3.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "TFJunYou_FriendCirleVc.h"
#import "XMG_FriendCirleCell.h"
#import "TFJunYou_WeiboVC.h"
#import "TFJunYou_ScanQRViewController.h"
#import "TFJunYou_LabelVC.h"
#import "TFJunYou_SearchUserVC.h"
#import "TFJunYou_PayViewController.h"
#import "TFJunYou_PublicNumberVC.h"
#import "TFJunYou_NearVC.h"
@interface TFJunYou_FriendCirleVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation TFJunYou_FriendCirleVc
 

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.heightHeader = TFJunYou__SCREEN_TOP;
   self.heightFooter = 0;
   self.isGotoBack=NO;
   [self createHeadAndFoot];
   self.title =@"发现";// Localized(@"JX_MailList");
    self.tableBody.backgroundColor=HEXCOLOR(0xF2F2F2);
    _dataArr = [NSMutableArray array];
     
      NSArray *imagesArr = @[@{@"userId":@"icon_pengyq",@"userNickname":@"朋友圈"},
                              @{@"userId":@"icon_saoys",@"userNickname":@"扫一扫"},
                              @{@"userId":@"icon_biaoq",@"userNickname":@"标签"},
                              @{@"userId":@"icon_gongzh",@"userNickname":@"公众号"},
                              @{@"userId":@"icon_shoufk",@"userNickname":@"收付款"}];
//     @{@"userId":@"icon_near",@"userNickname":@"附近的人"}
    
       _dataArr = [TFJunYou_UserBaseObj mj_objectArrayWithKeyValuesArray:imagesArr];
         
      
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP+5, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_TOP-TFJunYou__SCREEN_BOTTOM-5) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor = HEXCOLOR(0xF2F2F2);
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
 
    
}

#pragma mark   ---------tableView协议----------------
 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     
    return _dataArr.count;
}
  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMG_FriendCirleCell *cell = [XMG_FriendCirleCell cellWithTableView:tableView];
    
    cell.userBaseModel = _dataArr[indexPath.row];
     
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
         
        
        TFJunYou_WeiboVC *weiboVC = [TFJunYou_WeiboVC alloc];
        weiboVC.user = g_server.myself;
         weiboVC = [weiboVC init];
        [g_navigation pushViewController:weiboVC animated:YES];
        
    }else if (indexPath.row==1){
        
        
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            [g_server showMsg:Localized(@"JX_CanNotopenCenmar")];
            return;
        }
        
        TFJunYou_ScanQRViewController * scanVC = [[TFJunYou_ScanQRViewController alloc] init];
        [g_navigation pushViewController:scanVC animated:YES];
    }else if (indexPath.row==2){
        
        TFJunYou_LabelVC *vc = [[TFJunYou_LabelVC alloc] init];
        [g_navigation pushViewController:vc animated:YES];
    }else if (indexPath.row==3){
        
            TFJunYou_PublicNumberVC *payVC = [[TFJunYou_PublicNumberVC alloc] init];
            [g_navigation pushViewController:payVC animated:YES];
        
    }else if (indexPath.row==4){
        
        TFJunYou_PayViewController *payVC = [[TFJunYou_PayViewController alloc] init];
        [g_navigation pushViewController:payVC animated:YES];
        
     }
    
    else if (indexPath.row==5){
        TFJunYou_NearVC * nearVc = [[TFJunYou_NearVC alloc] init];
        [g_navigation pushViewController:nearVc animated:YES];
     }
}
 
@end
