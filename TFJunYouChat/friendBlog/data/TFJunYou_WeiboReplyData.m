#import "TFJunYou_WeiboReplyData.h"
#import "NSStrUtil.h"
@implementation TFJunYou_WeiboReplyData
@synthesize height,title,messageId,toUserId,toNickName,toBody,body,userId,userNickName,giftCount,giftId,giftName,giftPrice,addHeight,replyId,createTime,height2;
#pragma -mark 接口方法
-(id)init{
    self = [super init];
    self.userNickName = @"";
    addHeight = 0;
    return self;
}
+(NSString *)getPrimaryKey
{
    return @"replyId";
}
+(NSString *)getTableName
{
    return @"TFJunYou_WeiboReplyData";
}
+(NSCache*)shareCacheForReply
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        cache.totalCostLimit=0.3*1024*1024;
    });
    return cache;
}
-(MatchParser*)getMatch
{
    if (_match) {
        _match.data=self;
        self.height=_match.height;
        return _match;
    }
    NSString *key=[NSString stringWithFormat:@"%@+%f+type:%d",self.body,self.createTime,self.type];
    MatchParser *parser=[[TFJunYou_WeiboReplyData shareCacheForReply] objectForKey:key];
    if (parser) {
        _match=parser;
        self.height=parser.height;
        parser.data=self;
        return parser;
    }else{
        __block MatchParser* parser=nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            parser=[self createMatchType1];
            if (parser) {
                [[TFJunYou_WeiboReplyData shareCacheForReply]  setObject:parser forKey:key];
            }
        });
        return parser;
    }
}
-(MatchParser*)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data
{
    if (_match) {
        _match.data=self;
        self.height=_match.height;
        return _match;
    }
    NSString *key=[NSString stringWithFormat:@"%@+%f+type:%d",self.body,self.createTime,self.type];
    MatchParser *parser=[[TFJunYou_WeiboReplyData shareCacheForReply] objectForKey:key];
    if (parser) {
        _match=parser;
        self.height=parser.height;
        parser.data=self;
        return parser;
    }else{
        __block MatchParser* parser=nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            parser=[self createMatchType1];
            if (parser) {
                self->_match=parser;
                [[TFJunYou_WeiboReplyData shareCacheForReply]  setObject:parser forKey:key];
                complete(parser,data);
            }
        });
        return nil;
    }
}
-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]&&self.title!=nil&&[self.title isKindOfClass:[NSAttributedString class]]) {
        return;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@+%f+type:%d",self.body,self.createTime,self.type];
      MatchParser *parser=[[TFJunYou_WeiboReplyData shareCacheForReply] objectForKey:key];
        if (parser&&self.title!=nil&&[self.title isKindOfClass:[NSAttributedString class]]) {
            _match=parser;
            self.height=parser.height;
            parser.data=self;
        }else{
            __block  MatchParser* parser=nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                parser=[self createMatchType1];
                if (parser) {
                    [[TFJunYou_WeiboReplyData shareCacheForReply]  setObject:parser forKey:key];
                }
                
            });
           
        }
    }
}
-(void)setMatch:(MatchParser *)match
{
    _match=match;
}
-(MatchParser*)createMatchType1
{
    UIFont*font=g_factory.font14;
    CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(font.fontName),font.pointSize,NULL);
    __block NSString*  s ;
     //只留下主线程返回的进度数据
       
        if (self->toNickName) {
            s = [NSString stringWithFormat:@"%@%@%@",self->userNickName,Localized(@"JX_Reply"),self->toNickName];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:s];
            [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x576b95) range:NSMakeRange(0, [self->userNickName length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x576b95) range:NSMakeRange([self->userNickName length] +2, [self->toNickName length])];
            [attributedString addAttribute:NSFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, [s length])];
            self.title = attributedString;
        }else{
            s = [NSString stringWithFormat:@"%@",self->userNickName];
            NSMutableAttributedString * strings=[[NSMutableAttributedString alloc]initWithString:s attributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,HEXCOLOR(0x576b95).CGColor,kCTForegroundColorAttributeName,nil]];
            self.title=strings;
        }
   
   
    CFRelease(fontRef);
#pragma mark -  点赞换行
    return [self createMatch:TFJunYou__SCREEN_WIDTH -117];
}
-(MatchParser*)createMatch:(float)width
{
    if(_match==nil||![_match isKindOfClass:[MatchParser class]]){
        MatchParser * parser=[[MatchParser alloc]init];
        parser.keyWorkColor= [UIColor blueColor];
        parser.font=g_factory.font14;
        parser.width=width;
        NSString* s;
        if(self.type == reply_data_praise)
            s = self.body;
        else
            s = [NSString stringWithFormat:@":%@",self.body];
        [parser match:s atCallBack:^BOOL(NSString * string) {
            return NO;
        }title:self.title];
        _match=parser;
        parser.data=self;
        self.height=parser.height+addHeight;
        return parser;
    }
    return nil;
}
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link
{
    if(_match){
        NSString* s = [NSString stringWithFormat:@":%@",self.body];
        [_match match:s atCallBack:^BOOL(NSString * string) {
            return NO;
        } title:self.title link:link];
    }
}
-(void)getDataFromDict:(NSDictionary*)dict{
    self.userId= [[dict objectForKey:@"userId"] stringValue];
    self.userNickName = [dict objectForKey:@"nickname"];
    self.createTime = [[dict objectForKey:@"time"] longLongValue];
    if(self.type == reply_data_praise){
        self.replyId = [dict objectForKey:@"praiseId"];
    }
    if(self.type == reply_data_gift){
        self.replyId = [dict objectForKey:@"giftId"];
        self.giftCount = [[dict objectForKey:@"count"] stringValue];
        self.giftId = [[dict objectForKey:@"id"] stringValue];
        self.giftPrice = [dict objectForKey:@"price"];
        self.giftName = [dict objectForKey:@"giftId"];
        self.body= [NSString stringWithFormat:@"%@%@",Localized(@"JXLiveVC_Give"),giftName];
    }
    if(self.type == reply_data_comment){
        self.body= [dict objectForKey:@"body"];
        self.replyId= [dict objectForKey:@"commentId"];
        self.toUserId = [[dict objectForKey:@"toUserId"] stringValue];
        self.toBody = [dict objectForKey:@"toBody"];
        self.toNickName = [dict objectForKey:@"toNickname"];
    }
    [self setMatch];
}
-(void)getHeight2{
    if(height2>0)
        return;
    height2 = 15;
    TFJunYou_Emoji* p = [[TFJunYou_Emoji alloc]initWithFrame:CGRectMake(0, 0, 220, 15)];
    p.font = g_factory.font11;
    p.offset = -12;
    p.text = self.body;
    height2 += p.frame.size.height;
    if([toNickName length]>0 && [toUserId length]>0 && [toBody length]>0){
        p.frame = CGRectMake(20, 0, 235,15);
        p.font = g_factory.font11;
        p.offset = -15;
        p.text    = self.toBody;
        height2 += p.frame.size.height;
        height2 += 20;
    }
    if(height2<60)
        height2 = 60;
}
@end
