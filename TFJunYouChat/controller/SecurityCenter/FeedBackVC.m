//
//  FeedBackVC.m
//  WonBey
//
//  Created by JayLuo on 2019/4/11.
//  Copyright © 2020 Hunan Liaocheng Technology Co., Ltd.All rights reserved.
//

#import "FeedBackVC.h"
#import "HXPhotoPicker.h"
#import "Placeholderview.h"
#import "TFJunYou_feedBackVC.h"
#import "TFJunYou_FAQCenterVC.h"

static const CGFloat kPhotoViewMargin = 12.0;
static const int maxLimitWord = 200;
@interface FeedBackVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HXPhotoViewDelegate>


@property (nonatomic, strong) UIScrollView  *scrollView;

@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) UILabel       *numLabel;

@property (nonatomic, strong) UITextField   *phoneField;

@property (nonatomic, strong) UIButton      *sureBtn;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) UIButton *bottomView;
@property (assign, nonatomic) BOOL needDeleteItem;
@property (nonatomic, strong) UILabel *shotCountLabel;
// 选择图片数组
@property (nonatomic, strong) NSArray <UIImage *>*imageArray;
@property (nonatomic, strong) Placeholderview *textView;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation FeedBackVC
{
    NSMutableArray *_selectImgArray;
    NSMutableArray *_selectImgAssetArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    [self createHeadAndFoot];
    self.title = self.type == FeedBackTypeComplaints ? @"投诉" : @"意见反馈";
    _selectImgArray      = [NSMutableArray array];
    _selectImgAssetArray = [NSMutableArray array];
    [self creatViews];
    // Do any additional setup after loading the view.
}

- (void)creatViews{
    [self.tableBody addSubview:self.scrollView];
    CGFloat h = 0;
    CGFloat width = self.scrollView.frame.size.width;
    UILabel *tipslabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kPhotoViewMargin, width, 20)];
    tipslabel.font = [UIFont systemFontOfSize:12];
    tipslabel.textColor = [UIColor grayColor];
    tipslabel.text = @"请描述具体内容";
    [self.scrollView addSubview:tipslabel];
    h = CGRectGetMaxY(tipslabel.frame);
    
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, h + kPhotoViewMargin, width, 50)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:phoneView];
    h = CGRectGetMaxY(phoneView.frame);
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.text = @"联系人电话(必填):";
    [phoneView addSubview:phoneLabel];
    phoneLabel.hx_centerY = phoneView.frame.size.height/2;
    
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+5, 5, width - CGRectGetMaxX(phoneLabel.frame)-5, 20)];
    _phoneField.placeholder = @"便于我们与您联系";
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.keyboardType = UIKeyboardTypePhonePad;
    _phoneField.font = phoneLabel.font;
    [phoneView addSubview:_phoneField];
    _phoneField.hx_centerY = phoneView.frame.size.height/2;
    
    
    UIView *shotView = [[UIView alloc] initWithFrame:CGRectMake(0, h, width, 50)];
    shotView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:shotView];
    h = CGRectGetMaxY(shotView.frame);
    
    UILabel *shotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    shotLabel.font = [UIFont systemFontOfSize:16];
    shotLabel.textColor = [UIColor blackColor];
    shotLabel.text = @"相关截图(必填)";
    [shotView addSubview:shotLabel];
    shotLabel.hx_centerY = shotView.frame.size.height/2;
    
    _shotCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 100 - kPhotoViewMargin, 5, 100, 20)];
    _shotCountLabel.textAlignment = NSTextAlignmentRight;
    _shotCountLabel.font = [UIFont systemFontOfSize:16];
    _shotCountLabel.textColor = [UIColor grayColor];
    _shotCountLabel.text = @"0张/9";
    [shotView addSubview:_shotCountLabel];
    _shotCountLabel.hx_centerY = shotView.frame.size.height/2;
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager scrollDirection:UICollectionViewScrollDirectionVertical];
    photoView.frame = CGRectMake(0,h, width, 0);
    photoView.collectionView.contentInset = UIEdgeInsetsMake(0, kPhotoViewMargin, 0, kPhotoViewMargin);
    photoView.backgroundColor = [UIColor whiteColor];
