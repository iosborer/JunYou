//
//  TFJunYou_MessageObject.m
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "TFJunYou_MessageObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TFJunYou_FriendObject.h"
#import "TFJunYou_BlogObject.h"
#import "NSData+XMPP.h"
#import "TFJunYou_versionManage.h"
//#import "ChatCacheFileUtil.h"
#import "TFJunYou_FileInfo.h"
#import "TFJunYou_RoomRemind.h"
#import "GDataXMLNode.h"
#ifdef Live_Version
#import "TFJunYou_LiveJidManager.h"
#endif

#define SameResource [g_myself.multipleDevices intValue] > 0 ? @"ios" : @"youjob"

#import "TFJunYou_BaseChatCell.h"
#import "TFJunYou_MessageCell.h"
#import "TFJunYou_ImageCell.h"
#import "TFJunYou_FaceCustomCell.h"
#import "TFJunYou_EmojiCell.h"
#import "TFJunYou_FileCell.h"
#import "TFJunYou_VideoCell.h"
#import "TFJunYou_AudioCell.h"
#import "TFJunYou_LocationCell.h"
#import "TFJunYou_CardCell.h"
#import "TFJunYou_RedPacketCell.h"
#import "TFJunYou_RemindCell.h"
#import "TFJunYou_GifCell.h"
#import "TFJunYou_SystemImage1Cell.h"
#import "TFJunYou_SystemImage2Cell.h"
#import "TFJunYou_AVCallCell.h"
#import "TFJunYou_LinkCell.h"
#import "TFJunYou_ShakeCell.h"
#import "TFJunYou_MergeRelayCell.h"
#import "TFJunYou_ShareCell.h"
#import "TFJunYou_TransferCell.h"
#import "TFJunYou_ReplyCell.h"
#import "TFJunYou_UserPublicKeyObj.h"

@implementation TFJunYou_MessageObject
@synthesize content, timeSend,fromUserId,toUserId,type, messageNo, messageId,timeReceive,fileName,fileData,fileSize,location_x,location_y,timeLen,isSend,isRead,progress,dictionary,index,fromUserName,objectId,toUserName,isReceive,fromId,toId,isEncrypt;
@synthesize isUpload;

NSString* current_chat_userId = nil;
NSString* current_meeting_no=nil;

static TFJunYou_MessageObject *shared;

+(TFJunYou_MessageObject*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared=[[TFJunYou_MessageObject alloc]init];

    });
    return shared;
}


-(id)init{
    self = [super init];
    if(self){
        dictionary = [[NSMutableDictionary alloc] init];
        fileData   = nil;
        self.isReceive  = [NSNumber numberWithInt:transfer_status_yes];
        self.isSend     = [NSNumber numberWithInt:transfer_status_yes];
        self.isRead     = [NSNumber numberWithBool:YES];
        self.type       = [NSNumber numberWithInt:0];
        self.isUpload   = [NSNumber numberWithBool:YES];
        self.fromId     = nil;
        self.toId       = nil;
        self.fromUserId = nil;
        self.toUserId   = nil;
        self.location_x = nil;
        self.location_y = nil;
        self.isEncrypt  = nil;
        self.isReadDel  = nil;
        self.readTime   = nil;
        self.readPersons= nil;
        self.chatMsgHeight = nil;
        self.isShowTime = NO;
        self.sendCount  = 0;
        self.isDelay    = 0;
        self.updateLastContent = 1;
        _isGroup = NO;
        _isMySend = 0;
        self.signature = nil;
        self.isVerifySignatureFailed = nil;
    }
    return self;
}

-(void)dealloc{
//    NSLog(@"TFJunYou_MessageObject.dealloc");
    [dictionary removeAllObjects];
    //    [dictionary release];
    
    self.fromUserId = nil;
    self.toUserId = nil;
    self.content = nil;
    self.timeSend = nil;
    self.timeReceive = nil;
    self.type = nil;
    self.messageNo = nil;
    self.messageId = nil;
    self.fileName = nil;
    self.fileSize = nil;
    self.fileData = nil;
    self.location_x = nil;
    self.location_y = nil;
    self.isSend = nil;
    self.isRead = nil;
    self.timeLen = nil;
    self.isReceive = nil;
    self.isUpload = nil;
    self.imageHeight = nil;
    self.imageWidth = nil;
    self.deleteTime = nil;
    //    [downloads release];
    
    //    [super dealloc];
}

