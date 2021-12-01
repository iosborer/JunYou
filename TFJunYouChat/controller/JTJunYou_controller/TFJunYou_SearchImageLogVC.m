//
//  TFJunYou_SearchImageLogVC.m
//  TFJunYouChat
//
//  Created by p on 2019/4/9.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_SearchImageLogVC.h"
#import "TFJunYou_SearchImageLogCell.h"
#import "TFJunYou_MessageObject.h"
#import "ImageBrowserViewController.h"

@interface TFJunYou_SearchImageLogVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TFJunYou_VideoPlayer *player;

@end

@implementation TFJunYou_SearchImageLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    [self createHeadAndFoot];
    
    if (self.isImage) {
        self.title = Localized(@"JX_Image");
    }else {
        self.title = Localized(@"JX_Video");
    }
    
    _array = [NSMutableArray array];
    if (self.isImage) {
        _array = [[TFJunYou_MessageObject sharedInstance] fetchAllMessageListWithUser:self.user.userId withTypes:@[[NSNumber numberWithInt:kWCMessageTypeImage]]];
    }else {
        _array = [[TFJunYou_MessageObject sharedInstance] fetchAllMessageListWithUser:self.user.userId withTypes:@[[NSNumber numberWithInt:kWCMessageTypeVideo]]];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[TFJunYou_CollectionView alloc] initWithFrame:self.tableBody.frame collectionViewLayout:layout];
    _collectionView.backgroundColor = THEMEBACKCOLOR;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TFJunYou_SearchImageLogCell class] forCellWithReuseIdentifier:NSStringFromClass([TFJunYou_SearchImageLogCell class])];
    [self.view addSubview:_collectionView];
}

#pragma mark UICollectionView delegate
#pragma mark-----多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark-----多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _array.count;
}
#pragma mark-----每一个的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    return CGSizeMake((TFJunYou__SCREEN_WIDTH - 30)/2, (TFJunYou__SCREEN_WIDTH - 30)/2 + 50);
    return CGSizeMake((TFJunYou__SCREEN_WIDTH - 20) /4, (TFJunYou__SCREEN_WIDTH - 20) /4);
}
#pragma mark-----每一个边缘留白
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}
#pragma mark-----最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
#pragma mark-----最小竖间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
#pragma mark-----返回每个单元格是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didUnhighlightItemAtIndexPath");
    TFJunYou_SearchImageLogCell *cell = (TFJunYou_SearchImageLogCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"didHighlightItemAtIndexPath");
    TFJunYou_SearchImageLogCell *cell = (TFJunYou_SearchImageLogCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark-----创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TFJunYou_SearchImageLogCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TFJunYou_SearchImageLogCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    TFJunYou_MessageObject *msg = _array[indexPath.row];
    cell.msg = msg;
    
    
    return cell;
}
#pragma mark-----点击单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TFJunYou_MessageObject *msg = _array[indexPath.row];
    
    if ([msg.type integerValue] == kWCMessageTypeVideo) {
        [self showVideoPlayerWithMsg:msg];
    }else {
        [self onDidImageWithMsg:msg];
    }
}
// 显示全屏视频播放
- (void)showVideoPlayerWithMsg:(TFJunYou_MessageObject *)msg {
    _player= [TFJunYou_VideoPlayer alloc];
    _player.type = TFJunYou_VideoTypeChat;
    _player.isShowHide = YES; //播放中点击播放器便销毁播放器
    _player.isStartFullScreenPlay = YES; //全屏播放
    _player.didVideoPlayEnd = @selector(didVideoPlayEnd);
    _player.delegate = self;
    if(msg.isMySend && isFileExist(msg.fileName))
        _player.videoFile = msg.fileName;
    else
        _player.videoFile = msg.content;
    _player = [_player initWithParent:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player switch];
    });
}

#pragma mark-------照片查看
- (void)onDidImageWithMsg:(TFJunYou_MessageObject *)msg{

    //图片路径数组
    NSMutableArray *imagePathArr = [[NSMutableArray alloc]init];
    NSMutableArray *msgArray = [NSMutableArray array];
    if ([msg.isReadDel boolValue] || [msg.content rangeOfString:@".gif"].location != NSNotFound) {//是阅后即焚 gif图片
        [msgArray addObject:msg];
        [imagePathArr addObject:msg.content];
    }else{
        //获取所有聊天记录
        NSString* s = self.user.userId;

        NSArray *arr = [msg fetchImageMessageListWithUser:s];
        NSMutableArray *allChatImageArr = [NSMutableArray array];
        for(NSInteger i=[arr count]-1;i>=0;i--){
            [allChatImageArr addObject:[arr objectAtIndex:i]];
        }
        
        
        for (int i = 0; i < [allChatImageArr count]; i++) {
            TFJunYou_MessageObject * msgP = [allChatImageArr objectAtIndex:i];
            if (![msgP.isReadDel boolValue] && [msgP.content rangeOfString:@".gif"].location == NSNotFound) {//得到的消息中含有阅后即焚 或 gif图片 的剔除掉
                if (msgP.content) {
                    [msgArray addObject:msgP];
                    [imagePathArr addObject:msgP.content];
                }
            }
        }
    }
    
    //查到当前点击的图片的位置
    for (int i = 0; i < [msgArray count]; i++) {
        TFJunYou_MessageObject * msgObj = [msgArray objectAtIndex:i];
        if ([msg.messageId isEqualToString:msgObj.messageId]) {
            
            [ImageBrowserViewController show:self delegate:self isReadDel:[msgObj.isReadDel boolValue] type:PhotoBroswerVCTypeModal contentArray:msgArray index:i imagesBlock:^NSArray *{
                return imagePathArr;
            }];
            
        }
    }
    imagePathArr = nil;
}



//销毁播放器
- (void)didVideoPlayEnd {

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
