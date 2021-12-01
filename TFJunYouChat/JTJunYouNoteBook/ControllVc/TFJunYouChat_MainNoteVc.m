//
//  TFJunYouChat_MainNoteVc.m
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYouChat_MainNoteVc.h"
 
#import "FolderNoteCell.h"
#import "NoteFolderHelper.h"
#import "NoteFolder.h"
#import "FDAlertView.h"
#import "AddFolderView.h"
#import "TFJunYouChat_NotesListVc.h"
#import "TFJunYouChat_SettingVc.h"


@implementation TFJunYouChat_MainNoteVc {

    // 私密开关
    BOOL pSwitch;
    // 保存的密码
    NSString *savePwd;

    NoteFolderHelper *_folderHelper;
    NSMutableArray *folderList;

    // 0 normal 1 edit 2 delete
    int mode;

    UIBarButtonItem *_editBarItem;

    UIBarButtonItem *_delBarItem;
}

- (void)backButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"P Note"];

    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 20)];
    [backButton setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    _editBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editMode)];
    
    
    _delBarItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMode)];

    

    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 20)];
    [btn2 setImage:[UIImage imageNamed:@"set_up"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setButton=[[UIBarButtonItem alloc]initWithCustomView:btn2];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:setButton,_editBarItem, _delBarItem, nil];

    //[super setNavigationRightBtn:[[UIBarButtonItem alloc] initWithCustomView:btn2]];

    [self initCollection];

    [self initData];

    [self addObserver:NOTIFICATION_UPDATE_FOLDER selector:@selector(selectAllFolders)];
    [self addObserver:NOTIFICATION_UPDATE_SETTING selector:@selector(updateSettingConfig)];
}

- (void)dealloc {
    [self removeObserver];
}

/**
 * 初始化collectionview
 */
- (void)initCollection {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    flowLayout.minimumInteritemSpacing = 1;//内部cell之间距离
    flowLayout.minimumLineSpacing = 5;//行间距

    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 3) / 4, 110);


    self.collectionView = [[UICollectionView alloc]                   initWithFrame:
            CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];

    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    UINib *nib = [UINib nibWithNibName:@"FolderNoteCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];

    [self.view addSubview:self.collectionView];
}

/**
 * 初始化数据
 */
- (void)initData {
    [self updateSettingConfig];

    folderList = [[NSMutableArray alloc] init];
    _folderHelper = [[NoteFolderHelper alloc] init];
    [self selectAllFolders];
}

/**
 * 更新设置配置值
 */
- (void)updateSettingConfig {
    pSwitch = [UserDefaultsUtils getAppInfoForKeyBool:@"p_switch"];
    savePwd = [UserDefaultsUtils getAppInfoForKey:@"pwd"];
}

/**
 * 查询所有分类目录
 */
- (void)selectAllFolders {

    [folderList removeAllObjects];

    [folderList addObjectsFromArray:[_folderHelper selectAllFolders]];
    NoteFolder *defaultFolder = [[NoteFolder alloc] init];
    defaultFolder.id = 0;
    defaultFolder.name = @"添加";
    [folderList addObject:defaultFolder];

    [self.collectionView reloadData];
}

/**
 * 添加和更新目录
 */
- (void)addOrUpdateFolder:(int)id name:(NSString *)name andPrivate:(BOOL)isPrivate {

    // 正常模式
    if (mode == 0) {
        if ([_folderHelper addFolder:name andPrivate:isPrivate]) {
            [Tools showTip:self andMsg:@"添加成功"];

            [self selectAllFolders];

            [self.collectionView reloadData];
        }
        else {
            [Tools showTip:self andMsg:@"添加失败"];
        }
    }
        // 编辑模式
    else if (mode == 1) {
        if ([_folderHelper updateFolder:id name:name andPrivate:isPrivate]) {
            [Tools showTip:self andMsg:@"修改成功"];

            [self selectAllFolders];

            [self.collectionView reloadData];
        }
        else {
            [Tools showTip:self andMsg:@"修改失败"];
        }
    }

}

- (void)navigationRightBtnClick {
    
    
    TFJunYouChat_SettingVc *vc = [[TFJunYouChat_SettingVc alloc] init];
    vc.modalPresentationStyle=UIModalPresentationFullScreen; 
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];;
    [self.navigationController  presentViewController:nav animated:YES completion:nil];
}

- (void)editMode {
    if (mode == 0) {
        mode = 1;
        _editBarItem.title = @"完成";
        _delBarItem.enabled = NO;
    }
    else {
        mode = 0;
        _editBarItem.title = @"编辑";
        _delBarItem.enabled = YES;
    }
    [self.collectionView reloadData];
}

- (void)deleteMode {
    if (mode == 0) {
        mode = 2;
        _delBarItem.title = @"完成";
        _editBarItem.enabled = NO;
    }
    else {
        mode = 0;
        _delBarItem.title = @"删除";
        _editBarItem.enabled = YES;
    }
    [self.collectionView reloadData];
}