-(void)fromDictionary:(NSMutableDictionary*)p
{
    if(p==nil) p = dictionary;
    NSDateFormatter* f=[[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    self.fromUserId = [NSString stringWithFormat:@"%@",[p objectForKey:kMESSAGE_FROM]];
    self.toUserId = [NSString stringWithFormat:@"%@",[p objectForKey:kMESSAGE_TO]];
    self.fromUserName = [p objectForKey:kMESSAGE_FROM_NAME];
    self.toUserName = [p objectForKey:kMESSAGE_TO_NAME];
    if ([p objectForKey:@"to"]) {
        self.toId = [p objectForKey:@"to"];
    }
    
    if ([p objectForKey:kMESSAGE_ID]) {
        self.messageId = [p objectForKey:kMESSAGE_ID];
    }
    
    NSDictionary *messageHead = [p objectForKey:@"messageHead"];
    if ([messageHead objectForKey:kMESSAGE_ID]) {
        self.messageId = [messageHead objectForKey:kMESSAGE_ID];
    }
    
    if ([p objectForKey:kMESSAGE_isReadDel]) {
        self.isReadDel = [p objectForKey:kMESSAGE_isReadDel];
    }else{
        self.isReadDel = [NSNumber numberWithInt:NO];
    }
    //    self.timeReceive = [f dateFromString:[p objectForKey:kMESSAGE_TIMERECEIVE]];
    self.timeSend = [NSDate dateWithTimeIntervalSince1970:[[p objectForKey:kMESSAGE_TIMESEND] doubleValue]];
    self.deleteTime = [NSDate dateWithTimeIntervalSince1970:[[p objectForKey:kMESSAGE_DELETETIME] doubleValue]];
    
    NSString * messCont = [p objectForKey:kMESSAGE_CONTENT];
    
    self.isEncrypt = [p objectForKey:kMESSAGE_isEncrypt];
    if (self.isEncrypt == nil) {
        self.isEncrypt = [NSNumber numberWithBool:NO];
    }
   
    self.timeReceive = [NSDate dateWithTimeIntervalSince1970:[[p objectForKey:kMESSAGE_TIMERECEIVE] longLongValue]];
    self.type = [p objectForKey:kMESSAGE_TYPE];
    self.messageNo = [p objectForKey:kMESSAGE_No];
    self.fileName = [p objectForKey:kMESSAGE_FILENAME];
    self.fileData = [NSData dataWithBase64EncodedString:[p objectForKey:kMESSAGE_FILEDATA]];
    //    [fileData release];
    self.location_x = [p objectForKey:kMESSAGE_LOCATION_X];
    self.location_y = [p objectForKey:kMESSAGE_LOCATION_Y];
    self.timeLen = [p objectForKey:kMESSAGE_TIMELEN];
    self.fileSize = [p objectForKey:kMESSAGE_FILESIZE];
    self.objectId = [p objectForKey:kMESSAGE_OBJECTID];
    
    //放入图片宽高
    //    self.location_x = [p objectForKey:KMESSAGE_imHeight];
    //    self.location_y = [p objectForKey:kMESSAGE_imWidth];
    
    self.isReceive = [NSNumber numberWithInt:transfer_status_yes];
    self.isSend = [NSNumber numberWithInt:transfer_status_yes];
    self.isRead = [p objectForKey:kMESSAGE_ISREAD];
    if (self.isRead == nil) {
        self.isRead = [NSNumber numberWithBool:NO];
    }
    self.isUpload = [NSNumber numberWithBool:YES];
    
    self.readPersons = [p objectForKey:kMESSAGE_readPersons];
    self.readTime = [NSDate dateWithTimeIntervalSince1970:[[p objectForKey:kMESSAGE_readTime] longValue]];
    self.chatMsgHeight = [p objectForKey:kMESSAGE_chatMsgHeight];
    self.isShowTime = [[p objectForKey:kMESSAGE_isShowTime] boolValue];
    self.isVerifySignatureFailed = [p objectForKey:kMESSAGE_isVerifySignatureFailed];
    
    // 其他的一些群设置
    self.other = [p objectForKey:@"other"];
    //    [f release];
    
    
    
    
#ifdef IS_MsgEncrypt
    
    // 消息验签字段
    self.signature = [p objectForKey:@"signature"];
    // 从朋友表拿出好友DH公钥
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance]getUserById:self.fromUserId];
    if ([self.fromUserId isEqualToString:MY_USER_ID] || self.isGroup) {
        user = [[TFJunYou_UserObject sharedInstance]getUserById:self.toUserId];
    }
    
    if (self.isGroup) {
        if (!user.roomId || user.roomId.length <= 0 || messCont.length <= 0 || !messCont) {
            return;
        }
        NSString *chatKeyGroup = [g_msgUtil decryptRoomMsgKey:user.roomId randomKey:user.chatKeyGroup];
        
        NSData *contentData = [[NSData alloc] initWithBase64EncodedString:messCont options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *deContentData = [AESUtil decryptAESData:contentData key:[chatKeyGroup dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *deContent = [[NSString alloc] initWithData:deContentData encoding:NSUTF8StringEncoding];
        

        NSString *signature = [g_msgUtil getRoomMsgMacWithContent:messCont fromUserId:fromUserId isEncrypt:[isEncrypt integerValue] msgId:messageId randomKey:chatKeyGroup];
        
        if ([signature isEqualToString:self.signature]) {
            // 验签成功
            self.content = deContent;
        }else {
            self.isVerifySignatureFailed = [NSNumber numberWithBool:YES];   // 将消息标明为验签失败消息
            
            // 将消息放入缓存队列
            NSMutableArray *arr = [g_msgUtil.verifyFailedDic objectForKey:user.userId];
            if (!arr) {
                arr = [NSMutableArray array];
            }
            
            self.content = messCont;
            
            TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
            [msg copy:self];
            
            [arr addObject:msg];
            [g_msgUtil.verifyFailedDic setObject:arr forKey:user.userId];
            
            if (![g_msgUtil.getDHListIds containsObject:user.userId]) {
                
                [g_msgUtil.getDHListIds addObject:user.userId];
                // 获取服务器公钥表
                [g_msgUtil getDHPublicKeyWithUserId:user.userId];
            }
        }
    }else {
        if (user.publicKeyDH && user.publicKeyDH.length > 0) {
            // 签名
            NSString *signature = [g_msgUtil getChatMsgMacWithContent:messCont fromUserId:fromUserId toUserId:toUserId isEncrypt:[isEncrypt integerValue] msgId:messageId publicKey:user.publicKeyDH];
            if ([signature isEqualToString:self.signature]) {
                // 验签成功
                self.content = [g_msgUtil decryptContentWithPublicKey:user.publicKeyDH content:messCont msgId:self.messageId];
            }else { // 验签失败
                
                // 获取好友公钥表
                NSMutableArray *keys = [[TFJunYou_UserPublicKeyObj sharedManager] fetchPublicKeyWithUserId:user.userId];
                BOOL flag = NO;
                // 公钥表里公钥依次解密
                for (NSInteger i = 0; i < keys.count; i ++) {
                    TFJunYou_UserPublicKeyObj *obj = keys[i];
                    if (obj.publicKey && obj.publicKey.length > 0) {
                        NSString *signature = [g_msgUtil getChatMsgMacWithContent:messCont fromUserId:fromUserId toUserId:toUserId isEncrypt:[isEncrypt integerValue] msgId:messageId publicKey:obj.publicKey];
                        if ([signature isEqualToString:self.signature]) {
                            flag = YES;
                            self.content = [g_msgUtil decryptContentWithPublicKey:obj.publicKey content:messCont msgId:self.messageId];
                            break;
                        }
                    }
                }
                
                if (!flag) {    // 解密失败，调用获取服务器公钥表接口
                    self.isVerifySignatureFailed = [NSNumber numberWithBool:YES];   // 将消息标明为验签失败消息
                    
                    // 将消息放入缓存队列
                    NSMutableArray *arr = [g_msgUtil.verifyFailedDic objectForKey:user.userId];
                    if (!arr) {
                        arr = [NSMutableArray array];
                    }
                    
                    self.content = messCont;
                    
                    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
                    [msg copy:self];
                    
                    [arr addObject:msg];
                    [g_msgUtil.verifyFailedDic setObject:arr forKey:user.userId];
                    
                    if (![g_msgUtil.getDHListIds containsObject:user.userId]) {
                        
                        [g_msgUtil.getDHListIds addObject:user.userId];
                        // 获取服务器公钥表
                        [g_msgUtil getDHPublicKeyWithUserId:user.userId];
                    }
                    
                }
            }
        }else { // 朋友表没有此用户公钥
            
            if (user) {
                self.isVerifySignatureFailed = [NSNumber numberWithBool:YES];   // 将消息标明为验签失败消息
                
                // 将消息放入缓存队列
                NSMutableArray *arr = [g_msgUtil.verifyFailedDic objectForKey:user.userId];
                if (!arr) {
                    arr = [NSMutableArray array];
                }
                
                self.content = messCont;
                
                TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
                [msg copy:self];
                
                [arr addObject:msg];
                [g_msgUtil.verifyFailedDic setObject:arr forKey:user.userId];
                
                if (![g_msgUtil.getDHListIds containsObject:user.userId]) {
                    
                    [g_msgUtil.getDHListIds addObject:user.userId];
                    // 获取服务器公钥表
                    [g_msgUtil getDHPublicKeyWithUserId:user.userId];
                }
            }else {
                self.content = messCont;
            }
            
        }
    }
    
    
    
#else
    if ([self.isEncrypt boolValue]) {
        //        self.content = [DESUtil decryptDESStr:messCont key:[NSString stringWithFormat:@"%@",[p objectForKey:kMESSAGE_TIMESEND]]];
        NSMutableString *str = [NSMutableString string];
        [str appendString:APIKEY];
        [str appendString:[NSString stringWithFormat:@"%ld",(long)[self.timeSend timeIntervalSince1970]]];
        [str appendString:self.messageId];
        NSString *keyStr = [g_server getMD5String:str];
        self.content = [DESUtil decryptDESStr:messCont key:keyStr];
        if (IsStringNull(self.content)) {
            self.content = messCont;
        }
        
    }else{
        self.content = messCont;
    }
#endif
}

- (void)fromXmlDict:(NSDictionary *)xmlDict{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    //body
    NSString * repr = [xmlDict objectForKey:@"body"];
    //&quot;替换成\"
    repr = [repr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSDictionary *bodyDict = [parser objectWithString:repr];
    
    //message
    NSString * reprM = [xmlDict objectForKey:@"message"];
    //&quot;替换成\"
    reprM = [reprM stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    GDataXMLElement * xmlElement = [[GDataXMLElement alloc]initWithXMLString:reprM error:nil];
    NSString * xmlFrom = [[[xmlElement attributeForName:@"from"] stringValue]componentsSeparatedByString:@"@"][0];
    NSString * xmlTo = [[[xmlElement attributeForName:@"to"] stringValue]componentsSeparatedByString:@"@"][0];
    
    
    if (xmlDict[@"messageId"]) {
        self.messageId = xmlDict[@"messageId"];
    }
    [self fromDictionary:bodyDict];
    if (xmlFrom) {
        if (!self.fromUserId || self.fromUserId.length <= 0) {
            self.fromUserId = [NSString stringWithFormat:@"%lld",[xmlFrom longLongValue]];
        }
    }
    if (xmlTo) {
        if (!self.toUserId || self.toUserId.length <= 0) {
            self.toUserId = [NSString stringWithFormat:@"%lld",[xmlTo longLongValue]];
        }
    }
}

// 群聊
-(void)fromGroupXmlDict:(NSDictionary *)xmlDict {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    //body
    NSString * repr = [xmlDict objectForKey:@"body"];
    //&quot;替换成\"
    repr = [repr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSDictionary *bodyDict = [parser objectWithString:repr];
    
    [self fromDictionary:bodyDict];
    
}

//将对象转换为字典
-(NSMutableDictionary*)toDictionary
{
    NSDateFormatter* f=[[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //离线消息，单聊时ID可能在<message>里传过来，但群聊的离线或者历史消息，<Message>的ID为NULL
    //方案：单聊的messageId放在<message>的ID里,群聊除此之外，messageId也放在<body>的MessageID里
    if(self.messageId.length > 0)
        [dictionary setValue:messageId forKey:kMESSAGE_ID];
    [dictionary setValue:fromUserName forKey:kMESSAGE_FROM_NAME];
    [dictionary setValue:toUserName forKey:kMESSAGE_TO_NAME];
    [dictionary setValue:[NSNumber numberWithDouble:[self.timeSend timeIntervalSince1970]] forKey:kMESSAGE_TIMESEND];
    [dictionary setValue:[NSNumber numberWithLongLong:[self.deleteTime timeIntervalSince1970]] forKey:kMESSAGE_DELETETIME];
    [dictionary setValue:type forKey:kMESSAGE_TYPE];
//    if([self getIsGroup])
    [dictionary setValue:fromUserId forKey:kMESSAGE_FROM];
    [dictionary setValue:toUserId forKey:kMESSAGE_TO];

    if(self.fileData)
        [dictionary setValue:[fileData xmpp_base64Encoded] forKey:kMESSAGE_FILEDATA];
    if(self.objectId)
        [dictionary setValue:objectId forKey:kMESSAGE_OBJECTID];
    if(self.fileName)
        [dictionary setValue:fileName forKey:kMESSAGE_FILENAME];
    if(self.fileSize)
        [dictionary setValue:fileSize forKey:kMESSAGE_FILESIZE];
    if(self.location_x)
        [dictionary setValue:location_x forKey:kMESSAGE_LOCATION_X];
    if(self.location_y)
        [dictionary setValue:location_y forKey:kMESSAGE_LOCATION_Y];
    if(self.timeLen)
        [dictionary setValue:timeLen forKey:kMESSAGE_TIMELEN];
    if ([self.isReadDel boolValue])
        [dictionary setObject:_isReadDel forKey:kMESSAGE_isReadDel];
    if (self.isShowTime) {
        [dictionary setObject:[NSNumber numberWithBool:self.isShowTime] forKey:kMESSAGE_isShowTime];
    }
    
#ifdef IS_MsgEncrypt
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance]getUserById:toUserId];
    if (self.isGroup) {
        
        NSString *chatKeyGroup = [g_msgUtil decryptRoomMsgKey:user.roomId randomKey:user.chatKeyGroup];
        NSData *encryptData = [AESUtil encryptAESData:[content dataUsingEncoding:NSUTF8StringEncoding] key:[chatKeyGroup dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *encryptStr = [encryptData base64EncodedStringWithOptions:0];
        NSString *signature = [g_msgUtil getRoomMsgMacWithContent:encryptStr fromUserId:fromUserId isEncrypt:[isEncrypt integerValue] msgId:messageId randomKey:chatKeyGroup];
        
        [dictionary setValue:encryptStr forKey:kMESSAGE_CONTENT];
        [dictionary setValue:signature forKey:kMESSAGE_signature];
        
    }else {
        if (user.publicKeyDH && user.publicKeyDH.length > 0) {
            NSString *encryptStr = [g_msgUtil encryptContentWithPublicKey:user.publicKeyDH content:content msgId:messageId ];
            NSString *signature = [g_msgUtil getChatMsgMacWithContent:encryptStr fromUserId:fromUserId toUserId:toUserId isEncrypt:[isEncrypt integerValue] msgId:messageId publicKey:user.publicKeyDH];
            
            [dictionary setValue:encryptStr forKey:kMESSAGE_CONTENT];
            [dictionary setValue:signature forKey:kMESSAGE_signature];
        }
    }
    
    
    
#else
    if([self.isEncrypt boolValue]){
        [dictionary setValue:isEncrypt forKey:kMESSAGE_isEncrypt];
        //        NSString * keyStr = [NSString stringWithFormat:@"%f",[self.timeSend timeIntervalSince1970]];
        NSMutableString *str = [NSMutableString string];
        [str appendString:APIKEY];
        [str appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:[self.timeSend timeIntervalSince1970]]]];
        [str appendString:self.messageId];
        NSString *keyStr = [g_server getMD5String:str];

        [dictionary setValue:[DESUtil encryptDESStr:content key:keyStr] forKey:kMESSAGE_CONTENT];
    }
    else
        [dictionary setValue:content forKey:kMESSAGE_CONTENT];
    
#endif
    
    if (self.timeReceive) {
        [dictionary setValue:[NSNumber numberWithDouble:[self.timeReceive timeIntervalSince1970]] forKey:kMESSAGE_TIMERECEIVE];
    }
    if ([self.isRead boolValue])
        [dictionary setObject:self.isRead forKey:kMESSAGE_ISREAD];
    if ([self.isSend boolValue])
        [dictionary setObject:self.isSend forKey:kMESSAGE_ISSEND];
    if ([self.isReceive boolValue])
        [dictionary setObject:self.isReceive forKey:kMESSAGE_isReceive];
    if ([self.isUpload boolValue])
        [dictionary setObject:[NSNumber numberWithInt:[self.isUpload intValue]] forKey:kMESSAGE_isUpload];
    if (self.fromId)
        [dictionary setObject:self.fromId forKey:kMESSAGE_FROMID];
    if (self.toId)
        [dictionary setObject:self.toId forKey:kMESSAGE_TOID];
    if (self.readPersons)
        [dictionary setObject:self.readPersons forKey:kMESSAGE_readPersons];
    if (self.readTime) {
        [dictionary setValue:[NSNumber numberWithDouble:[self.readTime timeIntervalSince1970]] forKey:kMESSAGE_readTime];
    }
    if (self.chatMsgHeight) {
        [dictionary setObject:self.chatMsgHeight forKey:kMESSAGE_chatMsgHeight];
    }
    if (self.isShowTime)
        [dictionary setObject:[NSNumber numberWithBool:self.isShowTime] forKey:kMESSAGE_isShowTime];
    if (self.isGroup)
        [dictionary setObject:[NSNumber numberWithBool:self.isGroup] forKey:@"isGroup"];
    if ([self.isVerifySignatureFailed boolValue]) {
        [dictionary setObject:self.isVerifySignatureFailed forKey:kMESSAGE_isVerifySignatureFailed];
    }
    
    return dictionary;
}

-(void)fromRs:(FMResultSet*)rs{
    self.fromUserId = [rs stringForColumn:kMESSAGE_FROM];
    self.fromUserName = [rs stringForColumn:kMESSAGE_FROM_NAME];
    self.toUserId = [rs stringForColumn:kMESSAGE_TO];
    self.content = [rs stringForColumn:kMESSAGE_CONTENT];
    self.timeSend = [rs dateForColumn:kMESSAGE_TIMESEND];
    self.deleteTime = [rs dateForColumn:kMESSAGE_DELETETIME];
    self.timeReceive = [rs dateForColumn:kMESSAGE_TIMERECEIVE];
    self.type = [rs objectForColumnName:kMESSAGE_TYPE];
    
    
    self.messageId = [rs stringForColumn:kMESSAGE_ID];
    self.messageNo = [rs objectForColumnName:kMESSAGE_No];
    self.fileName = [rs stringForColumn:kMESSAGE_FILENAME];
    
    
    if([rs objectForColumnName:kMESSAGE_FILEDATA] != [NSNull null]){
        self.fileData = [NSData dataWithBase64EncodedString:[rs objectForColumnName:kMESSAGE_FILEDATA]];
        //        [self.fileData release];
    }
    
    //聊天图片宽高
    //    self.location_x = [rs objectForColumnName:kMESSAGE_imWidth];
    //    self.location_y = [rs objectForColumnName:KMESSAGE_imHeight];
    
    
    
    self.location_x = [rs objectForColumnName:kMESSAGE_LOCATION_X];
    self.location_y = [rs objectForColumnName:kMESSAGE_LOCATION_Y];
    self.isSend = [rs objectForColumnName:kMESSAGE_ISSEND];
    self.isRead = [rs objectForColumnName:kMESSAGE_ISREAD];
    self.timeLen = [rs objectForColumnName:kMESSAGE_TIMELEN];
    self.fileSize = [rs objectForColumnName:kMESSAGE_FILESIZE];
    self.objectId = [rs stringForColumn:kMESSAGE_OBJECTID];
    self.isReceive = [rs objectForColumnName:kMESSAGE_isReceive];
    self.isUpload = [rs objectForColumnName:kMESSAGE_isUpload];
    self.isReadDel = [NSNumber numberWithBool:[rs boolForColumn:kMESSAGE_isReadDel]];
    self.isGroup   = [self getIsGroup];
//    if([isSend intValue]==transfer_status_ing)
//        self.isSend = [NSNumber numberWithInt:transfer_status_no];
    if([isReceive intValue]==transfer_status_ing)
        self.isReceive = [NSNumber numberWithInt:transfer_status_no];

    self.fromId = [rs stringForColumn:@"fromId"];
    self.toId = [rs stringForColumn:@"toId"];
    
    self.readPersons = [rs objectForColumnName:kMESSAGE_readPersons];
    self.readTime = [rs dateForColumn:kMESSAGE_readTime];
    self.chatMsgHeight = [rs stringForColumn:kMESSAGE_chatMsgHeight];
    self.isShowTime = [rs boolForColumn:kMESSAGE_isShowTime];
    self.signature = [rs stringForColumn:kMESSAGE_signature];
    self.isVerifySignatureFailed = [rs objectForColumnName:kMESSAGE_isVerifySignatureFailed];

#ifdef IS_MsgEncrypt
//    if (!self.isGroup) {
        self.content = [g_msgUtil decryptInsertChatMsgContent:self.content msgId:self.messageId];
//    }
#endif
}

-(BOOL)delete{
    NSString* sql= [NSString stringWithFormat:@"delete from msg_%@ where messageId=?",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,self.messageId];
    
    [g_App copyDbWithUserId:MY_USER_ID];    
    return worked;
}

-(BOOL)deleteAll{
    NSString* sql= [NSString stringWithFormat:@"delete from msg_%@",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql];
    return worked;
}

-(BOOL)deleteWithFromUser:(NSString*)userId roomId:(NSString*)roomId{
    NSString* sql= [NSString stringWithFormat:@"delete from msg_%@ where fromUserId=?",roomId];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,userId];
    return worked;
}

//增删改查
-(BOOL)insert:(NSString*)room
{
    
    if(self.isMySend){//发送
        
        if ([self.isSend integerValue] == 0) {
            // 消息发送时间更新
            NSTimeInterval time = [self.timeSend timeIntervalSince1970];
            self.timeSend = [NSDate dateWithTimeIntervalSince1970:(time *1000 + g_server.timeDifference)/1000];
        }

        TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:self.toUserId];
        if ([user.chatRecordTimeOut doubleValue] <= 0) {
            self.deleteTime = nil;
        }else {
            double n = [user.chatRecordTimeOut doubleValue] * 24 * 3600;
            double m = [[NSDate date] timeIntervalSince1970];
            self.deleteTime = [NSDate dateWithTimeIntervalSince1970:n + m];
        }
        
        if([self isRoomControlMsg]){
            room = self.objectId;
            if ([self.type intValue] == kRoomRemind_NeedVerify) {
                SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
                NSDictionary *resultObject = [resultParser objectWithString:self.objectId];
                if (resultObject) {
                    room = [resultObject objectForKey:@"roomJid"];
                }
            }
            
            // 重复收到控制消息不做处理
            if ([self getMsgWithMsgId:self.messageId toUserId:room]) {
                return NO;
            }
            [self doReceiveRoomRemind];//必须在前面
            if (![self doNewRemindMsg]) {
                return NO;
            }

        }
        if([messageId length]<=0){
            [self setMsgId];
            if (!self.isGroup) {
                self.fromUserName = MY_USER_NAME;
            }
        }
        // 发送的阅后即焚情况下的截屏消息不存到数据库
        if ([self.type intValue] == kWCMessageTypeDelMsgScreenshots) {
            return NO;
        }
    }else{//接收
        if([self isRoomControlMsg]){
            
            room = self.objectId;
            if ([self.type intValue] == kRoomRemind_NeedVerify) {
                SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
                NSDictionary *resultObject = [resultParser objectWithString:self.objectId];
                if (resultObject) {
                    room = [resultObject objectForKey:@"roomJid"];
                }
            }
            
            // 重复收到控制消息不做处理
            if ([self getMsgWithMsgId:self.messageId toUserId:room]) {
                return NO;
            }
            
            [self doReceiveRoomRemind];//必须在前面
            NSNumber *type = self.type;
            if (![self doNewRemindMsg]) {
                return NO;
            }

            room = self.objectId;
            if ([type intValue] == kRoomRemind_NeedVerify) {
                SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
                NSDictionary *resultObject = [resultParser objectWithString:self.objectId];
                if (resultObject) {
                    room = [resultObject objectForKey:@"roomJid"];
                }
            }
        }
        if([self.type intValue]==kWCMessageTypeTransferReceive){// 转账被领取
            self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
            
            TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
            msg.objectId = self.content;
            msg.toUserId = self.fromUserId;
            NSMutableArray *msgs = [msg getMsgWithObjectId:msg.objectId];
            for (int i = 0; i < msgs.count; i++) {
                TFJunYou_MessageObject *msg1 = msgs[i];
                msg1.fileSize = [NSNumber numberWithInt:2];
                [msg1 updateFileSize];
            }

            [g_notify postNotificationName:kUpdateTransferMsgFileSize object:self.content];
            self.content = [NSString stringWithFormat:@"%@%@",self.fromUserName,Localized(@"JX_ReceivedYourTransfer")];
            self.isShowRemind = YES;
        }
        if([self.type intValue]==kWCMessageTypeTransferBack){// 转账被退回
//            self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
//            self.content = [NSString stringWithFormat:@"%@%@",self.fromUserName,@"转账过期，金额已退回零钱"];
//            self.isShowRemind = YES;
        }
        if([self.type intValue]==kWCMessageTypeRedPacketReceive){// 红包被领取
            if ([self.toUserId isEqualToString:self.fromUserId]) {
                return NO;
            }
            self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
            self.isShowRemind = YES;
            if(self.objectId.length > 0){//群聊红包
                self.toUserId = self.objectId;
                room = self.objectId;
                self.isGroup = YES;
            }
            self.objectId = self.content;
            NSString *overStr = [NSString string];
            if ([self.fileSize intValue] == 1) {
                
                overStr = [NSString stringWithFormat:Localized(@"JX_,YourRedEnvelopeIsAt%@"),[self getTimeForRow:self.fileName overTime:self.timeSend]];
            }
            self.content = [NSString stringWithFormat:@"%@%@%@",self.fromUserName,Localized(@"JXRed_whoGet"),overStr];
        }
        if([self.type intValue]==kWCMessageTypeRedPacketReturn){// 红包退回
            self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
            self.isShowRemind = YES;
            if(self.objectId.length > 0){//群聊红包
                self.toUserId = self.objectId;
                room = self.objectId;
                self.isGroup = YES;
            }
            self.objectId = self.content;
            self.content = [NSString stringWithFormat:@"%@",Localized(@"JX_ RedEnvelopeExpired")];
        }
        if([self.type intValue]==kWCMessageTypeDelMsgScreenshots){// 截屏消息(对方在聊天中进行了截屏)
            self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
            self.isShowRemind = YES;
        }
        if([messageId length]<=0){
            [self setMsgId];
        }
    }
    if([self.type intValue]==kWCMessageTypeTransferReceive){// 转账被领取
        self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        msg.objectId = self.content;
        msg.toUserId = self.fromUserId;
        NSMutableArray *msgs = [msg getMsgWithObjectId:msg.objectId];
        for (int i = 0; i < msgs.count; i++) {
            TFJunYou_MessageObject *msg1 = msgs[i];
            msg1.fileSize = [NSNumber numberWithInt:2];
            [msg1 updateFileSize];
        }

        [g_notify postNotificationName:kUpdateTransferMsgFileSize object:self.content];

        self.content = [NSString stringWithFormat:@"%@%@",self.fromUserName,Localized(@"JX_ReceivedYourTransfer")];
        self.isShowRemind = YES;
    }
    
    if([self.type intValue]==kWCMessageTypeRedPacketReceive){// 红包被领取
        if ([self.toUserId isEqualToString:self.fromUserId]) {
            return NO;
        }
        self.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
        self.isShowRemind = YES;
        if(self.objectId){//群聊红包
            self.toUserId = self.objectId;
            room = self.objectId;
            self.isGroup = YES;
        }
        self.objectId = self.content;
        NSString *overStr = [NSString string];
        if ([self.fileSize intValue] == 1) {
            
            overStr = [NSString stringWithFormat:Localized(@"JX_,YourRedEnvelopeIsAt%@"),[self getTimeForRow:self.fileName overTime:self.timeSend]];
        }
        self.content = [NSString stringWithFormat:@"%@%@%@",self.fromUserName,Localized(@"JXRed_whoGet"),overStr];
    }

    [self changeVideoChatContent];
    if([self isVisible] || [self.type intValue] == kWCMessageTypeIsRead || [self isAddFriendMsg]){//消息可见才保存
        if([room length]>0 || self.isGroup) {
            //将image宽高存入数据库
            return [self doInsertRoomMsg:room];
        }
        else{
            return [self doInsertMsg:MY_USER_ID tableName:[self getTableName]];
        }
    }
    [g_App copyDbWithUserId:MY_USER_ID];
    return NO;
}

- (NSString *)getTimeForRow:(NSString *)createTime overTime:(NSDate *)overTime  {
    // 时间差
    NSTimeInterval time = [overTime timeIntervalSince1970] - [createTime integerValue];
    
    if (time < 60) {
       return [NSString stringWithFormat:@"%d%@",(int)time,Localized(@"JX_second")];
    }
    
    NSInteger sec = time/60;
    if (sec<60) {
        return [NSString stringWithFormat:@"%d%@",sec,Localized(@"JX_Min")];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%d%@",hours,Localized(@"JX_Hour")];
    }
    return nil;
}

-(BOOL)doInsertRoomMsg:(NSString*)room
{
    if(room==nil)
        room = [self getTableName];
    NSString* myUserId = MY_USER_ID;
    self.isGroup = YES;
    return [self doInsertMsg:myUserId tableName:room];
}

-(BOOL)doInsertMsg:(NSString*)dbName tableName:(NSString*)tableName{
    if([dbName length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:dbName];
    //添加了image宽高2参数
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE IF NOT EXISTS 'msg_%@' ('messageNo' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'fromUserId' VARCHAR, 'toUserId' VARCHAR, 'content' VARCHAR, 'timeSend' DATETIME,'timeReceive' DATETIME,'type' INTEGER, 'messageId' VARCHAR, 'fileData' VARCHAR, 'fileName' VARCHAR,'fileSize' INTEGER,'location_x' INTEGER,'location_y' INTEGER,'timeLen' INTEGER,'isRead' INTEGER,'isSend' INTEGER,'objectId' INTEGER,'isReceive' INTEGER,'isUpload' INTEGER,'fromUserName' VARCHAR,'toUserName' VARCHAR,'isReadDel' INTEGER,'fromId' VARCHAR,'toId' VARCHAR,'readPersons' INTEGER,'readTime' DATETIME, 'deleteTime' DATETIME,'chatMsgHeight' VARCHAR,'isShowTime' INTEGER,'signature' VARCHAR,'isVerifySignatureFailed' INTEGER)",tableName];
    
    BOOL worked = [db executeUpdate:createStr];
    //    FMDBQuickCheck(worked);
    
    NSString* sql= [NSString stringWithFormat:@"select messageId from msg_%@ where messageId=?",tableName];
    FMResultSet *rs=[db executeQuery:sql,self.messageId];
    while ([rs next]) {
        //        NSLog(@"不必重复保存:%@",self.messageId);
        return NO;
    }
    
    if ([self.type intValue] == kWCMessageTypeIsRead && self.isGroup){
        NSString *content = self.content;
#ifdef IS_MsgEncrypt
//        if (!self.isGroup) {
            content = [g_msgUtil encryptInsertChatMsgContent:self.content msgId:self.messageId];
//        }
#endif
        
        NSString* sql= [NSString stringWithFormat:@"select messageId from msg_%@ where content=? and fromUserId=?",tableName];
        FMResultSet *rs=[db executeQuery:sql,content,self.fromUserId];
        while ([rs next])
            //已读回执消息不重复保存
            return NO;
    }
    
    NSString *content = self.content;
#ifdef IS_MsgEncrypt
//    if (!self.isGroup) {
        content = [g_msgUtil encryptInsertChatMsgContent:self.content msgId:self.messageId];
//    }
#endif
    
    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO msg_%@ (fromUserId,toUserId,content,type,messageId,timeSend,timeReceive,fileData,fileName,fileSize,location_x,location_y,timeLen,isRead,isSend,objectId,isReceive,isUpload,fromUserName,toUserName,isReadDel,fromId,toId,readPersons,readTime,deleteTime,chatMsgHeight,isShowTime,signature,isVerifySignatureFailed) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",tableName];
    worked = [db executeUpdate:insertStr,self.fromUserId,self.toUserId,content,self.type,self.messageId,self.timeSend,self.timeReceive,[self.fileData xmpp_base64Encoded],self.fileName,self.fileSize,self.location_x,self.location_y,self.timeLen,self.isRead,self.isSend,self.objectId,self.isReceive,self.isUpload,self.fromUserName,self.toUserName,self.isReadDel,self.fromId,self.toId,self.readPersons, self.readTime,self.deleteTime,self.chatMsgHeight,[NSNumber numberWithBool:self.isShowTime],self.signature,self.isVerifySignatureFailed];
    //        FMDBQuickCheck(worked);
    
    
    return worked;
}

-(void)updateLastSend:(UpdateLastSendType)newMsgType{
    if(!self.isVisible && ![self isAddFriendMsg])//加好友消息要更新
        return;
    if(!self.updateLastContent)
        return;
    NSString* tableName = [self getTableName];
    
    if(self.isMySend)//假如是自己发送的
        newMsgType = UpdateLastSendType_None;
    if([current_chat_userId isEqualToString:tableName])//假如正在这个界面
        newMsgType = UpdateLastSendType_None;
//    if([self.type intValue] == kWCMessageTypeRemind)//假如是提示消息，新数量总是0
//        newMsgType = UpdateLastSendType_None;
    if([self.type intValue] == kWCMessageTypeAudioMeetingInvite || [self.type intValue] == kWCMessageTypeVideoMeetingInvite)//一律不提醒
//        if([current_meeting_no isEqualToString:self.fileName])//如果是邀请会议消息，且正在开会，则不提醒
            newMsgType = UpdateLastSendType_None;
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* s=[self getLastContent];
    
    BOOL worked;
    NSString* sql;
    if(self.timeSend == nil)
        self.timeSend = [NSDate date];
    NSString* t=nil;
    
    switch (newMsgType) {
        case UpdateLastSendType_Add:
            t = @",newMsgs=ifnull(newMsgs,0)+1";//此处更新内容，数量+1,ifnull很重要
            break;
        case UpdateLastSendType_None:
            t = @"";   //此处只更新内容，数量不变
            break;
        case UpdateLastSendType_Dec:
            t = @",newMsgs=ifnull(newMsgs,1)-1";   //此处更新内容，数量置0
            break;
            
        default:
            break;
    }
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:tableName];
    // 如果downloadTime 跟timeSend一致表示没有要同步的消息，所以可以更新downloadTime 否则不更新
    if ([user.downloadTime timeIntervalSince1970] == [user.timeSend timeIntervalSince1970]) {
        
        sql = [NSString stringWithFormat:@"update friend set content=?,type=?,timeSend=?,downloadTime=?%@ where userId=?",t];
        worked=[db executeUpdate:sql,s,self.type,self.timeSend,self.timeSend,tableName];
    }else {
        
        sql = [NSString stringWithFormat:@"update friend set content=?,type=?,timeSend=?%@ where userId=?",t];
        worked=[db executeUpdate:sql,s,self.type,self.timeSend,tableName];
    }
    return;
}

// 更新新消息数量
-(void)updateNewMsgCount:(int)count withUserId:(NSString *)userId {
    NSString *sql = [NSString stringWithFormat:@"update friend set newMsgs=? where userId=?"];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    [db executeUpdate:sql,[NSNumber numberWithInt:count],userId];
}

-(NSString*)getTableName{
    if([self isAddFriendMsg])
        return FRIEND_CENTER_USERID;
    if(self.isGroup)//假如是群聊
        return self.toUserId;
    
    NSString* tableName;
    NSString* myUserId = MY_USER_ID;
    if([self.toUserId isEqualToString:myUserId])//如果是发给我，取发送者作为表名
        tableName = self.fromUserId;
    else
        tableName = self.toUserId;
    if (!tableName) {
        if(fromId)
            return fromId;
    }
    return tableName;
}

-(BOOL)checkSystemMsg:(NSString*)dbName tableName:(NSString*)tableName{
    return NO;
}

-(NSString*)getTypeName{
    NSString* s;
    int n = [self.type intValue];
    switch (n) {
        case kWCMessageTypeLink:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXLink")];
            break;
        case kWCMessageTypeSystemImage1:
        case kWCMessageTypeSystemImage2:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXGraphic")];
            break;
        case kWCMessageTypeImage:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Image")];
            break;
        case kWCMessageTypeCustomFace:
        case kWCMessageTypeEmoji:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"emojiVC_Emoji")];
            break;
        case kWCMessageTypeGif:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"emojiVC_Emoji")];
            break;
        case kWCMessageTypeVoice:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Voice")];
            break;
        case kWCMessageTypeLocation:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Location")];
            break;
        case kWCMessageTypeVideo:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Video")];
            break;
        case kWCMessageTypeAudio:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXAudio")];
            break;
        case kWCMessageTypeFile:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_File")];
            break;
        case kWCMessageTypeCard:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Card")];
            break;
        case kWCMessageTypeRedPacket:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_RED")];
            break;
        case kWCMessageTypeTransfer:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Transfer")];
            break;
        default:
            s = self.content;
            break;
    }
    
    return s;
}

