#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    DownListView_ShowDown = 0,   
    DownListView_ShowUp,
    DownListView_Center,
} TFJunYou__DownListViewShowType;
typedef void(^DownListPopOptionBlock)(NSInteger index, NSString *content);
@interface TFJunYou__DownListView : UIView
@property (nonatomic, strong) NSArray <NSString *>*listContents;   
@property (nonatomic, strong) NSArray <NSString *>*listImages;     
@property (nonatomic, strong) NSArray <NSNumber *>*listEnables;     
@property (nonatomic, strong) UIColor *color;   
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat  lineHeight;       
@property (nonatomic, assign) CGFloat  mutiple;          
@property (nonatomic ,assign) float    animateTime;      
@property (nonatomic, assign) TFJunYou__DownListViewShowType showType; 
@property (nonatomic, strong) UIColor *textColor;   
-(instancetype)downlistPopOption:(DownListPopOptionBlock)block whichFrame:(CGRect)frame animate:(BOOL)animate;
-(void)show;
@end
