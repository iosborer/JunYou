//
// 笔记列表页面
// Created by yaxiongfang on 4/9/16.
// Copyright (c) 2016 yxfang. All rights reserved.
//

#import "TFJunYouChat_NotesListVc.h"
#import "TFJunYouChat_EditNoteVc.h"
#import "NoteHelper.h"
#import "NoteCell.h"
#import "Note.h"
#import "Tools.h"
@implementation TFJunYouChat_NotesListVc {
    NoteHelper *_noteHelper;
    NSMutableArray *noteList;

    UITableView *_tableView;
}

- (id)init:(int)folderId andName:(NSString *)folderName {
    if ([super init]) {

    }

    self.folderId = folderId;
    self.folderName = folderName;

    return self;
}
- (void)backButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

    
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:self.folderName];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 20)];
    [backButton setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationRightBtnClick)];

    [self initTableView];

    _noteHelper = [[NoteHelper alloc] init];
    [self selectAllNotesByFolderId];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAllNotesByFolderId)
                                                 name:NOTIFICATION_UPDATE_NOTE object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 初始化tableview
 */
- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;

    [self.view addSubview:_tableView];
}

- (void)selectAllNotesByFolderId {
    [noteList removeAllObjects];
    noteList = [_noteHelper selectAllNotes:_folderId];
    [_tableView reloadData];
}

/**
 * 跳转到添加笔记页面
 */
- (void)navigationRightBtnClick {
    TFJunYouChat_EditNoteVc *vc = [[TFJunYouChat_EditNoteVc alloc] init];
    vc.folderId = _folderId;
    //[self.navigationController pushViewController:vc animated:true];
    vc.modalPresentationStyle=UIModalPresentationFullScreen;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];;
    [self.navigationController  presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return noteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"NoteCell";
    //自定义cell类
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil] lastObject];
    }

    Note *note = [noteList objectAtIndex:indexPath.row];

    //添加测试数据
    cell.labelTitle.text = note.title;
    cell.labelContent.text = note.content;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note = [noteList objectAtIndex:indexPath.row];
        if ([_noteHelper delNoteById:note.id]) {
            [Tools showTip:self andMsg:@"删除成功"];

            [noteList removeObjectAtIndex:indexPath.row];

            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            [indexPaths addObject:indexPath];

            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates];
        }
        else {
            [Tools showTip:self andMsg:@"删除失败"];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = [noteList objectAtIndex:indexPath.row];
    TFJunYouChat_EditNoteVc *editNoteViewController = [[TFJunYouChat_EditNoteVc alloc] init];
    editNoteViewController.note = note;
    [self.navigationController pushViewController:editNoteViewController animated:true];
}

@end