-(NSString*)getLastContent{
    NSString* s;
    NSString *typeStr = [NSString stringWithFormat:@"%@",self.type];
    int n = [typeStr intValue];
    switch (n) {
        case kWCMessageTypeLink:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXLink")];
            break;
        case kWCMessageTypeSystemImage1:
        case kWCMessageTypeSystemImage2:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXGraphic")];
            break;
        case kWCMessageTypeImage:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Image")];
            break;
        case kWCMessageTypeEmoji:
        case kWCMessageTypeCustomFace:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"emojiVC_Emoji")];
            break;
        case kWCMessageTypeGif:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"emojiVC_Emoji")];
            break;
        case kWCMessageTypeVoice:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Voice")];
            break;
        case kWCMessageTypeLocation:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Location")];
            break;
        case kWCMessageTypeVideo:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Video")];
            break;
        case kWCMessageTypeAudio:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXAudio")];
            break;
        case kWCMessageTypeFile:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_File")];
            break;
        case kWCMessageTypeCard:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Card")];
            break;
        case kWCMessageTypeRedPacket:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_RED")];
            break;
        case kWCMessageTypeTransfer:
            s = [NSString stringWithFormat:@"[%@]%@",Localized(@"JX_Transfer"),self.isMySend ? Localized(@"JX_WaitForYourFriend'sConfirmation") : @""];
            break;
        case kWCMessageTypeTransferReceive:
            s = [NSString stringWithFormat:@"[%@]%@",Localized(@"JX_Transfer"),Localized(@"JX_TheFriendHasConfirmedTheCharge")];
            break;
        case kWCMessageTypeTransferBack:
            s = [NSString stringWithFormat:@"%@",Localized(@"JX_RefundNoticeOfOverdueTransfer")];
            break;
        case kWCMessageTypeShake:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_Shake")];
            break;
        case kWCMessageTypeMergeRelay:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JX_ChatRecord")];
            break;
        case kWCMessageTypeShare:
            s = [NSString stringWithFormat:@"[%@]",Localized(@"JXLink")];
            break;
        case kWCMessageTypePaymentOut:
        case kWCMessageTypeReceiptOut:
        case kWCMessageTypeOpenPaySuccess:
            s = [NSString stringWithFormat:@"%@",Localized(@"JX_NoticeOfPayment")];
            break;
        case kWCMessageTypePaymentGet:
        case kWCMessageTypeReceiptGet:
            s = [NSString stringWithFormat:@"%@",Localized(@"JX_ReceiptNotice")];
            break;

        /*
        case XMPP_TYPE_SAYHELLO:
            //            s = [NSString stringWithFormat:@"有人打招呼:%@",self.content];
            s = self.content;
            break;
        case XMPP_TYPE_PASS:
            if(self.isMySend)
                s = Localized(@"JXFriendObject_Passed");
            else
                s = Localized(@"JXFriendObject_PassGo");
            break;
        case XMPP_TYPE_FEEDBACK:
            s = self.content;
            break;
        case XMPP_TYPE_NEWSEE:
            if(self.isMySend)
                s = Localized(@"JXFriendObject_Followed");
            else
                s = Localized(@"JXFriendObject_FollowYour");
            break;
        case XMPP_TYPE_DELSEE:
            if(self.isMySend)
                s = Localized(@"JXFriendObject_CencalFollowed");
            else
                s = Localized(@"JXFriendObject_CancelFollow");
            break;
        case XMPP_TYPE_RECOMMEND:
            s = Localized(@"JXFriendObject_RecomYou");
        */
        default:
                s = self.content;
            break;
    }
    
    if ([self.isReadDel boolValue]) {
        s = [NSString stringWithFormat:@"[%@]", Localized(@"JX_ReadDelMsg")];
    }
    
    if (self.isGroup && [typeStr intValue] != kWCMessageTypeRemind) {
        
        TFJunYou_UserObject *allUser = [[TFJunYou_UserObject alloc] init];
        allUser = [allUser getUserById:self.fromUserId];
        
        TFJunYou_UserObject *roomUser = [[TFJunYou_UserObject sharedInstance] getUserById:self.toUserId];
        NSDictionary * groupDict = [roomUser toDictionary];
        
        
        memberData *data = [[memberData alloc] init];
        data.roomId = roomUser.roomId;
        data = [data getCardNameById:self.fromUserId];
        
        roomData * roomdata = [[roomData alloc] init];
        [roomdata getDataFromDict:groupDict];
        NSArray * allMem = [memberData fetchAllMembers:roomUser.roomId];
        roomdata.members = [allMem mutableCopy];
        memberData *data1 = [roomdata getMember:MY_USER_ID];
        NSString *nickName;
        if ([data1.role intValue] == 1) {
            nickName = data.lordRemarkName.length > 0  ? data.lordRemarkName : allUser.remarkName.length > 0  ? allUser.remarkName : data.userNickName.length > 0  ? data.userNickName : self.fromUserName;
        }else {
            nickName = allUser.remarkName.length > 0  ? allUser.remarkName : data.userNickName.length > 0  ? data.userNickName : self.fromUserName;
        }
        
        
        NSRange range = [s rangeOfString:[NSString stringWithFormat:@"%@:",nickName]];
        if (range.location == 0 || !self.fromUserName) {
            return s;
        }else {
            return [NSString stringWithFormat:@"%@:%@",nickName,s];
        }
    }
    return s;
}

