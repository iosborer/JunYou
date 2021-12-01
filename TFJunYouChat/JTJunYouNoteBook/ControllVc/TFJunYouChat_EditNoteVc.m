//
//  TFJunYouChat_EditNoteVc.m
//  P-Note
//
//  Created by yaxiongfang on 4/9/16.
//  Copyright © 2016 yxfang. All rights reserved.
//

#import "TFJunYouChat_EditNoteVc.h"
#import "NoteHelper.h"
#import "Note.h"
#import "StringUtils.h"
#import "Tools.h"

@interface TFJunYouChat_EditNoteVc()<UITextViewDelegate,UIScrollViewDelegate>


@end

@implementation TFJunYouChat_EditNoteVc {
    NoteHelper *_noteHelper;

    // 标识是否是编辑
    BOOL isEdit;
}
- (void)backButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [super setNavigationRightBtn:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                 target:self action:@selector(navigationRightBtnClick)]];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 20)];
    [backButton setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    _edtContent.delegate=self;
    // 编辑模式
    if (_note != nil) {
        _edtTitle.text = _note.title;
        _edtContent.text = _note.content;
        [super setTitle:_note.title];

        isEdit = YES;
    }
    else {
        [super setTitle:@"添加笔记"];
        isEdit = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [self.view endEditing:YES];
    
}
 
- (void)viewWillAppear:(BOOL)animated {
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [super viewWillAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeObserver];
}

//监听事件
- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    NSValue *keyboardRectAsObject = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];

   // self.edtContent.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden {
   // self.edtContent.contentInset = UIEdgeInsetsZero;
}

- (void)navigationRightBtnClick {
    NSString *title = _edtTitle.text;
    NSString *content = _edtContent.text;

    if ([StringUtils isEmpty:title]) {
        [Tools showTip:self andMsg:@"请输入标题"];
        return;
    }

    if ([StringUtils isEmpty:content]) {
        [Tools showTip:self andMsg:@"请输入笔记"];
        return;
    }

    if (_noteHelper == nil) {
        _noteHelper = [[NoteHelper alloc] init];
    }

    if (isEdit) {
        if ([_noteHelper updateNote:title andContent:content andFolderId:_note.id]) {
            [Tools showTip:self andMsg:@"保存成功"];
            [_edtTitle resignFirstResponder];
            [_edtContent resignFirstResponder];

            // 修改成功 发送更新列表通知
            [self postNotification:NOTIFICATION_UPDATE_NOTE obj:nil];
        }
        else {
            [Tools showTip:self andMsg:@"保存失败"];
        }
    }
    else {
        if ([_noteHelper addNote:title andContent:content andFolderId:_folderId]) {
            [Tools showTip:self andMsg:@"保存成功"];
            [_edtTitle resignFirstResponder];
            [_edtContent resignFirstResponder];

            // 添加成功 发送更新列表通知
            [self postNotification:NOTIFICATION_UPDATE_NOTE obj:nil];

            _edtTitle.text = @"";
            _edtContent.text = @"";
        }
        else {
            [Tools showTip:self andMsg:@"保存失败"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
