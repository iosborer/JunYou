//
//  TFJunYou_SearchUserListVC.m
//  TFJunYouChat
//
//  Created by p on 2018/4/18.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_SearchUserListVC.h"
#import "TFJunYou_NearCell.h"
#import "TFJunYou_UserInfoVC.h"

@interface TFJunYou_SearchUserListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{

    TFJunYou_CollectionView *_collectionView;
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_refreshFooter;
}
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic,assign)int page;
@property (nonatomic, assign) NSInteger selectNum;
@property (nonatomic, assign) int oldRowCount;
@property (nonatomic, assign) NSTimeInterval lastScrollTime;
@end

@implementation TFJunYou_SearchUserListVC
- (id)init{
    self = [super init];
    if (self) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        
        self.isFreeOnClose = YES;
        
        self.isGotoBack = YES;
        
        _array = [[NSMutableArray alloc] init];
        _page=0;
        
        [g_notify addObserver:self selector:@selector(refreshCallPhone:) name:kNearRefreshCallPhone object:nil];
    }
    return self;
}

- (void)refreshCallPhone:(NSNotification *)notif {
    [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.selectNum inSection:0], nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableBody.backgroundColor = THEMEBACKCOLOR;
    [self createHeadAndFoot];
    [self customView];
    [self getServerData];
}

- (void) customView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[TFJunYou_CollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableBody.frame.size.height)collectionViewLayout:layout];
    _collectionView.frame = self.tableBody.frame;
    _collectionView.backgroundColor = THEMEBACKCOLOR;
    _collectionView.contentSize = CGSizeMake(0, self.tableBody.frame.size.height+10);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TFJunYou_NearCell class] forCellWithReuseIdentifier:NSStringFromClass([TFJunYou_NearCell class])];
    [self.view addSubview:_collectionView];
    _refreshHeader = [MJRefreshHeaderView header];
    _refreshFooter = [MJRefreshFooterView footer];
    [self addRefreshViewWith:_collectionView header:_refreshHeader footer:_refreshFooter];
}

//添加刷新控件
- (void)addRefreshViewWith:(UICollectionView *)collectionView header:(MJRefreshHeaderView *)header footer:(MJRefreshFooterView *)footer{
    header.scrollView = collectionView;
    footer.scrollView = collectionView;
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *baseView){
        [self scrollToPageUp];
        _page = 0;
        //        [self getServerData];
    };
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *baseView){
        [self scrollToPageDown];
        //        [self getServerData];
    };
}
//顶部刷新获取数据
-(void)scrollToPageUp{
    _page = 0;
    [self getServerData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
}

-(void)scrollToPageDown{
    _page++;
    [self getServerData];
}

- (void)stopLoading {
    [_refreshHeader endRefreshing];
    [_refreshFooter endRefreshing];
}

-(void)getServerData{
    [_wait start];
    if (_isUserSearch) {
        [g_server nearbyUser:_search nearOnly:NO lat:0 lng:0 page:_page toView:self];
    }else {
        [g_server searchPublicWithKeyWorld:_keyWorld limit:20 page:_page toView:self];
    }
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
    return CGSizeMake((TFJunYou__SCREEN_WIDTH - 38)/2, (TFJunYou__SCREEN_WIDTH - 38)/2+53);
}
#pragma mark-----每一个边缘留白
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
#pragma mark-----最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}
#pragma mark-----最小竖间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}
#pragma mark-----返回每个单元格是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark-----创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TFJunYou_NearCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TFJunYou_NearCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //        cell.delegate = self;
    //        cell.didTouch = @selector(onHeadImage:);
    //        if (_array.count)
    //            [cell doRefreshNearExpert:[_array objectAtIndex:indexPath.row]];
    if (_array.count) {
        [cell doRefreshNearExpert:[_array objectAtIndex:indexPath.row]];
    }
    //    else if (_selMenu == 2) {
    //        if (_userArray.count) {
    //            [cell doRefreshNearExpert:[_userArray objectAtIndex:indexPath.row]];
    //        }
    //    }
    
    if(indexPath.row == [self collectionView:_collectionView numberOfItemsInSection:indexPath.section]-1){
        
        BOOL flag = YES;
        if(_oldRowCount == [self collectionView:_collectionView numberOfItemsInSection:indexPath.section])//说明翻页之后，数据没有增长，则不再自动翻页，但可手动翻页
            flag = NO;
        
        if([[NSDate date] timeIntervalSince1970]-_lastScrollTime<0.5)//避免刷新过快
            flag = NO;;
        
        if (flag) {
            
            _oldRowCount = (int)[self collectionView:_collectionView numberOfItemsInSection:indexPath.section];
            [self scrollToPageDown];
            _lastScrollTime = [[NSDate date] timeIntervalSince1970];
        }
    }
    
    return cell;
    
}
#pragma mark-----点击单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    [self stopAllPlayer];
    
    self.selectNum = indexPath.row;
    NSDictionary* d;
    d = [_array objectAtIndex:indexPath.row];
//    [g_server getUser:[d objectForKey:@"userId"] toView:self];
    int fromAddType = 0;
    NSString *name = [d objectForKey:@"nickname"];
    if ([name rangeOfString:_keyWorld].location != NSNotFound) {
        fromAddType = 5;
    }else {
        fromAddType = 4;
    }
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId = [d objectForKey:@"userId"];
    vc.fromAddType = fromAddType;
    vc.isShowGoinBtn = YES;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    d = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self stopLoading];
    
    if([aDownload.action isEqualToString:act_nearbyUser] || [aDownload.action isEqualToString:act_nearNewUser]||[aDownload.action isEqualToString:act_PublicSearch]){
        
        if(_page == 0){
            //            [_array removeAllObjects];
            //            [_array addObjectsFromArray:array1];
            [_array removeAllObjects];
            [_array addObjectsFromArray:array1];
        }else{
            if([array1 count]>0){
                [_array addObjectsFromArray:array1];
            }
        }
        if (_array.count <= 0 && !_isUserSearch) {
            [g_App showAlert:Localized(@"JX_NoSuchServerNo.IsAvailable")];
        }
        [_collectionView reloadData];
        
    }else if([aDownload.action isEqualToString:act_UserGet]){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.user       = user;
        vc = [vc init];
        //        [g_window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:YES];
        //        [user release];
    }
    //    else if ([aDownload.action isEqualToString:act_nearNewUser]) {
    //        if (_page == 0) {
    ////            [_array removeAllObjects];
    ////            [_array addObjectsFromArray:array1];
    //            [_userArray removeAllObjects];
    //            [_userArray addObjectsFromArray:array1];
    //        }else{
    //            if ([_userArray count] > 0) {
    //                [_userArray addObjectsFromArray:array1];
    //            }else{
    //                [g_App showAlert:Localized(@"JX_NotMoreData")];
    //                _isNoMoreData = YES;
    //                _search = nil;
    //                _search = [[searchData alloc] init];
    //                _search.minAge = 0;
    //                _search.maxAge = 200;
    //                _search.sex = -1;
    //                _page=0;
    //            }
    //
    //        }
    //        [_collectionView reloadData];
    //    }
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
