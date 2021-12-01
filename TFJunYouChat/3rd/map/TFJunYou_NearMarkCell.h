//
//  TFJunYou_NearMarkCell.h
//  TFJunYouChat
//
//  Created by MacZ on 16/8/25.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TFJunYou_PlaceMarkModel.h"

#define NEAERMAEK_CELL_HEIGHT 50

@interface TFJunYou_NearMarkCell : UITableViewCell

@property (nonatomic,strong) UIImageView *markImgView;
@property (nonatomic,strong) UILabel *markName;
@property (nonatomic,strong) UILabel *markPlace;
@property (nonatomic,strong) UIImageView *selFlag;

- (void)refreshWith:(MKMapItem *)item;

- (void)refreshWithModel:(TFJunYou_PlaceMarkModel *)model;

@end