/*
-(BOOL)updateIsRead:(BOOL)b{//单聊更新已读标志，弃用
    if(!self.isReceive)
        return NO;
    self.isRead = [NSNumber numberWithBool:b];
    self.readTime = [NSDate date];
    NSString* sql= [NSString stringWithFormat:@"update msg_%@ set isRead=?,readTime=? where messageId=?",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,self.isRead,self.readTime,self.messageId];
    //    FMDBQuickCheck(worked);
    return worked;
}
*/

-(void)updateIsReadWithContent{//更新已读类型消息的Content即MsgId指向的消息的已读
    if(self.isGroup)
        [self updateReadPersons:self.content];
    else
        [self updateIsRead:self.timeSend msgId:self.content];
}

-(BOOL)updateIsRead:(NSDate *)time msgId:(NSString*)msgId{//更新已读时间
//    if(!self.isReceive)
//        return NO;
    if (time==nil)
        time = [NSDate date];
    self.isRead = [NSNumber numberWithBool:YES];
    self.isSend = [NSNumber numberWithBool:YES];
    self.readTime = time;
    
    NSString* sql= [NSString stringWithFormat:@"update msg_%@ set isSend=1,isRead=1,readTime=? where messageId=?",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,self.readTime, msgId];
    //    FMDBQuickCheck(worked);
    return worked;
}

-(BOOL)updateReadPersons:(NSString*)msgId{//更新群聊已读人数
    NSString *tableName = [self getTableName];
    if(self.isMySend){
        self.isRead = [NSNumber numberWithBool:YES];
        self.isSend = [NSNumber numberWithBool:YES];
    }
    self.readPersons = [NSNumber numberWithInt:[self.readPersons intValue]+1];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* sql,* s;
    if(self.isMySend)
        s = @"isRead=1,";
    else
        s = @"";
    sql= [NSString stringWithFormat:@"update msg_%@ set %@ isSend=1,readPersons=ifnull(readPersons,0)+1 where messageId=?",tableName,s];//ifnull很重要
    BOOL worked = [db executeUpdate:sql,msgId];
    return worked;
}

-(BOOL)updateIsUpload:(BOOL)b{
    if(!self.isSend)
        return NO;
    NSString *content = self.content;
#ifdef IS_MsgEncrypt
//    if (!self.isGroup) {
        content = [g_msgUtil encryptInsertChatMsgContent:self.content msgId:self.messageId];
//    }
#endif
    self.isUpload = [NSNumber numberWithBool:b];
    NSString* sql= [NSString stringWithFormat:@"update msg_%@ set isUpload=?,content=? where messageId=?",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,self.isUpload,content,self.messageId];
    //    FMDBQuickCheck(worked);
    return worked;
}

-(BOOL)updateIsReceive:(int)n{
    self.isReceive = [NSNumber numberWithInt:n];
    NSString* sql= [NSString stringWithFormat:@"update msg_%@ set isReceive=?,fileName=? where messageId=?",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,self.isReceive,self.fileName,self.messageId];
    //    FMDBQuickCheck(worked);
    
    return worked;
}

-(BOOL)updateIsSend:(int)n{
    self.isSend = [NSNumber numberWithInt:n];
    self.timeReceive = [NSDate date];
    NSString* sql= [NSString stringWithFormat:@"update msg_%@ set isSend=?,timeReceive=? where messageId=?",[self getTableName]];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:sql,self.isSend,self.timeReceive,self.messageId];
    //    FMDBQuickCheck(worked);
    return worked;
}

//获取某联系人聊天记录
-(NSMutableArray *)fetchMessageListWithUser:(NSString *)userId byAllNum:(NSInteger)num pageCount:(int)pageCount startTime:(NSDate *)startTime
{
    //    NSLog(@"fetchMessageListWithUser.begin");
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];

    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where (fromUserId=? or toUserId=?) and type<>26 and timeSend >= ? order by timeSend desc,messageNo desc limit %ld,%d",userId,num,pageCount];
    
//    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ order by timeSend desc,messageNo desc limit ?*%d,%d",userId,PAGE_SHOW_COUNT,PAGE_SHOW_COUNT];
    
    CGFloat chatAllHeight = 0;
    
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    FMResultSet *rs=[db executeQuery:queryString,userId,userId,startTime];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc] init];
        p.isGroup = [user.roomFlag boolValue];
        [p fromRs:rs];
        
        p.isGroup = [user.roomFlag boolValue];

        // 去除文本阅后即焚计时结束的消息
        if ([p.type intValue] == 1 && !p.isMySend && [p.fileName isKindOfClass:[NSString class]] && [p.fileName length] > 0 && [p.fileName intValue] > 0) {
            
            NSString *messageR = [p.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];  //去掉回车键
            NSString *messageN = [messageR stringByReplacingOccurrencesOfString:@"\n" withString:@""];  //去掉回车键
            NSString *messageText = [messageN stringByReplacingOccurrencesOfString:@" " withString:@""];  //去掉空格
            CGSize size = [messageText boundingRectWithSize:CGSizeMake(TFJunYou__SCREEN_WIDTH-INSETS-HEAD_SIZE - 100 + 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(g_constant.chatFont)} context:nil].size;
            NSInteger count = size.height / g_constant.chatFont;
            NSLog(@"countcount ===  %ld-----%f-----%@",count,[[NSDate date] timeIntervalSince1970],p.fileName);
            //            NSLog(@"countcount === %ld,,,,%f,,,,%@",count,[[NSDate date] timeIntervalSince1970], self.msg.fileName);
            count = count * 10 - ([[NSDate date] timeIntervalSince1970] - [p.fileName longLongValue]);
            if (count <= 0) {
                [p delete];
                continue;
            }
        }
        
//        CGFloat height = [self getMsgChatHeight:p];
//        p.chatMsgHeight = [NSString stringWithFormat:@"%f",height];
//        chatAllHeight += height;
//
//        if (num <= 0) {
//
//            if (chatAllHeight < TFJunYou__SCREEN_HEIGHT || temp.count <= 5) {
//                [temp addObject:p];
//            }
//
//        }else {
        
            [temp addObject:p];
//        }
    }
    //    NSLog(@"聊天记录第%d页:%d",pageIndex,temp.count);
    [rs close];
    
    for(NSInteger i=[temp count]-1;i>=0;i--){
        [messageList addObject:[temp objectAtIndex:i]];
    }
    if([messageList count]==0)
        messageList = nil;
    return  messageList;
}

