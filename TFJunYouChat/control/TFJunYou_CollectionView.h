//
//  TFJunYou_CollectionView.h
//  TFJunYouChat
//
//  Created by MacZ on 2016/10/27.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_TableView.h"

@interface TFJunYou_CollectionView : UICollectionView

- (void)showEmptyImage:(EmptyType)emptyType;
- (void)hideEmptyImage;

@end
