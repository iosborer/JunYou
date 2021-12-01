//
//  Placeholderview.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "Placeholderview.h"

@implementation Placeholderview

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //文本内容改变时发布通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textchange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
-(void)textchange
{
    //重新绘制
    [self setNeedsDisplay];
}
//这个方法每次执行会先把之前绘制的去掉
-(void)drawRect:(CGRect)rect
{
    //self.hasText这个是判断textView上是否输入了东东
    if(!self.hasText){
        //文字的属性
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置字体大小
        dict[NSFontAttributeName] = self.font;
        //设置字体颜色
        dict[NSForegroundColorAttributeName] = self.placeColor;
        //画文字(rect是textView的bounds）
        CGRect textRect = CGRectMake(5, 8, rect.size.width-10, rect.size.height-16);
        [self.placeholder drawInRect:textRect withAttributes:dict];
    }
}
@end