- (CGFloat)getMsgChatHeight:(TFJunYou_MessageObject *)msg {
 
    switch ([msg.type intValue]) {
        case kWCMessageTypeText:
            return [TFJunYou_MessageCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeImage:
            return [TFJunYou_ImageCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeCustomFace:
            return [TFJunYou_FaceCustomCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeEmoji:
            return [TFJunYou_EmojiCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeVoice:
            return [TFJunYou_AudioCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeLocation:
            return [TFJunYou_LocationCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeGif:
            return [TFJunYou_GifCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeVideo:
            return [TFJunYou_VideoCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeAudio:
            return [TFJunYou_VideoCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeCard:
            return [TFJunYou_CardCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeFile:
            return [TFJunYou_FileCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeRemind:
            return [TFJunYou_RemindCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeRedPacket:
            return [TFJunYou_RedPacketCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeTransfer:
            return [TFJunYou_TransferCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeSystemImage1:
            return [TFJunYou_SystemImage1Cell getChatCellHeight:msg];
            break;
        case kWCMessageTypeSystemImage2:
            return [TFJunYou_SystemImage2Cell getChatCellHeight:msg];
            break;
        case kWCMessageTypeAudioMeetingInvite:
        case kWCMessageTypeVideoMeetingInvite:
        case kWCMessageTypeAudioChatCancel:
        case kWCMessageTypeAudioChatEnd:
        case kWCMessageTypeVideoChatCancel:
        case kWCMessageTypeVideoChatEnd:
        case kWCMessageTypeAVBusy:
            return [TFJunYou_AVCallCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeLink:
            return [TFJunYou_LinkCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeShake:
            return [TFJunYou_ShakeCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeMergeRelay:
            return [TFJunYou_MergeRelayCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeShare:
            return [TFJunYou_ShareCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeReply:
            return [TFJunYou_ReplyCell getChatCellHeight:msg];
            break;
        default:
            return [TFJunYou_BaseChatCell getChatCellHeight:msg];
            break;
    }
}

//获取某联系人所有聊天记录
-(NSMutableArray*)fetchAllMessageListWithUser:(NSString *)userId {
    
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where (fromUserId=? or toUserId=?) and type<>26 order by timeSend desc,messageNo desc",userId];
//    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ order by timeSend desc,messageNo desc",userId];
    
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    FMResultSet *rs=[db executeQuery:queryString,userId,userId];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        [p fromRs:rs];
        p.isGroup = [user.roomFlag boolValue];
        // 去除文本阅后即焚计时结束的消息
        if ([p.type intValue] == 1 && !p.isMySend && [p.fileName isKindOfClass:[NSString class]] && [p.fileName length] > 0 && [p.fileName intValue] > 0) {
            
            NSString *messageR = [p.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];  //去掉回车键
            NSString *messageN = [messageR stringByReplacingOccurrencesOfString:@"\n" withString:@""];  //去掉回车键
            NSString *messageText = [messageN stringByReplacingOccurrencesOfString:@" " withString:@""];  //去掉空格
            CGSize size = [messageText boundingRectWithSize:CGSizeMake(TFJunYou__SCREEN_WIDTH-INSETS-HEAD_SIZE - 100 + 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(g_constant.chatFont)} context:nil].size;
            NSInteger count = size.height / g_constant.chatFont;
            NSLog(@"countcount ===  %ld-----%f-----%@",count,[[NSDate date] timeIntervalSince1970],p.fileName);
            //            NSLog(@"countcount === %ld,,,,%f,,,,%@",count,[[NSDate date] timeIntervalSince1970], self.msg.fileName);
            count = count * 10 - ([[NSDate date] timeIntervalSince1970] - [p.fileName longLongValue]);
            if (count <= 0) {
                [p delete];
                continue;
            }
        }
        
//        CGFloat height = [self getMsgChatHeight:p];
//        p.chatMsgHeight = [NSString stringWithFormat:@"%f",height];
        
        [temp addObject:p];
    }
    //    NSLog(@"聊天记录第%d页:%d",pageIndex,temp.count);
    [rs close];
    
    for(NSInteger i=[temp count]-1;i>=0;i--){
        [messageList addObject:[temp objectAtIndex:i]];
    }
    
    if([messageList count]==0)
        messageList = nil;
    return  messageList;
}


//获取某联系人某个type的所有聊天记录
-(NSMutableArray*)fetchAllMessageListWithUser:(NSString *)userId withTypes:(NSArray *)types {
    
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableString *typeStr = [NSMutableString string];
    for (NSInteger i = 0; i < types.count; i ++) {
        NSNumber *type = types[i];
        if (i == 0) {
            [typeStr appendString:[NSString stringWithFormat:@"type = %@",type]];
        }else {
         
            [typeStr appendString:[NSString stringWithFormat:@" or type = %@",type]];
        }
    }
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where (fromUserId=? or toUserId=?) and (%@) order by timeSend desc,messageNo desc",userId,typeStr];
    //    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ order by timeSend desc,messageNo desc",userId];
    
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    FMResultSet *rs=[db executeQuery:queryString,userId,userId,type];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        [p fromRs:rs];
        p.isGroup = [user.roomFlag boolValue];
        
        // 去除文本阅后即焚计时结束的消息
        if ([p.type intValue] == 1 && !p.isMySend && [p.fileName isKindOfClass:[NSString class]] && [p.fileName length] > 0 && [p.fileName intValue] > 0) {
            
            NSString *messageR = [p.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];  //去掉回车键
            NSString *messageN = [messageR stringByReplacingOccurrencesOfString:@"\n" withString:@""];  //去掉回车键
            NSString *messageText = [messageN stringByReplacingOccurrencesOfString:@" " withString:@""];  //去掉空格
            CGSize size = [messageText boundingRectWithSize:CGSizeMake(TFJunYou__SCREEN_WIDTH-INSETS-HEAD_SIZE - 100 + 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(g_constant.chatFont)} context:nil].size;
            NSInteger count = size.height / g_constant.chatFont;
            NSLog(@"countcount ===  %ld-----%f-----%@",count,[[NSDate date] timeIntervalSince1970],p.fileName);
            //            NSLog(@"countcount === %ld,,,,%f,,,,%@",count,[[NSDate date] timeIntervalSince1970], self.msg.fileName);
            count = count * 10 - ([[NSDate date] timeIntervalSince1970] - [p.fileName longLongValue]);
            if (count <= 0) {
                [p delete];
                continue;
            }
        }
        
        [temp addObject:p];
    }
    //    NSLog(@"聊天记录第%d页:%d",pageIndex,temp.count);
    [rs close];
    
//    for(NSInteger i=[temp count]-1;i>=0;i--){
//        [messageList addObject:[temp objectAtIndex:i]];
//    }
    
//    if([messageList count]==0)
//        messageList = nil;
    return  temp;
}

// 获取某个时间段聊天记录
- (NSMutableArray *) fetchMessageListUserId:(NSString *)userId StartTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where (fromUserId=? or toUserId=?) and type<>26 and timeSend > ? and timeSend < ? order by timeSend desc,messageNo desc",userId];
    
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    FMResultSet *rs=[db executeQuery:queryString,userId,userId,startTime,endTime];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc] init];
        [p fromRs:rs];
        p.isGroup = [user.roomFlag boolValue];
        [temp addObject:p];
    }
    [rs close];
    
    for(NSInteger i=[temp count]-1;i>=0;i--){
        [messageList addObject:[temp objectAtIndex:i]];
    }
    
    return  messageList;
}


//获取客服号，公众号内容
-(NSMutableArray *)getSystemChatByPage:(int)pageIndex types:(NSString*)types
{
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where type in (%@) order by timeSend desc,messageNo desc limit ?*%d,%d",CALL_CENTER_USERID,types,PAGE_SHOW_COUNT,PAGE_SHOW_COUNT];
    FMResultSet *rs=[db executeQuery:queryString,[NSNumber numberWithInt:pageIndex]];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        [p fromRs:rs];
        [messageList addObject:p];
        //        [p release];
    }
    //    NSLog(@"最近聊天人第%d页:%d",pageIndex,messageList.count);
    
    if([messageList count]==0)
        messageList = nil;
    return  messageList;
}


//获取最近联系人
-(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex
{
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"select * from friend where status<=8 and length(content)>0 order by timeSend desc limit ?*%d,%d",PAGE_SHOW_COUNT,PAGE_SHOW_COUNT];
    FMResultSet *rs=[db executeQuery:queryString,[NSNumber numberWithInt:pageIndex]];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        //        [p fromRs:rs];
        p.content = [rs stringForColumn:kMESSAGE_CONTENT];
        p.type = [rs objectForColumnName:kMESSAGE_TYPE];
        p.timeSend = [rs dateForColumn:kMESSAGE_TIMESEND];
        p.fromUserId = [rs stringForColumn:kUSER_ID];
        p.toUserId = myUserId;
        
        
        TFJunYou_UserObject *user=[[TFJunYou_UserObject alloc]init];
        [user userFromDataset:user rs:rs];
        
        TFJunYou_MsgAndUserObject *unionObject=[TFJunYou_MsgAndUserObject unionWithMessage:p andUser:user ];
        [messageList addObject:unionObject];
    }
    db = nil;
    if([messageList count]==0)
        messageList = nil;
    //    NSLog(@"最近聊天人第%d页:%d",pageIndex,messageList.count);
    return  messageList;
}

-(NSMutableArray *)fetchRecentChat
{
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from friend where (status=8 or status=2 or status=0 or status=10) and length(content)>0 and topTime > 0 and userId != %@ order by timeSend desc", FRIEND_CENTER_USERID];
    FMResultSet *rs=[db executeQuery:queryString];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        //        [p fromRs:rs];
        p.content = [rs stringForColumn:kMESSAGE_CONTENT];
        p.type = [rs objectForColumnName:kMESSAGE_TYPE];
        p.timeSend = [rs dateForColumn:kMESSAGE_TIMESEND];
        p.fromUserId = [rs stringForColumn:kUSER_ID];
        p.toUserId = myUserId;
        
        TFJunYou_UserObject *user=[[TFJunYou_UserObject alloc]init];
        [user userFromDataset:user rs:rs];
        
        //        if (user.roomFlag || user.roomId.length > 0) {
        //            p.isGroup = YES;
        //        }
        
        TFJunYou_MsgAndUserObject *unionObject=[TFJunYou_MsgAndUserObject unionWithMessage:p andUser:user ];
        [messageList addObject:unionObject];
    }
    
    queryString=[NSString stringWithFormat:@"select * from friend where (status=8 or status=2 or status=0 or status=10) and length(content)>0 and (topTime is null or topTime = 0)  and userId != %@ order by timeSend desc", FRIEND_CENTER_USERID];
    rs=[db executeQuery:queryString];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        //        [p fromRs:rs];
        p.content = [rs stringForColumn:kMESSAGE_CONTENT];
        p.type = [rs objectForColumnName:kMESSAGE_TYPE];
        p.timeSend = [rs dateForColumn:kMESSAGE_TIMESEND];
        p.fromUserId = [rs stringForColumn:kUSER_ID];
        p.toUserId = myUserId;
        
        TFJunYou_UserObject *user=[[TFJunYou_UserObject alloc]init];
        [user userFromDataset:user rs:rs];
        
//        if (user.roomFlag || user.roomId.length > 0) {
//            p.isGroup = YES;
//        }
        
        TFJunYou_MsgAndUserObject *unionObject=[TFJunYou_MsgAndUserObject unionWithMessage:p andUser:user ];
        [messageList addObject:unionObject];
    }
    db = nil;
    if([messageList count]==0)
        messageList = nil;
    return  messageList;
}

//只获取某联系人图片聊天记录
-(NSMutableArray*)fetchImageMessageListWithUser:(NSString *)userId
{
    NSLog(@"fetchMessageListWithUser.begin");
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];

    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    NSString *queryString = nil;
    
    queryString = [NSString stringWithFormat:@"select * from msg_%@ where type=2 order by timeSend asc,messageNo asc",userId];
    
    FMResultSet *rs=[db executeQuery:queryString];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        p.isGroup = [user.roomFlag boolValue];
        [p fromRs:rs];
        [messageList addObject:p];
        p = nil;
    }
    [rs close];
    db = nil;
    
    NSLog(@"fetchMessageListWithUser.end");
    if([messageList count]==0)
        messageList = nil;
    return  messageList;
}

//获取某联系人聊天记录
-(NSMutableArray*)fetchBlogMsgListWithUser:(int)pageIndex
{
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    NSString *queryString=[NSString stringWithFormat:@"select objectId,type,sum(timeLen) from msg_%@ group by objectId,type order by objectId desc limit 0,1",BLOG_CENTER_USERID];
    
    FMResultSet *rs=[db executeQuery:queryString];
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        [p fromRs:rs];
        [messageList addObject:p];
        //        [p release];
    }
    [rs close];
    db = nil;
    
    if([messageList count]==0)
        messageList = nil;

    return  messageList;
}

// 搜索聊天记录
-(NSArray <TFJunYou_MessageObject *>*)fetchSearchMessageWithUserId:(NSString *)userId String:(NSString *)str {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];

    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where content like '%%%@%%' and type = 1 and isReadDel != 1  order by timeSend desc",userId, str];
    FMResultSet *rs=[db executeQuery:queryString];
    
    NSMutableArray * resultArray = [NSMutableArray array];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        p.isGroup = [user.roomFlag boolValue];
        [p fromRs:rs];
        [resultArray addObject:p];
    }
    return resultArray;
}

-(NSArray <TFJunYou_MessageObject *>*)fetchDelMessageWithUserId:(NSString *)userId {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:userId];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where isReadDel = 1 and fromUserId != %@ order by timeSend desc",userId,myUserId];
    FMResultSet *rs=[db executeQuery:queryString];
    
    NSMutableArray * resultArray = [NSMutableArray array];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        p.isGroup = [user.roomFlag boolValue];
        [p fromRs:rs];
        [resultArray addObject:p];
    }
    return resultArray;
}

// 根据content获取最新行
- (int) getLineNumWithUserId:(NSString *)userId {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return 0;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    NSString *queryString=[NSString stringWithFormat:@"select count(*) num from msg_%@ where timeSend <= %lf and type<>26",userId, [self.timeSend timeIntervalSince1970]];
    FMResultSet *rs=[db executeQuery:queryString];
    int p = 0;
    while ([rs next]) {
        p = [[rs objectForColumnName:@"num"] intValue];
        break;
    }
    return p;
}

-(CGPoint)getLocation{
    return CGPointMake([location_x floatValue],[location_y floatValue]);
}

-(BOOL)updateNewMsgsTo0{
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    BOOL worked=[db executeUpdate:[NSString stringWithFormat:@"update friend set newMsgs=0 where userId=?"],[self getTableName]];
    return worked;
}

-(void)notifyNewMsg{
    NSInteger msgType = self.type.integerValue;
    if(msgType == kWCMessageTypeNone) return;//如果是被踢出群或解散群时,type为0
        
    
    if (g_xmpp.msgTimer) {
        dispatch_cancel(g_xmpp.msgTimer);
        g_xmpp.msgTimer = nil;
        g_xmpp.lastMsgTime = 0.00;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    g_xmpp.msgTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = DISPATCH_TIME_NOW;
    dispatch_time_t interval = 0.25 * NSEC_PER_SEC;
    dispatch_source_set_timer(g_xmpp.msgTimer, start, interval, 0);
    dispatch_source_set_event_handler(g_xmpp.msgTimer, ^{
        g_xmpp.lastMsgTime = g_xmpp.lastMsgTime + 0.25;
    });
    dispatch_resume(g_xmpp.msgTimer);
    
    [g_xmpp performSelector:@selector(notifyNewMsg) withObject:nil afterDelay:0.75];
    
    
    [g_notify postNotificationName:kXMPPNewMsgNotifaction object:self userInfo:nil];//刷新聊天详情页
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        
    }else{//如果程序在后台运行，收到消息以通知类型来显示
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Ok";
        NSString *msg = [NSString stringWithFormat:@"%@:%@",self.fromUserName,self.content];
        localNotification.alertBody = msg;//通知主体
        //            localNotification.soundName = @"newmsg2.mp3";//通知声音
        //            localNotification.applicationIconBadgeNumber = 1;//标记数
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];//发送通知
    }
}

-(void)notifyReceipt{
    [g_notify postNotificationName:kXMPPReceiptNotifaction object:self userInfo:nil];
}

-(void)notifyReceive{
    [g_notify postNotificationName:kXMPPReceiveFileNotifaction object:self userInfo:nil];
}

-(void)notifyTimeout{
    [g_notify postNotificationName:kXMPPSendTimeOutNotifaction object:self userInfo:nil];
    if (self.isGroupSend) {
        [g_notify postNotificationName:kKeepOnSendGroupSendMessage object:self];
    }
}

-(void)notifyMyLastSend{
    [g_notify postNotificationName:kXMPPMyLastSendNotifaction object:self userInfo:nil];
}

-(BOOL)getIsGroup{
//    return toUserId.length>12 || _isGroup || _roomJid != nil;
//    return toUserId.length>12 || _isGroup;
    return _isGroup;
}

-(int)getMaxWaitTime{
    int maxTime = 20;//图片或视频在上传完成之后，才调SendMessage，才开始计时
/*
    if([self.type intValue] == kWCMessageTypeImage || [self.type intValue] == kWCMessageTypeVideo)
        maxTime = 60;
    if([self.type intValue] == kWCMessageTypeVoice){
        maxTime = [self.timeLen intValue];
        if(maxTime < 20)
            maxTime = 20;
        if(maxTime > 60)
            maxTime = 60;
    }
*/
    return maxTime;
}

//-(void)doReceiveRemind{
//    if(![self.fromId isEqualToString:REMIND_CENTER_USERID])
//        return;
//    TFJunYou_RemindObject* p = [[TFJunYou_RemindObject alloc]init];
//    [p fromObject:self];
//    [p insert];
//    [p notify];
////    [p release];
//}

-(void)doReceiveRoomRemind{
    if(![self isRoomControlMsg])
        return;
    TFJunYou_RoomRemind* p = [[TFJunYou_RoomRemind alloc] init];
    [p fromObject:self];
    //    [p insert];
    [p notify];
    //    [p release];
}

-(void)doReceiveNewBlog{
    if(![self.fromId isEqualToString:BLOG_CENTER_USERID])
        return;
    if([self.type intValue] != XMPP_TYPE_NEWBLOG)
        return;
    TFJunYou_BlogObject* p = [[TFJunYou_BlogObject alloc] init];
    [p fromObject:self];
    [p insert];
    //    [p release];
}


-(BOOL)getIsMySend{
//    if(fromId)
//        return [self.fromId isEqualToString:MY_USER_ID];
//    else
    if (self.changeMySend == 1) {
        return NO;
    }else if (self.changeMySend == 2) {
        return YES;
    }
    //此处不能转换成intValue，多点登录userid，无法比较
    return [self.fromUserId isEqualToString:MY_USER_ID];
}

-(void)setMsgId{
    self.messageId = [[[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

-(void)setFileName:(NSString *)value{
    if(value == fileName){
        return;
    }
    //    if(value == nil){
    //       [fileName release];
    //    }
    //    fileName = [value retain];
    fileName = value;
    if ([type intValue] == kWCMessageTypeRedPacket || [type intValue] == kWCMessageTypeTransfer) {
        self.fileSize = [NSNumber numberWithInt:1];
        return;
    }
    if(self.isMySend)
        self.fileSize = [NSNumber numberWithLongLong:[TFJunYou_FileInfo getFileSize:value]];
}

-(BOOL)doNewRemindMsg{
    
    NSString* room = self.objectId;
    if ([self.type intValue] == kRoomRemind_NeedVerify) {
        SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
        NSDictionary *resultObject = [resultParser objectWithString:self.objectId];
        if (resultObject) {
            room = [resultObject objectForKey:@"roomJid"];
        }
    }
    TFJunYou_MessageObject* msg = self;
//    bool是否是直播间
    BOOL isLiveMsg = NO;
#ifdef Live_Version
    isLiveMsg = [[TFJunYou_LiveJidManager shareArray] contains:msg.objectId];
#endif
    NSString* s=nil;BOOL b=1;
    TFJunYou_UserObject* user = [[TFJunYou_UserObject sharedInstance] getUserById:msg.objectId];
    
    memberData *data = [[memberData alloc] init];
    data.roomId = user.roomId;
    memberData *cardData = [data getCardNameById:msg.fromUserId];
    if (cardData.cardName) {
        msg.fromUserName = cardData.cardName;
    }
    switch ([msg.type intValue]) {
        case kRoomRemind_RoomName:
            s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_UpdateRoomName"),msg.content];
            break;
        case kRoomRemind_NickName:{
            s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_UpdateNickName"),msg.content];
            [self updateFromUserName];
            data.userId = [msg.fromUserId longLongValue];
            data.cardName = msg.content;
            [data updateCardName];
        }
            break;
        case kRoomRemind_DelRoom:
            if ([msg.toUserId isEqualToString:MY_USER_ID]) {
                s = [NSString stringWithFormat:Localized(@"JX_DissolutionGroup"),msg.fromUserName];
            }else {
                s = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_delRoom"),msg.content];
            }
            
//            b = 0;//假如是解散了房间，则不发通知，不显示提醒文字 （现在注释，解散房间后也提醒）
            
//            if (![msg.fromUserId isEqualToString:MY_USER_ID]) {
//                // 删除房间弹框提醒
//                [g_App showAlert:[NSString stringWithFormat:@"%@%@",msg.content,Localized(@"JX_DissolutionGroup")]];
//            }
            
            
            break;
        case kRoomRemind_AddMember:
            if([msg.toUserId isEqualToString:msg.fromUserId] || IS_OTHER_DEVICE(msg.toUserId))
                s = [NSString stringWithFormat:@"%@%@",msg.fromUserName,Localized(@"JXMessageObject_GroupChat")];
            else
                s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_InterFriend"),msg.toUserName];
            break;
        case kLiveRemind_ExitRoom:
            if([msg.toUserId isEqualToString:msg.fromUserId]){
                s = [NSString stringWithFormat:@"%@%@",msg.fromUserName,Localized(@"EXITED_LIVE_ROOM")];//退出

            }else{
                s = [NSString stringWithFormat:@"%@%@",msg.toUserName,Localized(@"JX_LiveVC_kickLive")];//被踢出
            }
            break;
        case kRoomRemind_DelMember:
            if([msg.toUserId isEqualToString:msg.fromUserId]){
                if(isLiveMsg){
                    s = [NSString stringWithFormat:@"%@%@",msg.fromUserName,Localized(@"EXITED_LIVE_ROOM")];//退出
                }else{
                    s = [NSString stringWithFormat:@"%@%@",msg.fromUserName,Localized(@"JXMessageObject_OutGroupChat")];
                }
            }else{
                if(isLiveMsg){
                    s = [NSString stringWithFormat:@"%@%@",msg.toUserName,Localized(@"JX_LiveVC_kickLive")];//被踢出
                }else{
                    if ([msg.toUserId isEqualToString:MY_USER_ID]) {
                        s = [NSString stringWithFormat:Localized(@"JX_OutOfTheGroup"),msg.fromUserName];
                    }else {
                        if ([msg.fromUserName isEqualToString:msg.toUserName]) {
                            s = [NSString stringWithFormat:@"%@%@",msg.fromUserName,Localized(@"JXRoomMemberVC_OutPutRoom")];
                        }else {
                            s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_KickOut"),msg.toUserName];
                        }
                    }
                    
//                    if (![msg.fromUserId isEqualToString:MY_USER_ID]) {
//                        // 被踢出房间弹框提醒
//                        [g_App showAlert:[NSString stringWithFormat:@"%@：%@",Localized(@"JX_OutOfTheGroup"),msg.content]];
//                    }
                    
                }
            }
//            if([self.toUserId isEqualToString:MY_USER_ID])//假如是自己被踢出了房间，则不发通知，不显示提醒文字（现在注释，踢出房间也提醒）
//                b = 0;
            break;
        case kRoomRemind_NewNotice:
        case kRoomRemind_editNotice:
            s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_AddNewAdv"),msg.content];
            break;
        case kLiveRemind_ShatUp:
        case kRoomRemind_DisableSay:{
            if([msg.content longLongValue]==0){
                s = [NSString stringWithFormat:@"%@%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_Yes"),msg.toUserName,Localized(@"JXMessageObject_CancelGag")];
            }else{
                NSDate* d = [NSDate dateWithTimeIntervalSince1970:[msg.content longLongValue]];
                NSString* t = [TimeUtil formatDate:d format:@"MM-dd HH:mm"];
                s = [NSString stringWithFormat:@"%@%@%@%@%@",msg.fromUserName,Localized(@"JXMessageObject_Yes"),msg.toUserName,Localized(@"JXMessageObject_SetGagWithTime"),t];
                d = nil;
            }
            break;
        }
        case kLiveRemind_SetManager:
        case kRoomRemind_SetManage:{
            if ([msg.content integerValue] == 1) {
                s = [NSString stringWithFormat:@"%@%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"JXSettingVC_Set"),msg.toUserName,Localized(@"JXMessage_admin")];
            }else {
                s = [NSString stringWithFormat:@"%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"CANCEL_ADMINISTRATOR"),msg.toUserName];
            }
            break;
        }
        case kRoomRemind_EnterLiveRoom:{
            s = [NSString stringWithFormat:@"%@%@",msg.toUserName,Localized(@"Enter_LiveRoom")];//加入房间消息
            break;
        }
        case kRoomRemind_ShowRead:{
            if ([msg.content integerValue] == 1)
                s = [NSString stringWithFormat:@"%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"JX_Enable"),Localized(@"JX_RoomReadMode")];
            else
                s = [NSString stringWithFormat:@"%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"JX_Disable"),Localized(@"JX_RoomReadMode")];
            break;
        }
        case kRoomRemind_NeedVerify:{
            
            if (!msg.content || msg.content.length <= 0) {
                SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
                NSDictionary *resultObject = [resultParser objectWithString:self.objectId];
                NSString *userIdStr = [resultObject objectForKey:@"userIds"];
                BOOL isInvite = [[resultObject objectForKey:@"isInvite"] boolValue];
                if (isInvite) {
                    s = [NSString stringWithFormat:@"%@%@",msg.fromUserName,Localized(@"JX_JoinTheGroupToConfirm")];
                }else {
                    NSArray *userIds = [userIdStr componentsSeparatedByString:@","];
                    s = [NSString stringWithFormat:@"\"%@\"%@%ld%@",self.fromUserName,Localized(@"JX_WouldLikeToInvite"),userIds.count,Localized(@"JX_JoinGroupToConfirm")];
                }
            }else {
                if ([msg.content integerValue] == 1)
                    s = Localized(@"JX_GroupOwnersOpenValidation");
                else
                    s = Localized(@"JX_GroupOwnersCloseValidation");
            }
            
            break;
        }
        case kRoomRemind_IsLook:{
            if ([msg.content integerValue] == 0)
                s = Localized(@"JX_GroupOwnersPublicGroup");
            else
                s = Localized(@"JX_GroupOwnersPrivateGroup");
            break;
        }
            
        case kRoomRemind_ShowMember:{
            if ([msg.content integerValue] == 1)
                s = Localized(@"JX_GroupOwnersShowMembers");
            else
                s = Localized(@"JX_GroupOwnersNotShowMembers");
            break;
        }
            
        case kRoomRemind_allowSendCard:{
            if ([msg.content integerValue] == 1)
                s = Localized(@"JX_ManagerOpenChat");
            else
                s = Localized(@"JX_ManagerOffChat");
            break;
        }
            
        case kRoomRemind_RoomAllBanned:{
            if ([msg.content integerValue] > 0)
                s = Localized(@"JX_ManagerOpenSilence");
            else
                s = Localized(@"JX_ManagerOffSilence");
            break;
        }
            
        case kRoomRemind_RoomAllowInviteFriend:{
            if ([msg.content integerValue] > 0)
                s = Localized(@"JX_ManagerOpenInviteFriends");
            else
                s = Localized(@"JX_ManagerOffInviteFriends");
            break;
        }
            
        case kRoomRemind_RoomAllowUploadFile:{
            if ([msg.content integerValue] > 0)
                s = Localized(@"JX_ManagerOpenSharedFiles");
            else
                s = Localized(@"JX_ManagerOffSharedFiles");
            break;
        }
            
        case kRoomRemind_RoomAllowConference:{
            if ([msg.content integerValue] > 0)
                s = Localized(@"JX_ManagerOpenMeetings");
            else
                s = Localized(@"JX_ManagerOffMeetings");
            break;
        }
            
        case kRoomRemind_RoomAllowSpeakCourse:{
            if ([msg.content integerValue] > 0)
                s = Localized(@"JX_ManagerOpenLectures");
            else
                s = Localized(@"JX_ManagerOffLectures");
            break;
        }
            
        case kRoomRemind_RoomTransfer:{
            s = [NSString stringWithFormat:@"\"%@\"%@", msg.toUserName,Localized(@"JX_NewGroupManager")];
            break;
        }
        case kRoomRemind_SetInvisible:{
            if ([msg.content integerValue] == 1) {
                s = [NSString stringWithFormat:@"%@%@%@%@",msg.fromUserName,Localized(@"JXSettingVC_Set"),msg.toUserName,Localized(@"JX_ForTheInvisibleMan")];
            }else if ([msg.content integerValue] == -1){
                s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,Localized(@"JX_EliminateTheInvisible"),msg.toUserName];
            }else if ([msg.content integerValue] == 2){
                s = [NSString stringWithFormat:@"%@%@%@%@",msg.fromUserName,Localized(@"JXSettingVC_Set"),msg.toUserName,@"为监控人"];
            }else if ([msg.content integerValue] == 0){
                s = [NSString stringWithFormat:@"%@%@%@",msg.fromUserName,@"取消监控人",msg.toUserName];
            }
            break;
        }
            
        case kRoomRemind_RoomDisable:{
            if ([msg.content integerValue] == 1) {
                s = [NSString stringWithFormat:@"%@",Localized(@"JX_ThisGroupHasBeenDisabled")];
            }else {
                s = [NSString stringWithFormat:@"%@",Localized(@"JX_GroupNotUse")];
            }
            break;
        }
            
        case kRoomRemind_SetRecordTimeOut:{
            NSArray *pickerArr = @[Localized(@"JX_Forever"), Localized(@"JX_OneHour"), Localized(@"JX_OneDay"), Localized(@"JX_OneWeeks"), Localized(@"JX_OneMonth"), Localized(@"JX_OneQuarter"), Localized(@"JX_OneYear")];
            double outTime = [msg.content doubleValue];
            NSString *str;
            if (outTime <= 0) {
                str = pickerArr[0];
            }else if (outTime == 0.04) {
                str = pickerArr[1];
            }else if (outTime == 1) {
                str = pickerArr[2];
            }else if (outTime == 7) {
                str = pickerArr[3];
            }else if (outTime == 30) {
                str = pickerArr[4];
            }else if (outTime == 90) {
                str = pickerArr[5];
            }else{
                str = pickerArr[6];
            }
            s = [NSString stringWithFormat:@"%@%@",Localized(@"JX_GroupManagerSetMsgDelTime"),str];
        }
    }
    if(b)
        msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
    else
        msg.type = [NSNumber numberWithInt:kWCMessageTypeNone];
    
    msg.fromId = nil;
    msg.toId = nil;
    msg.fromUserId = msg.fromUserId;
    msg.toUserId = room;
    msg.content = s;
    if ([msg haveTheMessage]) {
        return NO;
    }
    return b;
}

-(void)copy:(TFJunYou_MessageObject*)p{
    
    self.messageNo = p.messageNo;//序列号，数值型
    self.type = p.type;//消息类型
    self.messageId = p.messageId;//消息标识号，字符串
    self.fromId = p.fromId;//源
    self.toId = p.toId;//目标
    self.fromUserName = p.fromUserName;//源
    self.fromUserId = p.fromUserId;//源
    self.toUserId = p.toUserId;//目标
    self.toUserName = p.toUserName;//目标
    self.content = p.content;//内容
    self.fileName = p.fileName;//文件名
    self.objectId = p.objectId;//对象ID
    self.fileSize = p.fileSize;//文件尺寸
    self.timeLen = p.timeLen;//录音时长
    self.isSend = p.isSend;//是否已送达
    self.isRead = p.isRead;//是否已读
    self.isReceive = p.isReceive;//是否下载
    self.isUpload = p.isUpload;//是否上传完成
    self.location_x = p.location_x;//位置经度
    self.location_y = p.location_y;//位置纬度
    self.timeSend = p.timeSend;//发送的时间
    self.deleteTime = p.deleteTime;   // 消息过期时间
    self.timeReceive = p.timeReceive;//收到回执的时间
    self.fileData = p.fileData;//文件内容
    self.isMySend = p.isMySend;//是否是自己发送
    self.isGroup = p.isGroup;//是否群聊
    self.isReadDel = p.isReadDel;//是否阅后即焚
    self.readTime = p.readTime; // 已读时间
    self.readPersons = p.readPersons;   // 已读人数
    self.chatMsgHeight = p.chatMsgHeight;   // 聊天消息行高
    self.isShowTime = p.isShowTime;
    self.signature = p.signature;
    self.isVerifySignatureFailed = p.isVerifySignatureFailed;
}

+(void)msgWithFriendStatus:(NSString*)userId status:(int)status{
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc] init];
    
    BOOL isRoom = [userId length]>15;
    int n = kWCMessageTypeRemind;
    NSString* s=nil;
    switch (status) {
        case friend_status_black:
            if(isRoom)
                s = Localized(@"JXMessageObject_ShieldMessage");
            else
                s = Localized(@"JXMessageObject_AddBlack");
            break;
        case friend_status_none:
            s = Localized(@"JXMessageObject_NotFriend");
            break;
        case friend_status_see:
            s = Localized(@"JXMessageObject_FollowHim");
            break;
        case friend_status_friend:
            if(isRoom)
                s = Localized(@"JXMessageObject_ReceMessage");
            else{
//                s = Localized(@"JXFriendObject_StartChat");
//                n = kWCMessageTypeText;
                s = Localized(@"JXMessageObject_BeFriendAndChat");
            }
            break;
    }
    
    msg.type = [NSNumber numberWithInt:n];
    msg.toUserId = userId;
    msg.fromUserId = MY_USER_ID;
    msg.fromUserName = MY_USER_NAME;
    msg.content = s;
    msg.timeSend = [NSDate date];
    [msg insert:nil];
    [msg updateLastSend:UpdateLastSendType_None];
    [msg notifyNewMsg];
}

-(NSString*)getContentValue:(NSString*)key{
    SBJsonParser * resultParser = [[SBJsonParser alloc] init];
    NSDictionary* resultObject = [resultParser objectWithString:self.content];
    //    [resultParser release];
    
    return [resultObject objectForKey:key];
}

-(NSString*)getContentValue:(NSString*)key subKey:(NSString*)subKey{
    SBJsonParser * resultParser = [[SBJsonParser alloc] init];
    NSDictionary* resultObject = [resultParser objectWithString:self.content];
    //    [resultParser release];
    
    return [(NSDictionary *)[resultObject objectForKey:key] objectForKey:subKey];
}

-(NSString*)getContentValue:(NSString*)key index:(int)i{
    SBJsonParser * resultParser = [[SBJsonParser alloc] init];
    NSDictionary* resultObject = [resultParser objectWithString:self.content];
    //    [resultParser release];
    
    return [[resultObject objectForKey:key] objectAtIndex:i];
}

//-(void)downloadFile:(TFJunYou_ImageView*)iv{
//    if([content length]<=0)
//        return;
//    if(self.isMySend && [[NSFileManager defaultManager] fileExistsAtPath:fileName] ){//如本地文件存在
//        if([[fileName pathExtension] isEqualToString:@"jpg"] && iv!=nil){
//            UIImage* p = [[UIImage alloc] initWithContentsOfFile:fileName];
//            iv.image = p;
//        }
//        return;
//    }
//    
//    NSString* ext  = [[content lastPathComponent] pathExtension];
//    NSString *filepath = [myTempFilePath stringByAppendingPathComponent:[content lastPathComponent]];
//    
//    if( ![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
//        [g_server addTask:content param:iv toView:self];
//    }
//    else{
//        if([ext isEqualToString:@"jpg"] && iv!=nil){
//            UIImage* p = [[UIImage alloc] initWithContentsOfFile:filepath];
//            iv.image = p;
//        }
//        [self doSaveOK];
//    }
//    
//    filepath = nil;
//    ext = nil;
//}

- (void)didServerResultSucces:(TFJunYou_Connection *)task dict:(NSDictionary *)dict array:(NSArray *)array1{
    
    [self doSaveOK];
}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [self doSaveError];
    return hide_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [self doSaveError];
    return hide_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}

-(void)doSaveError{
    NSLog(@"http失败");
    [self updateIsReceive:transfer_status_no];
    [g_notify postNotificationName:kMsgDrawIsReceiveNotifaction object:self];
}

-(void)doSaveOK{
    self.fileName = [myTempFilePath stringByAppendingPathComponent:[content lastPathComponent]];
    [self updateIsReceive:transfer_status_yes];
    [g_notify postNotificationName:kMsgDrawIsReceiveNotifaction object:self];
}

-(void)sendAlreadyReadMsg{//发送“已读”消息
    if(![self.isSend boolValue])//消息未送达，不发
       return;
    if(self.isGroup && !self.showRead)//单聊消息，未@我，showRead为假，均不发；语音消息，发
        return;
    if(![self isVisible])
        return;
    if ([self.isRead intValue] == 0 && !self.isMySend){//未读并且不是我发送的
        if(self.messageId==nil)
            [self setMsgId];
        
        TFJunYou_MessageObject * p = [[TFJunYou_MessageObject alloc]init];
        NSString* room=nil;
        p.content = self.messageId;
        p.type = [NSNumber numberWithInt:kWCMessageTypeIsRead];
        if(self.isGroup){
            p.toUserId = self.toUserId;
            room = p.toUserId;
        }
        else
            p.toUserId = self.fromUserId;
        p.fromUserId = MY_USER_ID;
        p.fromUserName = MY_USER_NAME;
        p.isRead = [NSNumber numberWithInt:1];
        p.timeSend = [NSDate date];
        p.sendCount = 10;
        p.isGroup = self.isGroup;
        //获取msgID
        [p setMsgId];
        
        [p insert:nil];
        [g_xmpp sendMessage:p roomName:room];
    }
}

// 更新消息
-(BOOL)update{
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    
    NSString *content = self.content;
#ifdef IS_MsgEncrypt
//    if (!self.isGroup) {
        content = [g_msgUtil encryptInsertChatMsgContent:self.content msgId:self.messageId];
//    }
#endif
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set content=?,type=? where messageId=?",[self getTableName]];
    
    BOOL worked=[db executeUpdate:sql,content, self.type, self.messageId];
    //        FMDBQuickCheck(worked);
    db = nil;
    [g_App copyDbWithUserId:MY_USER_ID];
    
    return worked;
}

-(BOOL)queryIsRead{
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* sql= [NSString stringWithFormat:@"select isRead from msg_%@ where messageId=?",[self getTableName]];
    FMResultSet *rs=[db executeQuery:sql,self.messageId];
    while ([rs next]) {
        return [[rs objectForColumnName:kMESSAGE_ISREAD] boolValue];
    }
    return NO;
}

-(NSTimeInterval)queryReadTime{
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* sql= [NSString stringWithFormat:@"select readTime from msg_%@ where messageId=?",[self getTableName]];
    FMResultSet *rs=[db executeQuery:sql,self.messageId];
    while ([rs next]) {
        return [[rs objectForColumnName:kMESSAGE_readTime] doubleValue];
    }
    return 0;
}


-(void)doGroupFileMsg{
    NSString* room = self.objectId;
    TFJunYou_MessageObject* msg = self;
    
    NSString* s=nil;
    switch ([msg.type intValue]) {
        case kWCMessageTypeGroupFileUpload:
            s = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_fileUpload"),msg.fileName];
            break;
        case kWCMessageTypeGroupFileDelete:
            s = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_fileDelete"),msg.fileName];
            break;
        case kWCMessageTypeGroupFileDownload:
            s = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_fileDownload"),msg.fileName];
            break;
        default:
            break;
    }
    msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
    msg.fromId = nil;
    msg.toId = nil;
    msg.fromUserId = msg.fromUserId;
    msg.toUserId = room;
    msg.content = s;
    if ([msg insert:room]){
        [msg updateLastSend:UpdateLastSendType_Add];
    }else {
        msg.isRepeat = YES;
    }
    [msg notifyNewMsg];
}


-(void)changeVideoChatContent{//改变音视频通话消息的content
    if(([type intValue]<100 || [type intValue]>120) && [type intValue] != kWCMessageTypeAVBusy)
        return;
    switch ([type intValue]) {
            //以下不可见消息，不需要赋值
        case kWCMessageTypeAudioChatAsk:
            content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_invite"),Localized(@"JXSip_Audiocall")];
            break;
        case kWCMessageTypeVideoChatAsk:
            content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_invite"),Localized(@"JXSip_Videocall")];
            break;
        case kWCMessageTypeAudioChatReady:
            content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_ready"),Localized(@"JXSip_Audiocall")];
            break;
        case kWCMessageTypeVideoChatReady:
            content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_ready"),Localized(@"JXSip_Videocall")];
            break;
        case kWCMessageTypeAudioChatAccept:
            content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_Accepted"),Localized(@"JXSip_Audiocall")];
            break;
        case kWCMessageTypeVideoChatAccept:
            content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_Accepted"),Localized(@"JXSip_Videocall")];
            break;
            //以上不可见消息，不需要赋值
        case kWCMessageTypeAudioChatCancel:
            if([timeLen intValue]>0)
                content      = self.isMySend ? Localized(@"JX_MeetingHangUpToMe") : Localized(@"JXSip_noanswer");
            else
                content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_Canceled"),Localized(@"JXSip_Audiocall")];
            break;
        case kWCMessageTypeVideoChatCancel:
            if([timeLen intValue]>0)
                content      = self.isMySend ? Localized(@"JX_MeetingHangUpToMe") : Localized(@"JXSip_noanswer");
            else
                content      = [NSString stringWithFormat:@"%@%@",Localized(@"JXSip_Canceled"),Localized(@"JXSip_Videocall")];
            break;
        case kWCMessageTypeAudioChatEnd:{
            NSString *timeLenStr = [TimeUtil getTimeShort1:[timeLen longLongValue]];
            content      = [NSString stringWithFormat:@"%@%@,%@:%@",Localized(@"JXSip_finished"),Localized(@"JXSip_Audiocall"),Localized(@"JXSip_timeLenth"),timeLenStr];
        }
            break;
        case kWCMessageTypeVideoChatEnd:{
            
            NSString *timeLenStr = [TimeUtil getTimeShort1:[timeLen longLongValue]];
            content      = [NSString stringWithFormat:@"%@%@,%@:%@",Localized(@"JXSip_finished"),Localized(@"JXSip_Videocall"),Localized(@"JXSip_timeLenth"),timeLenStr];
        }
            break;
        case kWCMessageTypeAudioMeetingInvite:
            content      = Localized(@"JXMeeting_InviteAudioMeeting");
            break;
        case kWCMessageTypeVideoMeetingInvite:
            content      = Localized(@"JXMeeting_InviteVideoMeeting");
            break;
        case kWCMessageTypeAVBusy:{
            if ([self.fromUserId isEqualToString:MY_USER_ID]) {
                self.fromUserId = [self.toUserId copy];
                self.toUserId = MY_USER_ID;
                content = @"忙线未接听";
            }else {
                self.toUserId = [self.fromUserId copy];
                self.fromUserId = MY_USER_ID;
                content = @"对方忙线中";
            }
        }
            break;
    }
}

-(BOOL)isVisible{//如果为NO则不发送已读消息，且不更新最近聊天内容字段，且发通知和可见消息分开，走另一通知
    switch ([self.type intValue]) {
        case kWCMessageTypeNone:
        case kWCMessageTypeIsRead:
        case kWCMessageTypeAudioChatAsk:
        case kWCMessageTypeAudioChatReady:
        case kWCMessageTypeAudioChatAccept:
        case kWCMessageTypeVideoChatAsk:
        case kWCMessageTypeVideoChatReady:
        case kWCMessageTypeVideoChatAccept:
        case kWCMessageTypeRelay:
        case kWCMessageTypeAudioMeetingInvite:
        case kWCMessageTypeVideoMeetingInvite:
        case kWCMessageTypeTalkInvite:
        case kWCMessageTypeTalkJoin:
        case kWCMessageTypeTalkQuit:
        case kWCMessageTypeAudioMeetingSetSpeaker:
        case kWCMessageTypeAudioMeetingAllSpeaker:
        case kWCMessageTypeTalkOnline:
        case kWCMessageTypeTalkOut:
        case kWCMessageTypeDelMsgTwoSides:
//        case kWCMessageTypeWithdraw:
            return NO;
        case kWCMessageTypeAudioChatCancel:
        case kWCMessageTypeAudioChatEnd:
        case kWCMessageTypeVideoChatCancel:
        case kWCMessageTypeVideoChatEnd:
        case kWCMessageTypeWithdraw:
        case kWCMessageTypeAVBusy:
            return YES;
        default:
            return [self.type intValue]<100;
    }
}

-(BOOL)isPinbaMsg{
    switch ([self.type intValue]) {
//        case kWCMessageTypeEnterpriseJob:
        case kWCMessageTypePersonJob:
//        case kWCMessageTypeResume:
        case kWCMessageTypePhoneAsk:
        case kWCMessageTypePhoneAnswer:
        case kWCMessageTypeResumeAsk:
        case kWCMessageTypeResumeAnswer:
        case kWCMessageTypeExamSend:
        case kWCMessageTypeExamAccept:
        case kWCMessageTypeExamEnd:
            return YES;
            break;
        default:
            return NO;
    }
}
-(BOOL)isRoomControlMsg{//房间控制消息
    return [self.type intValue]/100==9;
//    switch ([self.type intValue]) {
//        case kRoomRemind_RoomName:
//        case kRoomRemind_NickName:
//        case kRoomRemind_DelRoom:
//        case kRoomRemind_DelMember:
//        case kRoomRemind_NewNotice:
//        case kRoomRemind_DisableSay:
//        case kRoomRemind_AddMember:
//        case kRoomRemind_LiveBarrage:
//        case kRoomRemind_LiveGift:
//        case kRoomRemind_LivePraise:
//        case kRoomRemind_SetManage:
//        case kRoomRemind_EnterLiveRoom:
//        case kRoomRemind_ShowRead:
//            return YES;
//            break;
//        default:
//            return NO;
//    }
}

-(BOOL)isAudioMeetingMsg{//语音会议消息
    switch ([self.type intValue]) {
        case kWCMessageTypeAudioMeetingInvite:
        case kWCMessageTypeAudioMeetingJoin:
        case kWCMessageTypeAudioMeetingQuit:
//        case kWCMessageTypeAudioMeetingKick:
//        case kWCMessageTypeAudioMeetingSetSpeaker:
//        case kWCMessageTypeAudioMeetingAllSpeaker:
            return YES;
            break;
        default:
            return NO;
    }
}

-(BOOL)isAddFriendMsg{
 
    NSString *typeStr =[NSString stringWithFormat:@"%@",self.type];
    return [typeStr intValue]/100==5;
}

// 获取已读列表
- (NSMutableArray *)fetchReadList {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    NSString *queryString = nil;
    
    NSString *messageId = self.messageId;
#ifdef IS_MsgEncrypt
//    if (!self.isGroup) {
        messageId = [g_msgUtil encryptInsertChatMsgContent:self.messageId msgId:self.messageId];
//    }
#endif
    queryString = [NSString stringWithFormat:@"select * from msg_%@ where content=?",[self getTableName]];
    
    FMResultSet *rs=[db executeQuery:queryString,messageId];
    while ([rs next]) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        user.userId = [rs objectForColumnName:kMESSAGE_FROM];
        user.userNickname = [rs objectForColumnName:kMESSAGE_FROM_NAME];
        user.timeSend = [rs dateForColumn:kMESSAGE_TIMESEND];
        [messageList addObject:user];
    }
    [rs close];
    db = nil;
    
    return messageList;
}

-(void)getHistory:(NSArray*)array userId:(NSString*)userId{//获取聊天历史记录
    for (NSInteger i = 0; i < array.count;  i ++) {
        NSDictionary *dict = array[i];
        
        NSString *jsonMsg = dict[@"message"];
        SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
        NSDictionary *jsonDic = [resultParser objectWithString:jsonMsg];
        
        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        [msg fromDictionary:jsonDic];
        msg.timeSend = [NSDate dateWithTimeIntervalSince1970:[[jsonDic objectForKey:kMESSAGE_TIMESEND] doubleValue] / 1000.0];
        msg.messageId = [(NSDictionary *)[jsonDic objectForKey:@"messageHead"] objectForKey:@"messageId"];
//        if([userId length]>15){
//            [msg fromDictionary:jsonDic];
//            msg.isGroup = YES;
//        }
//        else
//            [msg fromXmlDict:jsonDic];
        
        [self setRemindMsg:msg];
        
        msg.toUserId = userId;
        
//        if(![msg isVisible] && [msg.type intValue]!=kWCMessageTypeIsRead)
//            continue;
        
        //调整是不是自己发的
        if ([msg.fromUserId isEqualToString:MY_USER_ID])
            msg.isMySend = YES;
        
        if (jsonDic[@"isRead"] && msg.isMySend) {
            msg.isRead = jsonDic[@"isRead"];
        }else {
            msg.isRead = [NSNumber numberWithInt:1];
        }
        msg.updateLastContent = 0;//临时不更新的标志
        [msg insert:userId];
        msg.updateLastContent = 1;//恢复
        
//        msg.chatMsgHeight = [NSString stringWithFormat:@"%f",[self getMsgChatHeight:msg]];
//        [msg updateChatMsgHeight];
    }
}

- (void)setRemindMsg:(TFJunYou_MessageObject *)msg {

    NSString *content;
    NSString *fromUserId = msg.fromUserId;
    NSString *fromUserName = msg.fromUserName;
    if (!fromUserName) {
        fromUserName = @"";
    }
    NSString *toUserId = msg.toUserId;
    NSString *toUserName = msg.toUserName;
    if (IsStringNull(toUserName)) {
        toUserName = @"";
    }
    
    switch ([msg.type integerValue]) {
        case kWCMessageTypeWithdraw:{
            if (msg.isGroup) {
                
                if ([fromUserId isEqualToString:MY_USER_ID]) {
                    content = Localized(@"JX_AlreadyWithdraw");
                }else {
                    content = [NSString stringWithFormat:@"%@ %@",fromUserName, Localized(@"JX_OtherWithdraw")];
                    
                }
            }else {
                if ([fromUserId isEqualToString:MY_USER_ID]) {
                    
                    content = Localized(@"JX_AlreadyWithdraw");
                }else {
                    content = [NSString stringWithFormat:@"%@ %@",fromUserName, Localized(@"JX_OtherWithdraw")];
                }
            }
        }
            break;
            
        case kWCMessageTypeRedPacketReceive:
            if (![fromUserId isEqualToString:MY_USER_ID]) {
                content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXRed_whoGet")];
            }else {
                content = [NSString stringWithFormat:Localized(@"JX_GetRedPacketFromFriend"),toUserName];
            }
            break;
        case kWCMessageTypeRedPacketReturn:
            content = [NSString stringWithFormat:@"%@",Localized(@"JX_ RedEnvelopeExpired")];
            break;
        case kWCMessageTypeGroupFileUpload:
            
            content = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_fileUpload"),msg.fileName];
//            content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXMessage_fileUpload")];
            break;
        case kWCMessageTypeGroupFileDelete:
            
            content = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_fileDelete"),msg.fileName];
//            content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXMessage_fileDelete")];
            break;
        case kWCMessageTypeGroupFileDownload:
            
            content = [NSString stringWithFormat:@"%@%@:%@",msg.fromUserName,Localized(@"JXMessage_fileDownload"),msg.fileName];
//            content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXMessage_fileDownload")];
            break;
        case kRoomRemind_RoomName:
            content = [NSString stringWithFormat:@"%@%@%@",fromUserName,Localized(@"JXMessageObject_UpdateRoomName"),msg.content];
            break;
        case kRoomRemind_NickName:{
            content = [NSString stringWithFormat:@"%@%@%@",fromUserName,Localized(@"JXMessageObject_UpdateNickName"),msg.content];
        }
            break;
        case kRoomRemind_DelRoom:
            if ([toUserId isEqualToString:MY_USER_ID]) {
                content = [NSString stringWithFormat:Localized(@"JX_DissolutionGroup"),fromUserName];
            }else {
                content = [NSString stringWithFormat:@"%@%@:%@",fromUserName,Localized(@"JXMessage_delRoom"),msg.content];
            }
            
            break;
        case kRoomRemind_AddMember:
            if([toUserId isEqualToString:fromUserId] || IS_OTHER_DEVICE(toUserId) || IS_OTHER_DEVICE(fromUserId))
                content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXMessageObject_GroupChat")];
            else
                content = [NSString stringWithFormat:@"%@%@%@",fromUserName,Localized(@"JXMessageObject_InterFriend"),toUserName];
            break;
        case kLiveRemind_ExitRoom:
            if([toUserId isEqualToString:fromUserId]){
                content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"EXITED_LIVE_ROOM")];//退出
                
            }else{
                content = [NSString stringWithFormat:@"%@%@",toUserName,Localized(@"JX_LiveVC_kickLive")];//被踢出
            }
            break;
        case kRoomRemind_DelMember:
            if([toUserId isEqualToString:fromUserId]){
                content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXMessageObject_OutGroupChat")];
            }else{
                if ([toUserId isEqualToString:MY_USER_ID]) {
                    content = [NSString stringWithFormat:Localized(@"JX_OutOfTheGroup"),fromUserName];
                }else {
                    if ([fromUserName isEqualToString:toUserName]) {
                        content = [NSString stringWithFormat:@"%@%@",fromUserName,Localized(@"JXRoomMemberVC_OutPutRoom")];
                    }else {
                        content = [NSString stringWithFormat:@"%@%@%@",fromUserName,Localized(@"JXMessageObject_KickOut"),toUserName];
                    }
                }
            }
            
            break;
        case kRoomRemind_NewNotice:
        case kRoomRemind_editNotice:
            content = [NSString stringWithFormat:@"%@%@%@",fromUserName,Localized(@"JXMessageObject_AddNewAdv"),msg.content];
            break;
        case kLiveRemind_ShatUp:
        case kRoomRemind_DisableSay:{
            if([msg.content longLongValue]==0){
                content = [NSString stringWithFormat:@"%@%@%@%@",fromUserName,Localized(@"JXMessageObject_Yes"),toUserName,Localized(@"JXMessageObject_CancelGag")];
            }else{
                NSDate* d = [NSDate dateWithTimeIntervalSince1970:[msg.content longLongValue]];
                NSString* t = [TimeUtil formatDate:d format:@"MM-dd HH:mm"];
                content = [NSString stringWithFormat:@"%@%@%@%@%@",fromUserName,Localized(@"JXMessageObject_Yes"),toUserName,Localized(@"JXMessageObject_SetGagWithTime"),t];
                d = nil;
            }
            break;
        }
        case kLiveRemind_SetManager:
        case kRoomRemind_SetManage:{
            if ([msg.content integerValue] == 1) {
                content = [NSString stringWithFormat:@"%@%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"JXSettingVC_Set"),toUserName,Localized(@"JXMessage_admin")];
            }else {
                content = [NSString stringWithFormat:@"%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"CANCEL_ADMINISTRATOR"),toUserName];
            }
            break;
        }
        case kRoomRemind_EnterLiveRoom:{
            content = [NSString stringWithFormat:@"%@%@",toUserName,Localized(@"Enter_LiveRoom")];//加入房间消息
            break;
        }
        case kRoomRemind_ShowRead:{
            if ([msg.content integerValue] == 1)
                content = [NSString stringWithFormat:@"%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"JX_Enable"),Localized(@"JX_RoomReadMode")];
            else
                content = [NSString stringWithFormat:@"%@%@%@",Localized(@"JXGroup_Owner"),Localized(@"JX_Disable"),Localized(@"JX_RoomReadMode")];
            break;
        }
        case kRoomRemind_NeedVerify:{
            
            if (!msg.content || msg.content.length <= 0) {
                content = Localized(@"JX_GroupInvitationConfirmation");
            }else {
                if ([msg.content integerValue] == 1)
                    content = Localized(@"JX_GroupOwnersOpenValidation");
                else
                    content = Localized(@"JX_GroupOwnersCloseValidation");
            }
            
            break;
        }
        case kRoomRemind_IsLook:{
            if ([msg.content integerValue] == 0)
                content = Localized(@"JX_GroupOwnersPublicGroup");
            else
                content = Localized(@"JX_GroupOwnersPrivateGroup");
            break;
        }
            
        case kRoomRemind_ShowMember:{
            if ([msg.content integerValue] == 1)
                content = Localized(@"JX_GroupOwnersShowMembers");
            else
                content = Localized(@"JX_GroupOwnersNotShowMembers");
            break;
        }
            
        case kRoomRemind_allowSendCard:{
            if ([msg.content integerValue] == 1)
                content = Localized(@"JX_ManagerOpenChat");
            else
                content = Localized(@"JX_ManagerOffChat");
            break;
        }
            
        case kRoomRemind_RoomAllBanned:{
            if ([msg.content integerValue] > 0)
                content = Localized(@"JX_ManagerOpenSilence");
            else
                content = Localized(@"JX_ManagerOffSilence");
            break;
        }
            
        case kRoomRemind_RoomAllowInviteFriend:{
            if ([msg.content integerValue] > 0)
                content = Localized(@"JX_ManagerOpenInviteFriends");
            else
                content = Localized(@"JX_ManagerOffInviteFriends");
            break;
        }
            
        case kRoomRemind_RoomAllowUploadFile:{
            if ([msg.content integerValue] > 0)
                content = Localized(@"JX_ManagerOpenSharedFiles");
            else
                content = Localized(@"JX_ManagerOffSharedFiles");
            break;
        }
            
        case kRoomRemind_RoomAllowConference:{
            if ([msg.content integerValue] > 0)
                content = Localized(@"JX_ManagerOpenMeetings");
            else
                content = Localized(@"JX_ManagerOffMeetings");
            break;
        }
            
        case kRoomRemind_RoomAllowSpeakCourse:{
            if ([msg.content integerValue] > 0)
                content = Localized(@"JX_ManagerOpenLectures");
            else
                content = Localized(@"JX_ManagerOffLectures");
            break;
        }
            
        case kRoomRemind_RoomTransfer:{
            content = [NSString stringWithFormat:@"\"%@\"%@", toUserName,Localized(@"JX_NewGroupManager")];
            break;
        }
        case kRoomRemind_SetInvisible:{
            if ([msg.content integerValue] == 1) {
                content = [NSString stringWithFormat:@"%@%@%@%@",fromUserName,Localized(@"JXSettingVC_Set"),toUserName,Localized(@"JX_ForTheInvisibleMan")];
            }else if ([msg.content integerValue] == -1){
                content = [NSString stringWithFormat:@"%@%@%@",fromUserName,Localized(@"JX_EliminateTheInvisible"),toUserName];
            }else if ([msg.content integerValue] == 2){
                content = [NSString stringWithFormat:@"%@%@%@%@",fromUserName,Localized(@"JXSettingVC_Set"),toUserName,@"为监控人"];
            }else if ([msg.content integerValue] == 0){
                content = [NSString stringWithFormat:@"%@%@%@",fromUserName,@"取消监控人",toUserName];
            }
            break;
        }
            
        case kRoomRemind_RoomDisable:{
            if ([msg.content integerValue] == 1) {
                content = [NSString stringWithFormat:@"%@",Localized(@"JX_ThisGroupHasBeenDisabled")];
            }else {
                content = [NSString stringWithFormat:@"%@",Localized(@"JX_GroupNotUse")];
            }
            break;
        }
            
        case kRoomRemind_SetRecordTimeOut:{
            NSArray *pickerArr = @[Localized(@"JX_Forever"), Localized(@"JX_OneHour"), Localized(@"JX_OneDay"), Localized(@"JX_OneWeeks"), Localized(@"JX_OneMonth"), Localized(@"JX_OneQuarter"), Localized(@"JX_OneYear")];
            double outTime = [msg.content doubleValue];
            NSString *str;
            if (outTime <= 0) {
                str = pickerArr[0];
            }else if (outTime == 0.04) {
                str = pickerArr[1];
            }else if (outTime == 1) {
                str = pickerArr[2];
            }else if (outTime == 7) {
                str = pickerArr[3];
            }else if (outTime == 30) {
                str = pickerArr[4];
            }else if (outTime == 90) {
                str = pickerArr[5];
            }else{
                str = pickerArr[6];
            }
            content = [NSString stringWithFormat:@"%@%@",Localized(@"JX_GroupManagerSetMsgDelTime"),str];
        }
        default:
            break;
    }
    
    if (content.length > 0) {
        msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
        msg.content = content;
    }
    
}

-(BOOL)isAtMe{//是否@了我
    if(!self.isGroup || self.objectId==nil)
        return 0;
    if (![self.objectId isKindOfClass:[NSString class]]) {
        self.objectId = [NSString stringWithFormat:@"%@",self.objectId];
    }
    if([self.objectId isEqualToString:self.toUserId] && [self.type intValue] == 1)
        return 1;
    return [self.objectId rangeOfString:MY_USER_ID].location != NSNotFound;
}

- (BOOL)updateFromUserName{
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set fromUserName=? where fromUserId=?",self.objectId];
    
    BOOL worked=[db executeUpdate:sql,self.content, self.fromUserId];
    //        FMDBQuickCheck(worked);
    db = nil;
    return worked;
}

- (id)copyWithZone:(NSZone *)zone
{
    TFJunYou_MessageObject* newMsg = [[TFJunYou_MessageObject allocWithZone:zone] init];
    newMsg.messageId = self.messageId;
    newMsg.fromId = self.fromId;
    newMsg.toId = self.toId;
    newMsg.type = self.type;
    newMsg.fromUserId = self.fromUserId;
    newMsg.fromUserName = self.fromUserName;
    newMsg.toUserId = self.toUserId;
    newMsg.toUserName = self.toUserName;
    newMsg.content = self.content;
    newMsg.fileName = self.fileName;
    newMsg.objectId = self.objectId;
    newMsg.fileSize = self.fileSize;
    newMsg.timeLen = self.timeLen;
    newMsg.location_x = self.location_x;
    newMsg.location_y = self.location_y;
    newMsg.isReadDel = self.isReadDel;
    newMsg.isEncrypt = self.isEncrypt;
    newMsg.timeSend = self.timeSend;
    newMsg.deleteTime = self.deleteTime;
    newMsg.messageNo = self.messageNo;
    newMsg.isSend = self.isSend;
    newMsg.isRead = self.isRead;
    newMsg.isReceive = self.isReceive;
    newMsg.isUpload = self.isUpload;
    newMsg.timeReceive = self.timeReceive;
    newMsg.fileData = self.fileData;
    newMsg.readPersons = self.readPersons;
    newMsg.readTime = self.readTime;
    newMsg.isMySend = self.isMySend;
    newMsg.isGroup = self.isGroup;
    newMsg.isShowTime = self.isShowTime;
    newMsg.isDelay = self.isDelay;
    newMsg.imageWidth = self.imageWidth;
    newMsg.imageHeight = self.imageHeight;
    newMsg.dictionary = self.dictionary;
    newMsg.progress = self.progress;
    newMsg.index = self.index;
    newMsg.sendCount = self.sendCount;
    newMsg.updateLastContent = self.updateLastContent;
    newMsg.showRead = self.showRead;
    newMsg.chatMsgHeight = self.chatMsgHeight;
    newMsg.isShowTime = self.isShowTime;
    newMsg.signature = self.signature;
    newMsg.isVerifySignatureFailed = self.isVerifySignatureFailed;
    
    return newMsg;
}

- (BOOL)haveTheMessage {
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* sql= [NSString stringWithFormat:@"select messageId from msg_%@ where messageId=?",[self getTableName]];
    FMResultSet *rs=[db executeQuery:sql,self.messageId];
    while ([rs next]) {
        //        NSLog(@"不必重复保存:%@",self.messageId);
        return YES;
    }
    return NO;
}

- (BOOL)updateFileName {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set fileName=? where messageId=?",[self getTableName]];
    
    BOOL worked=[db executeUpdate:sql,self.fileName, self.messageId];
    //        FMDBQuickCheck(worked);
    db = nil;
    return worked;
    
}

- (BOOL)updateFileSize {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set fileSize=? where messageId=?",[self getTableName]];
    
    BOOL worked=[db executeUpdate:sql,self.fileSize, self.messageId];
    //        FMDBQuickCheck(worked);
    db = nil;
    return worked;
}

// 更新邀请群好友验证文件名，用于判断是否已确认验证
- (BOOL)updateNeedVerifyFileName; {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
    NSDictionary *resultObject = [resultParser objectWithString:self.objectId];
    NSString *roomJid = [resultObject objectForKey:@"roomJid"];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set fileName=? where messageId=?",roomJid];
    
    BOOL worked=[db executeUpdate:sql,self.fileName, self.messageId];
    //        FMDBQuickCheck(worked);
    db = nil;
    return worked;
}

// 更新消息行高
- (BOOL)updateChatMsgHeight {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set chatMsgHeight=? where messageId=? and type=?",[self getTableName]];
    
    BOOL worked=[db executeUpdate:sql,self.chatMsgHeight, self.messageId, self.type];
    
    return worked;
}

// 根据objectId获取消息
- (NSMutableArray *)getMsgWithObjectId:(NSString *)objectId {
    NSString* myUserId = MY_USER_ID;
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"select * from msg_%@ where objectId=?",[self getTableName]];
    
    FMResultSet *rs=[db executeQuery:sql,objectId];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc] init];
        [p fromRs:rs];
        [resultArr addObject:p];
    }
    
    [rs close];
    if([resultArr count]==0){
        resultArr = nil;
    }
    
    return resultArr;
}

