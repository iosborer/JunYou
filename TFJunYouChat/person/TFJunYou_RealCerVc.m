//
//  TFJunYou_RealCerVc.m
//  TFJunYouChat
//
//  Created by os on 2020/12/4.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_RealCerVc.h"
#import "UIView+Frame.h"

@interface TFJunYou_RealCerVc ()
@property (nonatomic,weak)UITextField *nameTF;
@property (nonatomic,weak)UITextField *cardTF;
@end

@implementation TFJunYou_RealCerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@",@"实名认证"];
    self.heightFooter = 0;
    self.isGotoBack=YES;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    
    [self prepareForCer];
}
 
- (void)prepareForCer{
         
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(30,TFJunYou__SCREEN_TOP+TFJunYou__SCREEN_BOTTOM,TFJunYou__SCREEN_WIDTH-60,20)];
    name.font = [UIFont systemFontOfSize:18.0];
    name.textAlignment=NSTextAlignmentLeft;
    name.text = @"姓名";
    [self.view addSubview:name];
    
    
    UITextField *nameTF= [[UITextField alloc]initWithFrame:CGRectMake(30, name.bottom+10, TFJunYou__SCREEN_WIDTH-60, 44)];
    nameTF.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nameTF];
    _nameTF=nameTF;
    
    UILabel *cardLable = [[UILabel alloc] initWithFrame:CGRectMake(30,nameTF.bottom+20,TFJunYou__SCREEN_WIDTH-60,20)];
    cardLable.font = [UIFont systemFontOfSize:18.0];
    cardLable.textAlignment=NSTextAlignmentLeft;
    cardLable.text = @"身份证号";
    [self.view addSubview:cardLable];
    
    
    UITextField *cardTF= [[UITextField alloc]initWithFrame:CGRectMake(30, cardLable.bottom+10, TFJunYou__SCREEN_WIDTH-60, 44)];
    cardTF.backgroundColor=[UIColor whiteColor];
    cardTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:cardTF];
    _cardTF=cardTF;
    
    
    UIButton *cerButton= [[UIButton alloc]initWithFrame:CGRectMake(60, cardTF.bottom+30, TFJunYou__SCREEN_WIDTH-120, 44)];
    cerButton.backgroundColor=g_theme.themeColor;
    [cerButton setTitle:@"实名认证" forState:UIControlStateNormal];
    cerButton.showsTouchWhenHighlighted=YES;
    [self.view addSubview:cerButton];
    [cerButton addTarget:self action:@selector(certificatesButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)certificatesButtonClick{
    
    if (_nameTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实姓名"];
        [SVProgressHUD dismissWithDelay:1.1];
        return;
    } if (_cardTF.text.length==0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写真实身份证号"];
        [SVProgressHUD dismissWithDelay:1.1];
        return;
    }
    [g_server act_userCertificationVerifyResultMessage:_cardTF.text realName:_nameTF.text toView:self];
    
}
 
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_UserUpdate] ){
        [self actionQuit];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    
    return 1;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    
    [g_App showAlert:[NSString stringWithFormat:@"%@",@"认证不成功,请尝试再次重新认证,是否填写的真实信息"]];
    return 1;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
@end
