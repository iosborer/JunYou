//
//  TFJunYou_AboutVC.m
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_AboutVC.h"
#import "TFJunYou_ShareListVC.h"
//#import "TFJunYou_ShareManager.h"
#import "TFJunYou_FAQCenterDetailVC.h"

#define HEIGHT 44
#define STARTTIME_TAG 1

@interface TFJunYou_AboutVC ()<ShareListDelegate,TFJunYou_ActionSheetVCDelegate>
@property(nonatomic, strong)  UITextView *textView;
@end

@implementation TFJunYou_AboutVC

- (id)init
{
    self = [super init];
    if (self) {
        self.isGotoBack   = YES;
        self.title = Localized(@"JXAboutVC_AboutUS");
        self.heightFooter = 0;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        [self createHeadAndFoot];
        //        self.tableBody.backgroundColor = HEXCOLOR(0xf0eff4);
        self.tableBody.scrollEnabled = YES;
        //        int h = 0;
        
        if (THE_APP_OUR) {
            //右侧分享按钮
            UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self_width-31-8, TFJunYou__SCREEN_TOP - 38, 31, 31)];
            [shareBtn setImage:[UIImage imageNamed:@"ic_share_black"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableHeader addSubview:shareBtn];
        }
                
        TFJunYou_ImageView* iv;
        iv = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-67)/2, TFJunYou__SCREEN_TOP+40, 67, 67)];
        iv.image = [UIImage imageNamed:@"ALOGO_120"];
        [self.tableBody addSubview:iv];
        
        UILabel* p = [self createLabel:self.tableBody default:[NSString stringWithFormat:@"%@ %@",APP_NAME,g_config.version]];
        p.frame = CGRectMake(0, CGRectGetMaxY(iv.frame)+27, TFJunYou__SCREEN_WIDTH, 20);
        p.textAlignment = NSTextAlignmentCenter;
        p.textColor = HEXCOLOR(0x333333);
        p.font = g_factory.font14;
        
        if (THE_APP_OUR) {
            p = [self createLabel:self.view default:g_App.config.companyName];
            p.frame = CGRectMake(0, TFJunYou__SCREEN_HEIGHT-110, TFJunYou__SCREEN_WIDTH, 13);
            p.font = g_factory.font13;
            p.textColor = HEXCOLOR(0x333333);
            p.textAlignment = NSTextAlignmentCenter;
            
            p = [self createLabel:self.view default:g_App.config.copyright];
            p.frame = CGRectMake(0, TFJunYou__SCREEN_HEIGHT-88, TFJunYou__SCREEN_WIDTH, 15);
            p.font = g_factory.font14;
            p.textColor = HEXCOLOR(0x333333);
            p.textAlignment = NSTextAlignmentCenter;
        }
        UIButton* _btn;
        _btn = [UIFactory createCommonButton:Localized(@"JXAboutVC_Good") target:self action:@selector(onGood)];
        _btn.frame = CGRectMake(15, iv.frame.origin.y+iv.frame.size.height+20 + 20 + 20, TFJunYou__SCREEN_WIDTH-30, 40);
        [_btn.titleLabel setFont:SYSFONT(16)];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 7.f;
//        [self.tableBody addSubview:_btn];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, iv.frame.origin.y+iv.frame.size.height+20 + 20 + 20, TFJunYou__SCREEN_WIDTH, 250)];
        [_textView setEditable:NO];
        [self.tableBody addSubview:_textView];
        [g_server get_act_ApiEditGet:@"8" toView:self];
        
    }
    return self;
}


- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1 {
    [_wait hide];
    if ([aDownload.action isEqualToString:act_ApiEditGet]) {
        TFJunYou_FAQCenterDetailModel *model = [TFJunYou_FAQCenterDetailModel mj_objectWithKeyValues:dict];
        NSString *htmlString  =[NSString stringWithFormat:@"%@",model.content];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
        
        _textView.attributedText = attributedString;
    }
}

- (int)didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict {
    [_wait hide];
    return show_error;
}

- (int)didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error {//error为空时，代表超时
    [_wait hide];
    return show_error;
}

- (void)didServerConnectStart:(TFJunYou_Connection*)aDownload {
    [_wait start];
}




-(void)dealloc{
    //    NSLog(@"TFJunYou_AboutVC.dealloc");
    //    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel*)createLabel:(UIView*)parent default:(NSString*)s{
    UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/2 -20,HEIGHT-INSETS*2)];
    p.userInteractionEnabled = NO;
    p.text = s;
    p.font = g_factory.font13;
    p.textAlignment = NSTextAlignmentRight;
    [parent addSubview:p];
    //    [p release];
    return p;
}

-(void)onGood{
    if (g_App.config.appleId.length > 0) {
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",g_App.config.appleId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

//分享按钮点击事件
- (void)shareBtnClick:(UIButton *)shareBtn{
    //    TFJunYou_ShareListVC *shareListVC = [[TFJunYou_ShareListVC alloc] init];
    //    shareListVC.shareListDelegate = self;
    //    [self.view addSubview:shareListVC.view];
    TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[@"circle_of_friends_icon",@"wechat_icon_square"] names:@[@"分享到朋友圈",@"分享给微信好友"]];
    actionVC.delegate = self;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [self shareToIndex:1];
    }else if (index == 1) {
        [self shareToIndex:0];
    }
}

- (void)shareToIndex:(NSInteger)index {
    TFJunYou_ShareModel *shareModel = [[TFJunYou_ShareModel alloc] init];
    shareModel.shareTo = index;
    //分享标题
    shareModel.shareTitle = APP_NAME;
    
    //分享内容
    shareModel.shareContent = @"微信？快手？ZOOM?\n轻轻松松实现它！";
    //    //分享链接
    //    shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?userId=%lld&language=%@",g_config.shareUrl,act_ShareBoss,[[_dataDict objectForKey:@"userId"] longLongValue],[TFJunYou_MyTools getCurrentSysLanguage]];
    //分享链接
    shareModel.shareUrl = g_config.website;
    
    //分享头像
    
    //    shareModel.shareImageUrl = url;
    shareModel.shareImage = [UIImage imageNamed:@"ALOGO_120"];
//    [[TFJunYou_ShareManager defaultManager] shareWith:shareModel delegate:self];
    
    
}


#pragma mark TFJunYou_ShareSelectView delegate
//- (void)didShareBtnClick:(UIButton *)shareBtn{
//    //    NSString *userId = [NSString stringWithFormat:@"%lld",[[_dataDict objectForKey:@"userId"] longLongValue]-1];
////    NSString *userId = [NSString stringWithFormat:@"%lld",[[_dataDict objectForKey:@"userId"] longLongValue]];
//
//    TFJunYou_ShareModel *shareModel = [[TFJunYou_ShareModel alloc] init];
//    shareModel.shareTo = shareBtn.tag;
//    //分享标题
//    shareModel.shareTitle = APP_NAME;
//
//    //分享内容
//    shareModel.shareContent = @"微信？快手？ZOOM?\n轻轻松松实现它！";
//    //    //分享链接
//    //    shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?userId=%lld&language=%@",g_config.shareUrl,act_ShareBoss,[[_dataDict objectForKey:@"userId"] longLongValue],[TFJunYou_MyTools getCurrentSysLanguage]];
//    //分享链接
//    shareModel.shareUrl = g_config.website;
//
//    //分享头像
//
////    shareModel.shareImageUrl = url;
//    shareModel.shareImage = [UIImage imageNamed:@"ALOGO_120"];
//    [[TFJunYou_ShareManager defaultManager] shareWith:shareModel delegate:self];
//
//}

@end