// 更新所有消息行高
- (BOOL)updateAllChatMsgHeight {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"select * from sqlite_master where type='table'"];
    
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"name"];
        if ([name rangeOfString:@"msg_"].location != NSNotFound) {
            NSString *sql=[NSString stringWithFormat:@"update %@ set chatMsgHeight=? ",name];
            [db executeUpdate:sql,@"0"];
        }
    }
    
    return YES;
}

// 更新是否显示时间
- (BOOL)updateIsShowTime {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"update msg_%@ set isShowTime=? where messageId=?",[self getTableName]];
    
    BOOL worked=[db executeUpdate:sql,[NSNumber numberWithBool:self.isShowTime], self.messageId];
    
    return worked;
}

// 删除过期聊天记录
- (BOOL)deleteTimeOutMsg:(NSString *)userId chatRecordTimeOut:(NSString *)ChatRecordTimeOut {
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *sql=[NSString stringWithFormat:@"delete from msg_%@ where deleteTime < %f and deleteTime > 0",userId,[[NSDate date] timeIntervalSince1970]];
    
    BOOL worked=[db executeUpdate:sql];
    //        FMDBQuickCheck(worked);
    db = nil;
    return worked;
}

- (TFJunYou_MessageObject *)getMsgWithMsgId:(NSString *)msgId {
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:[self getTableName]];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* sql= [NSString stringWithFormat:@"select * from msg_%@ where messageId=?",[self getTableName]];
    FMResultSet *rs=[db executeQuery:sql,msgId];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc] init];
        p.isGroup = [user.roomFlag boolValue];
        [p fromRs:rs];
        
        return p;
    }
    
    return nil;
}

