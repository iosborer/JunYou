//
//  TFJunYou_MediaCell.m
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_MediaCell.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_ImageView.h"
#import "AppDelegate.h"
#import "TFJunYou_MediaObject.h"

@implementation TFJunYou_MediaCell
//@synthesize title,subtitle,rightTitle,bottomTitle,headImage,bage,userId;
@synthesize bage;
@synthesize media;
@synthesize delegate;
@synthesize head;
@synthesize pauseBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle  = UITableViewCellSelectionStyleBlue;
        
        UIFont* f0 = g_factory.font15;
//        UIFont* f1 = g_factory.font15b;
        
        int n = 120;
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0,0, TFJunYou__SCREEN_WIDTH, n)];
        v.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.selectedBackgroundView = v;
//        [v release];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,n-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [self.contentView addSubview:line];
//        [line release];

        TFJunYou_Label* lb;
//        lb = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(120, 5, TFJunYou__SCREEN_WIDTH-120-60, 20)];
//        lb.textColor = [UIColor blackColor];
//        lb.userInteractionEnabled = NO;
//        lb.backgroundColor = [UIColor clearColor];
//        lb.font = f1;
//        [self.contentView addSubview:lb];
////        [lb release];
//        [lb setText:[media.fileName lastPathComponent]];
//        lb.backgroundColor = [UIColor redColor];
        
        
        lb = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-60, 5, 50, 20)];
        lb.textColor = [UIColor lightGrayColor];
        lb.userInteractionEnabled = NO;
        lb.backgroundColor = [UIColor clearColor];
        lb.textAlignment = NSTextAlignmentRight;
        lb.font = f0;
        [self.contentView addSubview:lb];
//        [lb release];
        lb.text = [NSString stringWithFormat:@"%d''",[media.timeLen intValue]];
//        lb.backgroundColor = [UIColor magentaColor];
        if ([media.timeLen intValue] <= 0) {
            lb.hidden = YES;
        }
        
        lb = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-130, 95, 120, 20)];
        lb.textColor = [UIColor lightGrayColor];
        lb.userInteractionEnabled = NO;
        lb.backgroundColor = [UIColor clearColor];
        lb.textAlignment = NSTextAlignmentRight;
        lb.font = f0;
        [self.contentView addSubview:lb];
//        [lb release];
        lb.text = [TimeUtil getTimeStrStyle1:[media.createTime timeIntervalSince1970]];
//        lb.backgroundColor = [UIColor cyanColor];
        
        bageImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"little_red_dot"]];
        bageImage.frame = CGRectMake(35, 8-10, 25, 25);
        bageImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bageImage];
//        [bageImage release];
        
        bageNumber=[[UILabel alloc]initWithFrame:CGRectZero];
        bageNumber.userInteractionEnabled = NO;
        bageNumber.frame = CGRectMake(0,0, 25, 25);
        bageNumber.backgroundColor = [UIColor clearColor];
        bageNumber.textAlignment = NSTextAlignmentCenter;
        bageNumber.text  = bage;
        bageNumber.textColor = [UIColor whiteColor];
        bageNumber.font = f0;
        [bageImage addSubview:bageNumber];
//        [bageNumber release];
        
        self.bage = bage;

        TFJunYou_ImageView* iv;
        iv = [[TFJunYou_ImageView alloc]init];
        iv.userInteractionEnabled = YES;
        iv.delegate = delegate;
        iv.didTouch = @selector(actionFullScreen);
        iv.frame = CGRectMake(5,5,110,110);
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        [self.contentView addSubview:iv];
//        [iv release];
        
        iv.image = [TFJunYou_FileInfo getFirstImageFromVideo:media.fileName];
        _player= [[TFJunYou_VideoPlayer alloc] initWithParent:iv];
        _player.videoFile = media.fileName;
        _player.isVideo = media.isVideo;
        _player.timeLen = [media.timeLen intValue];
        
        self.head = iv;
    }
    return self;
}

-(void)dealloc{
    NSLog(@"TFJunYou_MediaCell.dealloc");
    self.media = nil;
    self.delegate = nil;
    self.bage = nil;
//    [_player release];
//    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setBage:(NSString *)s{
    bageImage.hidden = [s intValue]<=0;
    bageNumber.text = s;
    bage = s;
}

@end
