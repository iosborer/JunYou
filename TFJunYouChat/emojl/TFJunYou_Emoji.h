#import "TFJunYou_Label.h"
#import <UIKit/UIKit.h>
@interface TFJunYou_Emoji : TFJunYou_Label {
    NSMutableArray *data;
    int _top;
    int _size;
}
@property(nonatomic,assign)int faceHeight;
@property(nonatomic,assign)int faceWidth;
@property(nonatomic,assign)int maxWidth;
@property(nonatomic,assign)int offset;
@property(nonatomic, strong) NSMutableArray* matches;
@property(nonatomic, strong) NSSet* lastTouches;
@property(nonatomic,strong)  NSString * textCopy;
@property(nonatomic,assign)  BOOL contentEmoji;
@property(nonatomic, strong) NSString *atUserIdS;
@property(nonatomic,assign)  BOOL contentAt;
@property (nonatomic, assign) BOOL isShowNumber;
-(void) setText:(NSString *)text;
@end
