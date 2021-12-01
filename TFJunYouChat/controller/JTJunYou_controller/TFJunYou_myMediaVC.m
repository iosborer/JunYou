//
//  TFJunYou_myMediaVC.h.m
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_myMediaVC.h"
#import "TFJunYou_ChatViewController.h"
#import "AppDelegate.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_ImageView.h"
//#import "TFJunYou_Cell.h"
#import "TFJunYou_RoomPool.h"
#import "TFJunYou_TableView.h"
#import "TFJunYou_NewFriendViewController.h"
#import "menuImageView.h"
#import "TFJunYou_MediaCell.h"
#import "TFJunYou_MediaObject.h"
#import "recordVideoViewController.h"
#import "TFJunYou_CameraVC.h"
#import <photos/PHAssetResource.h>
#import <photos/PHFetchOptions.h>
#import <photos/PHFetchResult.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


#define kCameraVideoPath [TFJunYou_FileInfo getUUIDFileName:@"mp4"]

@interface TFJunYou_myMediaVC ()<TFJunYou_CameraVCDelegate>

@end

@implementation TFJunYou_myMediaVC
@synthesize delegate;
@synthesize didSelect;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = Localized(@"PSMyViewController_MyAtt");
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack   = YES;
        //self.view.frame = g_window.bounds;
        [self createHeadAndFoot];
        self.isShowFooterPull = NO;
//        _table.backgroundColor = HEXCOLOR(0xdbdbdb);
        
        NSString *image = THESIMPLESTYLE ? @"im_003_more_button_black" : @"im_003_more_button_normal";
        UIButton* btn = [UIFactory createButtonWithImage:image
                                               highlight:nil
                                                  target:self
                                                selector:@selector(onAddVideo)];
        btn.custom_acceptEventInterval = 1.f;
        btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-15-18, TFJunYou__SCREEN_TOP-15-18, 18, 18);
        [self.tableHeader addSubview:btn];
        _array=[[NSMutableArray alloc]init];
        [self getVersionVideo];
        if ([[TFJunYou_MediaObject sharedInstance] fetch].count > 0) {
            [_array addObjectsFromArray:[[TFJunYou_MediaObject sharedInstance] fetch]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self scrollToPageUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TFJunYou_MediaCell *cell=nil;
    NSString* cellName = [NSString stringWithFormat:@"msg_%ld",indexPath.row];
//    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        TFJunYou_MediaObject *p=_array[indexPath.row];
        cell = [TFJunYou_MediaCell alloc];
        [_table addToPool:cell];
        cell.media = p;
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_MediaObject *p=_array[indexPath.row];
    if(![[NSFileManager defaultManager] fileExistsAtPath:p.fileName]){
//        [g_App showAlert:Localized(@"JXAlert_NotHaveFile")];
//        return;
    }
    if (delegate && [delegate respondsToSelector:didSelect]) {
//		[delegate performSelector:didSelect withObject:p];
        [delegate performSelectorOnMainThread:didSelect withObject:p waitUntilDone:NO];
        [self actionQuit];
	}    
}

- (void)dealloc {
//    NSLog(@"TFJunYou_myMediaVC.dealloc");
//    [_array release];
//    [super dealloc];
}

-(void)getServerData{
//    if ([[TFJunYou_MediaObject sharedInstance] fetch].count > 0) {
//        [_array addObjectsFromArray:[[TFJunYou_MediaObject sharedInstance] fetch]];
//    }
}

-(void)scrollToPageUp{
    [self stopLoading];
    _refreshCount++;
//    [_array release];

    [self getServerData];
    [_table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)onAddVideo{
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [g_server showMsg:Localized(@"JX_CanNotopenCenmar")];
        return;
    }
    
//    recordVideoViewController * videoRecordVC = [recordVideoViewController alloc];
//    videoRecordVC.maxTime = 30;
//    videoRecordVC.isReciprocal = NO;
//    videoRecordVC.delegate = self;
//    videoRecordVC.didRecord = @selector(newVideo:);
//    videoRecordVC = [videoRecordVC init];
//    [g_window addSubview:videoRecordVC.view];
    
    TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
    vc.cameraDelegate = self;
    vc.maxTime = 30;
    vc.isVideo = YES;
    vc = [vc init];
    [self presentViewController:vc animated:YES completion:nil];
}

// 視屏錄製回調
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithVideoPath:(NSString *)filePath timeLen:(NSInteger)timeLen {
    if( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] )
        return;
    NSString* file = filePath;
    
    TFJunYou_MediaObject* p = [[TFJunYou_MediaObject alloc]init];
    p.userId = g_server.myself.userId;
    p.fileName = file;
    p.isVideo = [NSNumber numberWithBool:YES];
    p.timeLen = [NSNumber numberWithInteger:timeLen];
    [_array insertObject:p atIndex:0];
    [p insert];
    
    [_table reloadData];
}

-(void)newVideo:(recordVideoViewController *)sender;
{
    if( ![[NSFileManager defaultManager] fileExistsAtPath:sender.outputFileName] )
        return;
    NSString* file = sender.outputFileName;
    
    TFJunYou_MediaObject* p = [[TFJunYou_MediaObject alloc]init];
    p.userId = g_server.myself.userId;
    p.fileName = file;
    p.isVideo = [NSNumber numberWithBool:YES];
    p.timeLen = [NSNumber numberWithInt:sender.timeLen];
    [p insert];
//    [p release];

    [self scrollToPageUp];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_MediaObject *p=_array[indexPath.row];
    [p delete];
    p = nil;
    
    [_array removeObjectAtIndex:indexPath.row];
    _refreshCount++;
    [_table reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - 获取本地视频资源
- (void)getVersionVideo {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    // 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
    for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
        // 获取一个资源（PHAsset）
        PHAsset *phAsset = assetsFetchResults[i];
        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            
            [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    //获取视频本地URL
                    NSURL *url = urlAsset.URL;
                    //本地URL存在并且没有保存在数据库
                    if (url && ![[TFJunYou_MediaObject sharedInstance] haveTheMediaWithPhotoPath:url.absoluteString]) {
                        // 获取视频data
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        //获取视频拍摄时间
                        NSDate *date = [self getAudioCreatDate:url];
                        //新建一个路径并写入视频data
                        NSString *dataPath = kCameraVideoPath;
                        [data writeToFile:dataPath atomically:YES];
                        // 获取视频时长
                        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                        NSInteger second = 0;
                        second = (NSInteger)urlAsset.duration.value / urlAsset.duration.timescale;
                        // 主线程更新界面
                        TFJunYou_MediaObject* p = [[TFJunYou_MediaObject alloc] init];
                        p.userId = MY_USER_ID;
                        p.fileName = dataPath;
                        p.isVideo = [NSNumber numberWithBool:YES];
                        p.timeLen = [NSNumber numberWithInteger:second];
                        p.createTime = date;
                        p.photoPath = url.absoluteString;
                        [p insert];
                        [_array insertObject:p atIndex:0];
                        [_table reloadData];
                    }
                });
            }];
        }
    }
}


- (NSDate *)getAudioCreatDate:(NSURL*)URL {
    NSDate *creatDate;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fm attributesOfItemAtPath:URL.path error:nil];
    if (fileAttributes) {
        if ((creatDate = [fileAttributes objectForKey:NSFileCreationDate])) {
            NSLog(@"date = %@",creatDate);
            return creatDate;
        }
    }
    return nil;
}



@end
