#import "JLSingleFaceViewController.h"
#import "JLFacePackgeViewCell.h"
#import "JLFacePackgeViewHeader.h"
#import "JLFacePackgeModel.h"
#import "JLFacePackgeDetailViewController.h"
#import "JLRecommendFacePackgeViewController.h"
#import "RITLPhotos.h"
#import "ImageBrowserViewController.h"
#define cellID @"JLFacePackgeViewCell"
@interface JLSingleFaceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RITLPhotosViewControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *facePackages;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) JLFacePackgeModel *model;
@property (nonatomic, strong) NSMutableString *ids;
@property (nonatomic, strong) NSArray *imgDataArr;
@end
@implementation JLSingleFaceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGotoBack   = YES;
    self.title = @"单个表情 (0/300)";
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    _facePackages = [NSMutableArray array];
    _isEdit = 1;
    _ids = [NSMutableString stringWithString:@""];
    [g_server faceClollectListType:@"1" View:self];
    [self setupUI];
}
- (void)setupUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = @"编辑";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonClick)]];
    label.userInteractionEnabled = YES;
    [self setRightBarButtonItem:item];
    _label = label;
    _model = [[JLFacePackgeModel alloc] init];
    _model.id = @"plusButtonID";
    [self collectionView];
}
- (void)dealwithPlus {
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    photoController.configuration.maxCount = 9;
    photoController.configuration.containVideo = YES;
    photoController.photo_delegate = self;
    photoController.thumbnailSize = CGSizeMake(320, 320);
    [self presentViewController:photoController animated:true completion:^{}];
}
- (void)photosViewController:(UIViewController *)viewController assets:(NSArray <PHAsset *> *)assets {
    self.imgDataArr = assets;
}
#pragma mark - 发送图片
- (void)photosViewController:(UIViewController *)viewController datas:(NSArray <id> *)datas; {
    for (int i = 0; i < datas.count; i++) {
        BOOL isGif = [datas[i] isKindOfClass:[NSData class]];
        if (isGif) {
            NSString *file = [TFJunYou_FileInfo getUUIDFileName:@"gif"];
            [g_server saveDataToFile:datas[i] file:file];
            [self sendImage:file withWidth:0 andHeight:0 userId:nil];
        }else {
            UIImage *chosedImage = datas[i];
            int imageWidth = chosedImage.size.width;
            int imageHeight = chosedImage.size.height;
            NSString *name = @"jpg";
            NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
                [g_server saveImageToFile:chosedImage file:file isOriginal:YES];
                [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:nil];
        }
    }
}
-(void)sendImage:(NSString *)file withWidth:(int) width andHeight:(int) height userId:(NSString *)userId
{
    if ([file length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        msg.fileName     = file;
        msg.content      = [[file lastPathComponent] stringByDeletingPathExtension];
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isUpload     = [NSNumber numberWithBool:NO];
        msg.location_x = [NSNumber numberWithInt:width];
        msg.location_y = [NSNumber numberWithInt:height];
        [g_server uploadFile:file validTime:@"300" messageId:nil toView:self];
    }
}
- (void)rightButtonClick {
    _isEdit = !_isEdit;
    _label.text = _isEdit?@"编辑":@"删除";
    if (_isEdit) {
        [_facePackages insertObject:_model atIndex:0];
    } else {
        [_facePackages removeObject:_model];
    }
    if (_isEdit) {
        [g_notify postNotificationName:@"NOTSELECTED" object:nil];
        NSString *ids = [NSString stringWithString:_ids];
        if ([ids isEqualToString:@""]) {
            [_collectionView reloadData];
            return;
        }
        ids = [ids substringWithRange:NSMakeRange(0, [ids length] - 1)];
        [g_server faceClollectDeleteFaceClollect:ids View:self];
    }
    [_collectionView reloadData];
}
- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if([aDownload.action isEqualToString:act_FaceClollectList]){
        [_facePackages removeAllObjects];
        for (NSDictionary *dict in array1) {
            JLFacePackgeModel *model =[JLFacePackgeModel mj_objectWithKeyValues:dict[@"face"]];
            model.id = dict[@"id"];
            [_facePackages addObject:model];
        }
        self.title = [NSString stringWithFormat:@"单个表情 (%ld/300)", _facePackages.count];
        [_facePackages insertObject:_model atIndex:0];
        [self.collectionView reloadData];
    }
    if([aDownload.action isEqualToString:act_FaceClollectDeleteFaceClollect]){
        [SVProgressHUD setMinimumDismissTimeInterval:2.0];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [g_notify postNotificationName:kFavoritesRefresh object:nil];
        [g_server faceClollectListType:@"1" View:self];
    }
    if([aDownload.action isEqualToString:act_UploadFile]){
        NSString *faceName = dict[@"images"][0][@"oFileName"];
        NSString *url = dict[@"images"][0][@"oUrl"];
        [g_server addFaceClollect:@"" faceName:faceName url:url View:self];
    }
    if([aDownload.action isEqualToString:act_FaceClollectAddFaceClollect]){
        [SVProgressHUD setMinimumDismissTimeInterval:2.0];
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [g_notify postNotificationName:kFavoritesRefresh object:nil];
        [g_notify postNotificationName:@"NOTSELECTED" object:nil];
        [g_server faceClollectListType:@"1" View:self];
    }
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            CGFloat width = self_width / 5;
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
    cell.isSelectedImageHidden = !_isEdit;
    cell.JLFacePackgeViewCellCallBack = ^(NSString * _Nonnull idString, BOOL isSelected) {
        if ([idString isEqualToString:@"plusButtonID"]) {
            [self dealwithPlus];
            return ;
        }
        if (isSelected) {
            if ([_ids containsString:idString]) {
                return;
            }
            [_ids appendString:idString];
            [_ids appendString:@","];
        } else {
            if ([_ids containsString:idString]) {
                [_ids replaceOccurrencesOfString:[NSString stringWithFormat:@"%@,", idString] withString:@"" options:(NSCaseInsensitiveSearch) range:NSMakeRange(0, [_ids length])];
            }
        }
    };
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
}
@end