//    photoView.spacing = kPhotoViewMargin;
//    photoView.lineCount = 1;
    photoView.delegate = self;
//    photoView.cellCustomProtocol = self;
    photoView.outerCamera = YES;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.previewShowDeleteButton = YES;
    photoView.showAddCell = YES;
//    photoView.showDeleteNetworkPhotoAlert = YES;
//    photoView.adaptiveDarkness = NO;
//    photoView.previewShowBottomPageControl = NO;
    [photoView.collectionView reloadData];
    [self.scrollView addSubview:photoView];
    self.photoView = photoView;
    
    h = CGRectGetMaxY(photoView.frame);
    
    _textView = [[Placeholderview alloc] initWithFrame:CGRectMake(0, h, width, 0)];
    _textView.font = _shotCountLabel.font;
    _textView.placeholder = @"请输入不少于15个字的描述";
    _textView.placeColor = [UIColor lightGrayColor];
    _textView.delegate = self;
    [self.scrollView addSubview:_textView];
    h = CGRectGetMaxY(_textView.frame);
    
    
    _submitBtn = [UIFactory createCommonButton:@"提交" target:self action:@selector(onSubmit)];
    [_submitBtn setBackgroundImage:[UIImage createImageWithColor:HEXCOLOR(0x04ABFF)] forState:UIControlStateNormal];
    _submitBtn.custom_acceptEventInterval = 1.f;
    _submitBtn.frame = CGRectMake(15,h+30, TFJunYou__SCREEN_WIDTH-30, 40);
    [_submitBtn setBackgroundImage:[UIImage createImageWithColor:HEXCOLOR(0x099BFB)] forState:UIControlStateHighlighted];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 7.f;
    [self.tableBody addSubview:_submitBtn];
    
    
    [self.view addSubview:self.bottomView];
}

- (void)onSubmit{
    if (self.phoneField.text.length < 1) {
        [g_App showAlert:@"请输入正确的电话号码"];
        return;
    }
    if (self.imageArray.count < 1) {
        [g_App showAlert:@"相关截图为必填项"];
        return;
    }
    
    if (self.textView.text.length < 15) {
        [g_App showAlert:@"请输入不少于15个字的描述"];
        return;
    }
    
    [g_server uploadFile:_imageArray audio:nil video:nil file:@"" type:1 validTime:@"-1" timeLen:1 toView:self gifDic:@{}];
    
}

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
    
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"images"]];
        NSString *urls = @"";
        for (NSDictionary *tempDict in array) {
            NSString *url = [tempDict objectForKey:@"oUrl"];
            urls = [urls stringByAppendingFormat:@"%@,", url];
        }
        // 去掉最后一个逗号
        urls = [urls substringWithRange:NSMakeRange(0, [urls length] - 1)];
        NSLog(@"urls----- %@", urls);
    
        // 发请求 1 图片地址
        //    FeedBackTypeComplaints, // 投诉
        //    FeedBackTypeSuggestion, // 意见反馈
        // 2 号码
        NSString *phone = self.phoneField.text;
        //  3 留言
        NSString *message = self.textView.text;
//        0投诉建议 1意见反馈

        NSString *type = @"";
        if (self.type == FeedBackTypeComplaints) {
            type = @"0";
        } else if (self.type == FeedBackTypeSuggestion) {
            type = @"1";
        }
        
        
        [g_server get_act_ApiComplaintSubmit:type phone:phone imgs:urls content:message toView:self];
        
    }
    
    if([aDownload.action isEqualToString:act_ApiComplaintSubmit]){
        [g_App showAlert:@"上传成功，请等待客服联系"];
        [g_navigation popToViewController:[TFJunYou_feedBackVC class] animated:YES];
        [g_navigation popToViewController:[TFJunYou_FAQCenterVC class] animated:YES];
    }
    
    

}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
      
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
      
    }
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start:Localized(@"JX_SendNow")];
}




