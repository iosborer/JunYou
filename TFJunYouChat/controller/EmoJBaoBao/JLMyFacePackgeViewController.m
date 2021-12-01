#import "JLMyFacePackgeViewController.h"
#import "JLMyFacePackgeCell.h"
#import "JLMyFacePackgeHeader.h"
#import "JLFacePackgeModel.h"
#import "JLFacePackgeDetailViewController.h"
#import "JLRecommendFacePackgeViewController.h"
#import "JLSingleFaceViewController.h"
#define cellID @"JLMyFacePackgeCell"
@interface JLMyFacePackgeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *facePackages;
@end
@implementation JLMyFacePackgeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGotoBack   = YES;
    self.title = @"我的表情";
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    _facePackages = [NSMutableArray array];
    [g_server faceClollectListType:@"0" View:self];
    [self setupUI]; 
}
- (void)setupUI {
    [self collectionView];
}
- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if([aDownload.action isEqualToString:act_FaceClollectList]){
        NSMutableArray *faceArray = [NSMutableArray array];
        for (NSDictionary *dict in array1) {
            [faceArray addObject:dict[@"face"]];
        }
        _facePackages = [JLFacePackgeModel mj_objectArrayWithKeyValuesArray:faceArray];
        [self.collectionView reloadData];
    }
    if([aDownload.action isEqualToString:act_FaceClollectDeleteByFaceName]){
        [SVProgressHUD setMinimumDismissTimeInterval:2.0];
        [SVProgressHUD showSuccessWithStatus:@"移除成功"];
        [g_notify postNotificationName:kEmojiRefresh object:nil];
        [g_server faceClollectListType:@"0" View:self];
    }
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            CGFloat width = self_width;
            layout.itemSize = CGSizeMake(width, 60);
            layout.footerReferenceSize = CGSizeMake(100, 100);
            layout.sectionFootersPinToVisibleBounds = YES;
            layout.sectionHeadersPinToVisibleBounds = YES;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.minimumInteritemSpacing = 10;
            layout.minimumLineSpacing = 10;
            layout;
        });
        _collectionView = ({
            UICollectionView *collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:244/255.0 alpha:1];
            collectionView.frame = CGRectMake(0, TFJunYou__SCREEN_TOP, self.view.bounds.size.width, self.view.bounds.size.height-TFJunYou__SCREEN_TOP);
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"JLMyFacePackgeCell" bundle:nil] forCellWithReuseIdentifier:cellID];
            [collectionView registerNib:[UINib nibWithNibName:@"JLMyFacePackgeHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JLMyFacePackgeHeader"];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.showsVerticalScrollIndicator = YES;
            collectionView.bounces = NO;
            collectionView;
        });
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _facePackages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLMyFacePackgeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = _facePackages[indexPath.row];
    cell.JLMyFacePackgeCellDeleteCallBack = ^(NSString * _Nonnull faceId) {
        [g_server faceClollectDeleteByFaceName:faceId View:self];
    };
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        JLMyFacePackgeHeader *view = (JLMyFacePackgeHeader *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JLMyFacePackgeHeader" forIndexPath:indexPath];
        view.JLMyFacePackgeHeaderCallBack = ^{
            JLSingleFaceViewController *vc = [[JLSingleFaceViewController alloc] init];
            [g_navigation pushViewController:vc animated:YES];
        };
        headerView = view;
    }
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self_width, 90);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
@end
