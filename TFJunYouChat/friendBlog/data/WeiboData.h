#import "Jastor.h"
#import "TFJunYou_ObjUrlData.h"
#import "TFJunYou_WeiboReplyData.h"
#import "MatchParser.h"
#define HBWeiboContentUpdateNofication @"HBWeiboContentUpdateNofication"
#define weibo_dataType_text  1
#define weibo_dataType_image 2
#define weibo_dataType_audio 3
#define weibo_dataType_video 4
#define weibo_dataType_file  5
#define weibo_dataType_share 6
#define weibo_dataFlag_searchJob 1
#define weibo_dataFlag_searchPerson 2
#define weibo_dataFlag_other 3
@interface WeiboData : Jastor<MatchParserDelegate>
{
    int type;
    __weak MatchParser* _match;
}
@property(assign) NSTimeInterval   createTime;
@property(nonatomic,strong) NSMutableArray * gifts;
@property(nonatomic,strong) NSMutableArray * praises;
@property(nonatomic,strong) NSMutableArray * replys;
@property(nonatomic,strong) NSMutableArray * images;
@property(nonatomic,strong) NSMutableArray * smalls;
@property(nonatomic,strong) NSMutableArray * larges;
@property(nonatomic,strong) NSMutableArray * audios;
@property(nonatomic,strong) NSMutableArray * videos;
@property(nonatomic,strong) NSMutableArray * files;
@property(nonatomic,strong) NSString * time;
@property(nonatomic,strong) NSString * address;
@property(nonatomic,strong) NSString * remark;
@property(nonatomic,strong) NSString * messageId;
@property(nonatomic,strong) NSString * userId;
@property(nonatomic,strong) NSString * userNickName;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,copy) NSString * deviceModel;
@property(nonatomic,copy) NSString * location;
@property(nonatomic,strong) NSNumber * longitude;
@property(nonatomic,strong) NSNumber * latitude;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int flag;
@property(nonatomic,assign) int visible;
@property(nonatomic,assign) int loveCount;
@property(nonatomic,assign) int playCount;
@property(nonatomic,assign) int shareCount;
@property(nonatomic,assign) int forwardCount;
@property(nonatomic,assign) int praiseCount;
@property(nonatomic,assign) int commentCount;
@property(nonatomic,assign) int giftCount;
@property(nonatomic,assign) int giftTotalPrice;
@property(nonatomic,assign) BOOL isPraise;
@property(nonatomic,assign) BOOL isCollect;
@property(nonatomic,assign) BOOL isVideo;
@property(nonatomic,assign) int page;  
@property(nonatomic, assign) int isAllowComment; 
@property (nonatomic, copy) NSString *sdkUrl;
@property (nonatomic, copy) NSString *sdkIcon;
@property (nonatomic, copy) NSString *sdkTitle;
@property(nonatomic,strong) NSString * tMans;
@property(nonatomic,readonly) BOOL isGetReply;
@property(nonatomic) int minHeightForComment;
@property(nonatomic) float height;
@property(nonatomic) float heightOflimit;
@property(nonatomic) float miniWidth;
@property(nonatomic) float imageHeight;
@property (nonatomic) float imageWidth;
@property (nonatomic) float fileHeight;
@property (nonatomic) float shareHeight;
@property (nonatomic) float videoHeight;
@property(nonatomic) float replyHeight;
@property(nonatomic) int heightPraise;
@property(nonatomic) int numberOfLinesTotal;
@property(nonatomic) int numberOfLineLimit;
@property(nonatomic) BOOL uploadFailed;
@property(nonatomic) BOOL shouldExtend;
@property(nonatomic) BOOL willDisplay;
@property(nonatomic) BOOL local;
@property(nonatomic,weak,getter =getMatch) MatchParser * match;
@property(nonatomic) int tag;
@property(nonatomic) BOOL linesLimit;
-(void)getWeiboReplysByType:(int)type;
-(void)deleteByReplyId:(NSString*)replyId;
-(void)updateRepleys;
-(MatchParser*)createMatch:(float)width;
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;
-(void)setMatch;
+(NSCache*)shareCacheForWeibo;
-(void)getDataFromDict:(NSDictionary*)dict;
-(NSString*)getLastReplyId:(int)page;
-(NSString*)getAllPraiseUsers;
-(int) heightForReply;
-(int) height2ForReply;
-(NSString*)getMediaURL;
@end
