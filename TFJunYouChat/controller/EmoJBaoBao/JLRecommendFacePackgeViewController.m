#import "JLRecommendFacePackgeViewController.h"
#import "JLFacePackgeViewCell.h"
#import "JLFacePackgeViewHeader.h"
#import "JLFacePackgeModel.h"
#import "JLFacePackgeDetailViewController.h"
#import "JLRecommendFacePackgeViewController.h"
#define cellID @"JLFacePackgeViewCell"
@interface JLRecommendFacePackgeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *facePackages;
@end
@implementation JLRecommendFacePackgeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGotoBack   = YES;
    self.title = @"新品推荐";
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    _facePackages = [NSMutableArray array];
    [g_server getFaceList:@"1" View:self];
    [self setupUI];
}
- (void)setupUI {
    [self collectionView];
}
- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if([aDownload.action isEqualToString:act_FaceList]){
        _facePackages = [JLFacePackgeModel mj_objectArrayWithKeyValuesArray:array1];
        [self.collectionView reloadData];
    }
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            CGFloat width = (self_width - 6 * 10)/3;
            layout.itemSize = CGSizeMake(width, width * 4 / 3);
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
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.frame = CGRectMake(0, TFJunYou__SCREEN_TOP, self.view.bounds.size.width, self.view.bounds.size.height-TFJunYou__SCREEN_TOP);
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"JLFacePackgeViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
            [collectionView registerNib:[UINib nibWithNibName:@"JLFacePackgeViewHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JLFacePackgeViewHeaderID"];
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
    JLFacePackgeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = _facePackages[indexPath.row];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        JLFacePackgeViewHeader *view = (JLFacePackgeViewHeader *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JLFacePackgeViewHeaderID" forIndexPath:indexPath];
        headerView = view;
    }
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self_width, 0.5);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JLFacePackgeModel *model = _facePackages[indexPath.row];
    JLFacePackgeDetailViewController *vc = [[JLFacePackgeDetailViewController alloc] init];
    vc.model = model;
    [g_navigation pushViewController:vc animated:YES];
}
@end