- (TFJunYou_MessageObject *)getMsgWithMsgId:(NSString *)msgId toUserId:(NSString *)toUserId {
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:toUserId];
    
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:MY_USER_ID];
    NSString* sql= [NSString stringWithFormat:@"select * from msg_%@ where messageId=?",toUserId];
    FMResultSet *rs=[db executeQuery:sql,msgId];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc] init];
        p.isGroup = [user.roomFlag boolValue];
        [p fromRs:rs];
        
        return p;
    }
    
    return nil;
}

// Message.pbobjc 转 TFJunYou_MessageObject
+ (TFJunYou_MessageObject *)getMsgObjWithPbobjc:(ChatMessage *)message {
 
    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
    
    msg.fromId = message.messageHead.from;
    msg.toId = message.messageHead.to;
    msg.messageId = message.messageHead.messageId;
    
    msg.fromUserId = message.fromUserId;
    msg.fromUserName = message.fromUserName;
    if (message.toUserId && message.toUserId.length > 0) {
        msg.toUserId = message.toUserId;
    }else {
        msg.toUserId = MY_USER_ID;
    }
    msg.toUserName = message.toUserName;
    msg.timeSend = [NSDate dateWithTimeIntervalSince1970:message.timeSend / 1000.0];
    msg.type = [NSNumber numberWithInt:message.type];
    msg.objectId = message.objectId;
    msg.fileName = message.fileName;
    msg.isEncrypt = [NSNumber numberWithBool:message.isEncrypt];
    msg.deleteTime = [NSDate dateWithTimeIntervalSince1970:message.deleteTime];
    msg.isReadDel = [NSNumber numberWithBool:message.isReadDel];
    msg.fileSize = [NSNumber numberWithLongLong:message.fileSize];
    msg.location_x = [NSNumber numberWithDouble:message.locationX];
    msg.location_y = [NSNumber numberWithDouble:message.locationY];
    msg.chatType = message.messageHead.chatType;
    msg.isDelay = message.messageHead.offline;
    msg.isRead = [NSNumber numberWithInt:0];
    msg.timeLen = [NSNumber numberWithLongLong:message.fileTime];
    
    if ([msg.isEncrypt boolValue]) {
        //        self.content = [DESUtil decryptDESStr:messCont key:[NSString stringWithFormat:@"%@",[p objectForKey:kMESSAGE_TIMESEND]]];
        NSMutableString *str = [NSMutableString string];
        [str appendString:APIKEY];
        [str appendString:[NSString stringWithFormat:@"%lld",message.timeSend]];
        [str appendString:msg.messageId];
        NSString *keyStr = [g_server getMD5String:str];
        msg.content = [DESUtil decryptDESStr:message.content key:keyStr];
        if (IsStringNull(msg.content)) {
            msg.content = message.content;
        }
        
    }else{
        msg.content = message.content;
    }
    
    return msg;
}

