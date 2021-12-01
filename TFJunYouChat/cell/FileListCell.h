//
//  fileListCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/6/13.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileListCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;

@end
