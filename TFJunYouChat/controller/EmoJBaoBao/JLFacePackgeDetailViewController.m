#import "JLFacePackgeDetailViewController.h"
#import "JLFacePackgeViewHeader.h"
#import "JLFacePackgeViewCell.h"
#import "JLFacePackgeDetailViewHeader.h"
#define cellID @"JLFacePackgeViewCell"
@interface JLFacePackgeDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *facePackages;
@end
@implementation JLFacePackgeDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGotoBack   = YES;
    self.title = _model.name;
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    _facePackages = [NSMutableArray array];
    [self setupUI];
}
- (void)setupUI {
    [self collectionView];
}
- (void)setModel:(JLFacePackgeModel *)model {
    _model = model;
    [g_server getFaceDetail:model.name View:self];
}
- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if([aDownload.action isEqualToString:act_FaceGetName]){
        _facePackages = [JLFacePackgeModel mj_objectArrayWithKeyValuesArray:array1];
        [self.collectionView reloadData];
    }
    if ([aDownload.action isEqualToString:act_FaceClollectAddFaceClollect]) {
        [g_notify postNotificationName:kEmojiRefresh object:nil];
        [self.collectionView reloadData];
        [SVProgressHUD setMinimumDismissTimeInterval:2.0];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    }
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            CGFloat width = (self_width)/5;
            layout.itemSize = CGSizeMake(width, width);
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
            [collectionView registerNib:[UINib nibWithNibName:@"JLFacePackgeDetailViewHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JLFacePackgeDetailViewHeaderID"];
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
    return _model.path.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLFacePackgeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.path = _model.path[indexPath.row];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 15, 5, 15);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        JLFacePackgeDetailViewHeader *view = (JLFacePackgeDetailViewHeader *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JLFacePackgeDetailViewHeaderID" forIndexPath:indexPath];
        view.model = _model;
        view.JLFacePackgeDetailViewAddCallBack = ^{
            [g_server addFaceClollect:_model.id faceName:_model.name url:@"" View:self];
        };
        headerView = view;
    }
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self_width, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
@end
