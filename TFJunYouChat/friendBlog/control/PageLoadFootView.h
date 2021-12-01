#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol PageLoadFootViewDelegate;
@interface PageLoadFootView : UIView
{
    UIImageView * image;
    UILabel * loadText;
    UILabel * finishText;
    BOOL isLoading;
}
@property(nonatomic,retain) id<PageLoadFootViewDelegate> delegate;
-(void)animmation;
-(void)begin;
-(void)end;
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
-(void) loadFinish;
@end
@protocol PageLoadFootViewDelegate <NSObject>
-(void)footViewBeginLoad:(PageLoadFootView*)footView;
@end