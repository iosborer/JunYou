//
//  ImageSelectorCollectionCell.h
//  TFJunYouChat
//
//  Created by 1 on 17/1/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectorCollectionCell : UICollectionViewCell{
    NSInteger indexpath;
    TFJunYou_ImageView* _yellow;
}
@property (nonatomic,assign,setter=setIndex:) long index;
@property (nonatomic,assign,setter=setIsSelected:) BOOL isSelected;
@property (nonatomic,assign,setter=setDelegate:) id        delegate;
@property (nonatomic,strong) TFJunYou_ImageView * imageView;
@property (nonatomic,strong) TFJunYou_ImageView * selectView;
@property (nonatomic, assign) SEL		didImageView;
@property (nonatomic, assign) SEL		didSelectView;

-(void)refreshCellWithImagePath:(NSString *)imagePath;

@end