// TFJunYou_MessageObject 转 Message.pbobjc
- (ChatMessage *)getPbobjcObjWithMsg:(TFJunYou_MessageObject *)msg {
    
    ChatMessage *message = [[ChatMessage alloc] init];
    message.messageHead.from =  [NSString stringWithFormat:@"%@/%@",msg.fromUserId,SameResource];
    message.messageHead.to = msg.toUserId ? msg.toUserId : @"";
    message.messageHead.messageId = msg.messageId ? msg.messageId : @"";
    message.messageHead.chatType = msg.chatType;
    message.messageHead.offline = msg.isDelay;
    
    message.fromUserId = msg.fromUserId ? msg.fromUserId : @"";
    message.fromUserName = msg.fromUserName ? msg.fromUserName : @"";
    message.toUserId = msg.toUserId ? msg.toUserId : @"";
    message.toUserName = msg.toUserName ? msg.toUserName : @"";
    message.timeSend = [msg.timeSend timeIntervalSince1970] * 1000;
    message.type = [msg.type intValue];
    message.objectId = msg.objectId ? msg.objectId : @"";
    message.fileName = [NSString stringWithFormat:@"%@",msg.fileName ? msg.fileName : @""];
    message.isEncrypt = [msg.isEncrypt boolValue];
    message.deleteTime = [msg.deleteTime timeIntervalSince1970];
    message.isReadDel = [msg.isReadDel boolValue];
    message.fileSize = [msg.fileSize longLongValue];
    message.locationX = [msg.location_x doubleValue];
    message.locationY = [msg.location_y doubleValue];
    message.fileTime = [msg.timeLen intValue];
    
    if([self.isEncrypt boolValue]){
        NSMutableString *str = [NSMutableString string];
        [str appendString:APIKEY];
        [str appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:message.timeSend]]];
        [str appendString:msg.messageId];
        NSString *keyStr = [g_server getMD5String:str];
        message.content = [DESUtil encryptDESStr:msg.content key:keyStr];
//        [dictionary setValue:[DESUtil encryptDESStr:msg.content key:keyStr] forKey:kMESSAGE_CONTENT];
    }
    else
        message.content = msg.content ? msg.content : @"";
    
    return message;
}

@end
