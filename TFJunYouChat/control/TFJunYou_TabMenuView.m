//
//  TFJunYou_TabMenuView.m
//  sjvodios
//
//  Created by daxiong on 13-4-17.
//
//

#import "TFJunYou_TabMenuView.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_TabButton.h"
#import "TFJunYou_BadgeView.h"

@implementation TFJunYou_TabMenuView
@synthesize delegate,items,height,selected,imagesNormal,imagesSelect,onClick,backgroundImageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int width = TFJunYou__SCREEN_WIDTH/[items count];
        height    = 49;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
//        self.image = [UIImage imageNamed:backgroundImageName];

        _arrayBtns = [[NSMutableArray alloc]init];
        
        int i;
        for(i=0;i<[items count];i++){
            CGRect r = CGRectMake(width*i, 0, width, height);
            TFJunYou_TabButton *btn = [TFJunYou_TabButton buttonWithType:UIButtonTypeCustom];
            btn.iconName = [imagesNormal objectAtIndex:i];
            btn.selectedIconName = [imagesSelect objectAtIndex:i];
            btn.text  = [items objectAtIndex:i];
            btn.textColor = HEXCOLOR(0x333333);
            btn.selectedTextColor = THEMECOLOR;
            btn.delegate  = self.delegate;
            btn.onDragout = self.onDragout;
//            if(i==1)
//                btn.bage = @"1";
            btn.frame = r;
            btn.tag = i;
            if ((onClick != nil) && (delegate != nil))
                [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn show];
            btn.lbBage.userInteractionEnabled = NO;
            [self addSubview:btn];
            [_arrayBtns addObject:btn];
        }

        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [self addSubview:line];
//        [line release];
    }
    return self;
}

-(void)dealloc{
//    [_arrayBtns release];
//    [items release];
//    [super dealloc];
}

-(void)onClick:(TFJunYou_TabButton*)sender{
    [self unSelectAll];
    sender.selected = YES;
    self.selected = sender.tag;
	if(self.delegate != nil && [self.delegate respondsToSelector:self.onClick])
		[self.delegate performSelectorOnMainThread:self.onClick withObject:sender waitUntilDone:NO];
}

-(void)unSelectAll{
    for(int i=0;i<[_arrayBtns count];i++){
        ((TFJunYou_TabButton*)[_arrayBtns objectAtIndex:i]).selected = NO;
    }
    selected = -1;
}

-(void)selectOne:(int)n{
    [self unSelectAll];
    if(n >= [_arrayBtns count])
        return;
    ((TFJunYou_TabButton*)[_arrayBtns objectAtIndex:n]).selected=YES;
    selected = n;
}

-(void)setTitle:(int)n title:(NSString*)s{
    if(n >= [_arrayBtns count])
        return;
    [[_arrayBtns objectAtIndex:n] setTitle:s forState:UIControlStateNormal];
}

-(void)setBadge:(int)n title:(NSString*)s{
    if(n >= [_arrayBtns count])
        return;
    TFJunYou_TabButton *btn = [_arrayBtns objectAtIndex:n];
    btn.bage = s;
    btn = nil;
}

@end
