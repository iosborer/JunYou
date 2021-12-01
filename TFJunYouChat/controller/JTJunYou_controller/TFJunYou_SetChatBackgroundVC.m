//
//  TFJunYou_SetChatBackgroundVC.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/12/8.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_SetChatBackgroundVC.h"
#import "TFJunYou_CameraVC.h"

#define HEIGHT 56

@interface TFJunYou_SetChatBackgroundVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TFJunYou_CameraVCDelegate>

@end

@implementation TFJunYou_SetChatBackgroundVC

- (instancetype)init {
    if ([super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isGotoBack = YES;
    self.title = Localized(@"JX_SettingUpChatBackground");
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    self.tableBody.scrollEnabled = YES;
    
    int h=0;
    int w=TFJunYou__SCREEN_WIDTH;
    
    TFJunYou_ImageView* iv;
    iv = [self createButton:Localized(@"JX_SelectionFromHandsetAlbum") drawTop:NO drawBottom:YES icon:nil click:@selector(onPickPhoto)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height;
    
    iv = [self createButton:Localized(@"JX_TakeAPicture") drawTop:NO drawBottom:NO icon:nil click:@selector(onCamera)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
    h+=iv.frame.size.height + 8;
    
    iv = [self createButton:Localized(@"JX_RestoreDefaultBackground") drawTop:NO drawBottom:NO icon:nil click:@selector(onDefault)];
    iv.frame = CGRectMake(0,h, w, HEIGHT);
}

// 从手机相册选择
- (void)onPickPhoto {
    
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:NO];
    [self presentViewController:imgPicker animated:YES completion:^{}];
}

// 拍照
- (void)onCamera {
    TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
    vc.cameraDelegate = self;
    vc.isPhoto = YES;
    vc = [vc init];
    [self presentViewController:vc animated:YES completion:nil];
}

// 恢复默认
- (void)onDefault {
    
    if (self.userId.length > 0) {
        [g_constant.userBackGroundImage removeObjectForKey:self.userId];
        BOOL isSuccess = [g_constant.userBackGroundImage writeToFile:backImage atomically:YES];
        
        [g_notify postNotificationName:kSetBackGroundImageView object:nil];
        if (isSuccess) {
            [g_App showAlert:Localized(@"JX_SetUpSuccess")];
        }else {
            [g_App showAlert:Localized(@"JX_SettingFailure")];
        }
        return;
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:kChatBackgroundImagePath]) {
        [g_App showAlert:Localized(@"JX_SetUpSuccess")];
        return;
    }
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:kChatBackgroundImagePath error:&error];
    if (!error) {
        [g_App showAlert:Localized(@"JX_SetUpSuccess")];
    }else {
        [g_App showAlert:Localized(@"JX_SettingFailure")];
    }
}


#pragma mark ----------图片选择完成-------------
//UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage  * chosedImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImageJPEGRepresentation(chosedImage, 1);
    BOOL isSuccess = NO;
    if (self.userId.length > 0) {
//        if ([self.delegate respondsToSelector:@selector(setChatBackgroundVC:image:)]) {
//            [self.delegate setChatBackgroundVC:self image:chosedImage];
//        }
        [g_constant.userBackGroundImage setObject:imageData forKey:self.userId];
        isSuccess = [g_constant.userBackGroundImage writeToFile:backImage atomically:YES];
        [g_notify postNotificationName:kSetBackGroundImageView object:chosedImage];

    }else {
        isSuccess = [imageData writeToFile:kChatBackgroundImagePath atomically:YES];
        
    }
    if (isSuccess) {
        [g_App showAlert:Localized(@"JX_SetUpSuccess")];
    }else {
        [g_App showAlert:Localized(@"JX_SettingFailure")];
    }
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

// 拍照
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    BOOL isSuccess = NO;
    if (self.userId.length > 0) {
//        if ([self.delegate respondsToSelector:@selector(setChatBackgroundVC:image:)]) {
//            [self.delegate setChatBackgroundVC:self image:image];
//        }
        [g_constant.userBackGroundImage setObject:imageData forKey:self.userId];
        isSuccess = [g_constant.userBackGroundImage writeToFile:backImage atomically:YES];
        
        [g_notify postNotificationName:kSetBackGroundImageView object:image];
    }else {
        isSuccess = [imageData writeToFile:kChatBackgroundImagePath atomically:YES];
        
    }
    if (isSuccess) {
        [g_App showAlert:Localized(@"JX_SetUpSuccess")];
    }else {
        [g_App showAlert:Localized(@"JX_SettingFailure")];
    }
    
}

-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom icon:(NSString*)icon click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(15, 0, TFJunYou__SCREEN_WIDTH-100, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    p.delegate = self;
    p.didTouch = click;
    [btn addSubview:p];
    
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (HEIGHT-20)/2, 20, 20)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
    }
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    
    return btn;
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
