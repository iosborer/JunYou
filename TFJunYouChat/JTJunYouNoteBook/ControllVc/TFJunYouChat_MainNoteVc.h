//
//  MainViewController.h
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYouChat_BaseNoteVc.h"

NS_ASSUME_NONNULL_BEGIN
  
@interface TFJunYouChat_MainNoteVc : TFJunYouChat_BaseNoteVc <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

/**
 * 初始化数据
 */
- (void)initData;

/**
 * 添加分类目录
 */
- (void)addOrUpdateFolder:(int)id name:(NSString *)name andPrivate:(BOOL)isPrivate;

@end

NS_ASSUME_NONNULL_END