/**
 * section
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 * 返回单元格数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return folderList.count;
}

/**
 * 返回一个 单元格布局
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FolderNoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NoteFolder *folder = [folderList objectAtIndex:indexPath.row];
    if (folder.id != 0) {
        cell.imgFolder.image = [UIImage imageNamed:[NSString stringWithFormat:@"folder%d.png", (arc4random() % 11) + 1]];

        // 正常模式下
        if (mode == 0) {
            if (folder.isPrivate) {
                cell.ivPrivate.image = [UIImage imageNamed:@"private.png"];
                cell.ivPrivate.hidden = NO;
            }
            else {
                cell.ivPrivate.hidden = YES;
            }
        }
            // 编辑模式
        else if (mode == 1) {
            cell.ivPrivate.hidden = NO;
            cell.ivPrivate.image = [UIImage imageNamed:@"edit.png"];
        }
            // 删除模式
        else if (mode == 2) {
            cell.ivPrivate.hidden = NO;
            cell.ivPrivate.image = [UIImage imageNamed:@"delete.png"];
        }
    }
    else {
        cell.imgFolder.image = [UIImage imageNamed:@"add.png"];
        cell.ivPrivate.hidden = YES;
    }
    [cell setName:folder.name];
    return cell;
}

/**
 * 单击单元格
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteFolder *folder = [folderList objectAtIndex:indexPath.row];

    // 正常模式
    if (mode == 0) {
        // 添加
        if (folder.id == 0) {
            [self showAddOrUpdateDialog:nil];
        }
        else {
            // 私密开关开启 并且 设置过密码
            if (pSwitch && ![StringUtils isEmpty:savePwd] && folder.isPrivate) {
                [self openPwdInputDialog:nil andOnClicked:nil andCompletion:^(NSString *pwd) {
                    if ([pwd isEqualToString:self->savePwd]) {
                        [self jumpNoteList:folder];
                    }
                    else {
                        [Tools showTip:self andMsg:@"密码不正确"];
                    }
                }];
            }
            else {
                [self jumpNoteList:folder];
            }
        }
    }
        // 编辑模式
    else if (mode == 1) {
        if (folder.id == 0) {
            return;
        }
        // 私密开关开启 并且 设置过密码
        if (pSwitch && ![StringUtils isEmpty:savePwd]) {
            [self openPwdInputDialog:@"" andOnClicked:nil andCompletion:^(NSString *pwd) {
                if ([pwd isEqualToString:self->savePwd]) {
                    [self showAddOrUpdateDialog:folder];
                }
                else {
                    [Tools showTip:self andMsg:@"密码不正确"];
                }
            }];
        }
        else {
            [self showAddOrUpdateDialog:folder];
        }
    }
        // 删除模式
    else if (mode == 2) {
        if (folder.id == 0) {
            return;
        }
        [super openAlertDialog:@"删除分类也即将删除该分类所有记事,确定删除?" onClick:^(void) {
            // 私密开关开启 并且 设置过密码
            if (self->pSwitch && ![StringUtils isEmpty:self->savePwd]) {
                [self openPwdInputDialog:nil andOnClicked:nil andCompletion:^(NSString *pwd) {
                    if ([pwd isEqualToString: self->savePwd]) {
                        [self deleteFolder:folder];
                    }
                    else {
                        [Tools showTip:self andMsg:@"密码不正确"];
                    }
                }];
            }
            else {
                [self deleteFolder:folder];
            }
        }];
    }
}

/**
 * 跳转到note 列表
 */
- (void)jumpNoteList:(NoteFolder *)folder {
    TFJunYouChat_NotesListVc *vc = [[TFJunYouChat_NotesListVc alloc]
            init:folder.id andName:folder.name];
    //[self.navigationController pushViewController:vc animated:true];
    
    
    vc.modalPresentationStyle=UIModalPresentationFullScreen;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];;
    [self.navigationController  presentViewController:nav animated:YES completion:nil];
}

/**
 * 弹出添加目录对话框
 */
- (void)showAddOrUpdateDialog:(NoteFolder *)folder {
    FDAlertView *alert = [[FDAlertView alloc] init];
    AddFolderView *contentView = [[NSBundle mainBundle] loadNibNamed:@"AddFolderView" owner:nil options:nil].lastObject;
    [contentView init:self andFrame:CGRectMake(0, 0, 270, 215) folder:folder];
    alert.contentView = contentView;
    [alert show];
}

/**
 * 删除目录
 */
- (void)deleteFolder:(NoteFolder *)folder {
    @try {
        [_folderHelper deleteFolder:folder.id];
        [Tools showTip:self andMsg:@"删除成功"];
        [folderList removeObject:folder];
        [self.collectionView reloadData];
    }
    @catch (NSException *exception) {
        [Tools showTip:self andMsg:@"删除失败"];
        NSLog(@"Exception occurred: %@, %@", exception, [exception userInfo]);
    }
}

@end