- (NSString *)getNumberFromStr:(NSString *)str
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}
- (UIButton *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView setTitle:@"删除" forState:UIControlStateNormal];
        [_bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView setBackgroundColor:[UIColor redColor]];
        _bottomView.frame = CGRectMake(0, self.view.hx_h - 50 - hxBottomMargin, self.view.hx_w, 50 + hxBottomMargin);
        _bottomView.alpha = 0;
    }
    return _bottomView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.type = HXConfigurationTypeWXChat;
        HXWeakSelf
        _manager.configuration.photoListBottomView = ^(HXPhotoBottomView *bottomView) {
            
        };
        _manager.configuration.previewBottomView = ^(HXPhotoPreviewBottomView *bottomView) {

        };
        
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:60.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };
    }
    return _manager;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-64)];
        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (UITextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [UITextField new];
        _phoneField.backgroundColor = [UIColor whiteColor];
        _phoneField.keyboardType    = UIKeyboardTypePhonePad;
        _phoneField.leftViewMode    = UITextFieldViewModeAlways;
        _phoneField.clearButtonMode = UITextFieldViewModeAlways;
        _phoneField.font            = [UIFont systemFontOfSize:14];
        
        UILabel *leftlab           = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
        leftlab.font               = [UIFont systemFontOfSize:14];
        leftlab.textAlignment      = NSTextAlignmentCenter;
        _phoneField.leftView        = leftlab;
        _phoneField.placeholder = @"  便于与我们联系";
        leftlab.text            = @"联系电话(必填):";

    }
    return _phoneField;
}


- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
//    [self changeStatus];
//    NSSLog(@"%@",[videos.firstObject videoURL]);
//    HXPhotoModel *photoModel = allList.firstObject;
    HXWeakSelf
    [allList hx_requestImageWithOriginal:isOriginal completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        // imageArray 获取成功的image数组
        // errorArray 获取失败的model数组
        weakSelf.imageArray = imageArray;
        weakSelf.shotCountLabel.text = [NSString stringWithFormat:@"%ld张/9", imageArray.count];
        NSSLog(@"\nimage: %@\nerror: %@",imageArray,errorArray);
    }];
}
- (void)photoViewCurrentSelected:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    for (HXPhotoModel *photoModel in allList) {
        NSSLog(@"当前选择----> %@", photoModel.selectIndexStr);
    }
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

//- (CGFloat)photoViewHeight:(HXPhotoView *)photoView {
//    return 140;
//}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    _textView.frame = CGRectMake(0, CGRectGetMaxY(frame), self.scrollView.frame.size.width, 100);
    _submitBtn.frame = CGRectMake(15,CGRectGetMaxY(_textView.frame)+30, TFJunYou__SCREEN_WIDTH-30, 40);
    
}
- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}
- (BOOL)photoView:(HXPhotoView *)photoView collectionViewShouldSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(HXPhotoModel *)model {
    return YES;
}

- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView gestureRecognizer:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    return self.needDeleteItem;
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.alpha = 0.5;
    }];
    NSSLog(@"长按手势开始了 - %ld",indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self.view];
    if (point.y >= self.bottomView.hx_y) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.alpha = 0.5;
        }];
    }
    NSSLog(@"长按手势改变了 %@ - %ld",NSStringFromCGPoint(point), indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self.view];
    if (point.y >= self.bottomView.hx_y) {
        self.needDeleteItem = YES;
        [self.photoView deleteModelWithIndex:indexPath.item];
    }else {
        self.needDeleteItem = NO;
    }
    NSSLog(@"长按手势结束了 - %ld",indexPath.item);
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.alpha = 0;
    }];
}


- (void)textViewDidChange:(UITextView *)textView {
    int maxLimit = maxLimitWord;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textView.text.length > maxLimit) {
                textView.text = [textView.text substringToIndex:maxLimit];
                [g_App showAlert:@"超出字数限制"];
            }
        } else {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (textView.text.length > maxLimit) {
            textView.text = [textView.text substringToIndex:maxLimit];
            [g_App showAlert:@"超出字数限制"];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int maxLimit = maxLimitWord;
    if ([self isText:textView beyondLimit:maxLimit] && [text length] > 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isText:(UITextView *)tv beyondLimit:(int)maxLimit{
    NSString *lang = [[tv textInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [tv markedTextRange];
        UITextPosition *position = [tv positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (tv.text.length > maxLimit) {
                return YES;
            }
        }
    } else {
        if (tv.text.length > maxLimit) {
            return YES;
        }
    }
    
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
