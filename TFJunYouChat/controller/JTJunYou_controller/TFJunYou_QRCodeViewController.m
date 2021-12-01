//
//  TFJunYou_QRCodeViewController.m
//  TFJunYouChat
//
//  Created by 1 on 17/9/14.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_QRCodeViewController.h"
#import "QRImage.h"
#import "TFJunYou_RelayVC.h"

@interface TFJunYou_QRCodeViewController ()

@property (nonatomic, strong) UIImageView * qrImageView;

@property (nonatomic, strong) UIButton * saveButton;

@property (nonatomic, strong) UIView *baseView;



@end

@implementation TFJunYou_QRCodeViewController

-(instancetype)init{
    if (self = [super init]) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.title = Localized(@"JXQR_QRImage");
        self.isGotoBack = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self.tableHeader addSubview:self.saveButton];
    
//    NSMutableDictionary * qrDict = [NSMutableDictionary dictionary];
    NSMutableString * qrStr = [NSMutableString stringWithFormat:@"%@?action=",g_config.website];
    if(self.type == QRUserType)
        [qrStr appendString:@"user"];
//        [qrDict setObject:@"user" forKey:@"action"];
    else if(self.type == QRGroupType)
        [qrStr appendString:@"group"];
//        [qrDict setObject:@"group" forKey:@"action"];
    if(self.account != nil)
        [qrStr appendFormat:@"&shikuId=%@",self.account];
//        [qrDict setObject:self.userId forKey:@"shiku"];
    
    
//     = [[[SBJsonWriter alloc] init] stringWithObject:qrDict];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if (self.type == QRGroupType) {
//        NSString *groupImagePath = [NSString stringWithFormat:@"%@%@/%@.%@",NSTemporaryDirectory(),g_myself.userId,self.userId,@"jpg"];
//        if (groupImagePath && [[NSFileManager defaultManager] fileExistsAtPath:groupImagePath]) {
//            imageView.image = [UIImage imageWithContentsOfFile:groupImagePath];
//        }else{
//            [roomData roomHeadImageRoomId:self.userId toView:imageView];
//        }
        [g_server getRoomHeadImageSmall:self.roomJId roomId:self.userId imageView:imageView];
    }else {
        [g_server getHeadImageLarge:self.userId userName:self.nickName imageView:imageView];
    }
    
    
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, TFJunYou__SCREEN_WIDTH-30, 500)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self.tableBody addSubview:self.baseView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    icon.image = imageView.image;
    icon.layer.cornerRadius = 30;
    icon.layer.masksToBounds = YES;
    [self.baseView addSubview:icon];
    
    CGSize size = [self.nickName sizeWithAttributes:@{NSFontAttributeName:SYSFONT(17)}];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, 41, size.width, size.height)];
    name.text = self.nickName;
    [self.baseView addSubview:name];
    

    UIImage * qrImage = [QRImage qrImageForString:qrStr imageSize:300 logoImage:imageView.image logoImageSize:70];
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(39, CGRectGetMaxY(icon.frame)+33, self.baseView.frame.size.width-39*2, self.baseView.frame.size.width-39*2)];
    _qrImageView.image = qrImage;
    [self.baseView addSubview:_qrImageView];
    
    
    NSString *tintStr;
    if (self.type == QRUserType) {
        tintStr = @"扫一扫上面的二维码图案，添加我为好友";
        
        UIImageView *sex = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+15, 0, 14, 14)];
        sex.image = [UIImage imageNamed:@""];
        [self.baseView addSubview:sex];
        sex.center = CGPointMake(sex.frame.origin.x, name.center.y);
        if ([self.sex intValue] == 0) {// 女
            sex.image = [UIImage imageNamed:@"basic_famale"];
        }else {// 男
            sex.image = [UIImage imageNamed:@"basic_male"];
        }

    }else {
        tintStr = @"扫一扫上面的二维码图案，加入群组";
    }
    
    UILabel *tintLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_qrImageView.frame)+20, self.baseView.frame.size.width, 14)];
    tintLab.text = tintStr;
    tintLab.textAlignment = NSTextAlignmentCenter;
    tintLab.font = SYSFONT(14);
    tintLab.textColor = HEXCOLOR(0x999999);
    [self.baseView addSubview:tintLab];

    CGFloat w = (TFJunYou__SCREEN_WIDTH-15*3)/2;
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.baseView.frame)+30, w, 40)];
    [save setTitle:@"保存到手机" forState:UIControlStateNormal];
    save.layer.cornerRadius = 7.f;
    save.layer.masksToBounds = YES;
    save.backgroundColor = [UIColor whiteColor];
    [save.titleLabel setFont:SYSFONT(16)];
    [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:save];
    
    UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(save.frame)+15, CGRectGetMaxY(self.baseView.frame)+30, w, 40)];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    share.layer.cornerRadius = 7.f;
    share.layer.masksToBounds = YES;
    share.backgroundColor = THEMECOLOR;
    [share.titleLabel setFont:SYSFONT(16)];
    [share addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:share];
}

-(void)saveButtonAction{
    UIImage * image = [UIImage imageWithView:self.baseView];
    [self saveToLibary:image];
}

 
- (void)shareToIndex {
      
         UIImage * image = _qrImageView.image;
        NSArray * activityItems = @[image];
        UIActivityViewController * activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            if (completed) {
                //[ToastUtils showHud:@"分享成功"];//此tost为自己封装的所以这句不用复制
            }else{
               // [ToastUtils showHud:@"分享失败，请重试"];//此tost为自己封装的所以这句不用复制
            }
            [activityVC dismissViewControllerAnimated:YES completion:nil];
        };
        activityVC.completionWithItemsHandler = myBlock;
        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,    UIActivityTypePostToTwitter,  UIActivityTypePostToWeibo,  UIActivityTypeMessage,  UIActivityTypeMail,  UIActivityTypePrint,  UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll,  UIActivityTypePostToTencentWeibo,  UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
        [self presentViewController:activityVC animated:YES completion:nil];
  
    
}
- (void)shareButtonAction {
    
    NSString *name = @"jpg";

    NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
    [g_server saveImageToFile:[UIImage imageWithView:self.baseView] file:file isOriginal:YES];
    //[g_server uploadFile:file validTime:nil messageId:nil toView:self];
    [self shareToIndex];
      
    
    
     
}


-(void)saveToLibary:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [g_server showMsg:Localized(@"JX_SaveSuessed") delay:1.5f];
    }else{
        [g_App showAlert:error.description];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIButton *)saveButton{
    if(!_saveButton){
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-15-18, TFJunYou__SCREEN_TOP - 15-18, 18, 18);
        [_saveButton setImage:[UIImage imageNamed:@"saveLibary_black"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];

    if ([aDownload.action isEqualToString:act_UploadFile]) {
        NSDictionary* p = nil;
        if([(NSArray *)[dict objectForKey:@"images"] count]>0)
            p = [[dict objectForKey:@"images"] objectAtIndex:0];
      

        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        msg.fromUserId = MY_USER_ID;
        msg.fromUserName = MY_USER_NAME;
        msg.type = [NSNumber numberWithInt:kWCMessageTypeImage];
        msg.content  = [p objectForKey:@"oUrl"];
        msg.timeSend     = [NSDate date];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isUpload     = [NSNumber numberWithBool:NO];

        [msg setMsgId];
        
        TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
        vc.relayMsgArray = [NSMutableArray arrayWithObject:msg];
        [g_navigation pushViewController:vc animated:YES];
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


@end
