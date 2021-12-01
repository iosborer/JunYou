#import "TFJunYou_Constant.h"
#import "FMDatabase.h"
#import "TFJunYou_MyTools.h"
#define DB_NAME @"constant.db"
@implementation TFJunYou_Constant
-(id)init{
    self = [super init];
    NSString *lang = [g_default stringForKey:kLocalLanguage];
    if (!lang || lang.length <= 0) {
        lang = [TFJunYou_MyTools getCurrentSysLanguage];
    }
    _sysLanguage =lang;
    _sysName = [self getCurCountryFieldName];
    _country = [[NSMutableDictionary alloc]init];
    _city = [[NSMutableDictionary alloc]init];
    _cityN = [[NSMutableDictionary alloc]init];
    _country_name = [[NSMutableArray alloc]init];
    _country_value = [[NSMutableArray alloc]init];
    _province_name = [[NSMutableArray alloc]init];
    _province_value = [[NSMutableArray alloc]init];
    _diploma_name = [[NSMutableArray alloc]init];
    _diploma_value = [[NSMutableArray alloc]init];
    _workexp_name = [[NSMutableArray alloc]init];
    _workexp_value = [[NSMutableArray alloc]init];
    _salary_name = [[NSMutableArray alloc]init];
    _salary_value = [[NSMutableArray alloc]init];
    _nature_name = [[NSMutableArray alloc]init];
    _nature_value = [[NSMutableArray alloc]init];
    _scale_name = [[NSMutableArray alloc]init];
    _scale_value = [[NSMutableArray alloc]init];
    _cometime_name = [[NSMutableArray alloc]init];
    _cometime_value = [[NSMutableArray alloc]init];
    _worktype_name = [[NSMutableArray alloc]init];
    _worktype_value = [[NSMutableArray alloc]init];
    _industry_name = [[NSMutableArray alloc]init];
    _industry_value = [[NSMutableArray alloc]init];
    _function_name = [[NSMutableArray alloc]init];
    _function_value = [[NSMutableArray alloc]init];
    _major_name = [[NSMutableArray alloc]init];
    _major_value = [[NSMutableArray alloc]init];
    _telArea = [[NSMutableArray alloc] init];
    _userBackGroundImage = [NSMutableDictionary dictionary];
    [self getData];
    return self;
}
- (void) getData {
    [self getTelArea];
    self.city  = [self getCity];
    self.cityN = [self getCity2];
    self.country  = [self getCountrys];
    self.diploma  = [self getDiploma];
    self.workexp  = [self getWorkExp];
    self.salary   = [self getSalary];
    self.nature   = [self getNature];
    self.scale    = [self getScale];
    self.cometime = [self getComeTime];
    self.worktype = [self getWorkType];
    self.industry = [self getIndustry];
    self.function = [self getFunction];
    self.major    = [self getMajor];
    self.localized = [self getLocalized];
    self.userBackGroundImage = [self getUserBackGroundImage];
    CGFloat chatFont = [[g_default objectForKey:kChatFont] floatValue];
    if (chatFont > 0) {
        self.chatFont = chatFont;
    }else {
        self.chatFont = 15.0;
    }
}
- (NSMutableDictionary *)getUserBackGroundImage {
    NSString *path = backImage;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    return dict;
}
-(void)dealloc{
    self.country = nil;
    self.province = nil;
    self.city = nil;
    self.cityN = nil;
    self.diploma = nil;
    self.workexp = nil;
    self.salary = nil;
    self.nature = nil;
    self.scale = nil;
    self.cometime = nil;
    self.worktype = nil;
    self.industry = nil;
    self.function = nil;
    self.major = nil;
    self.localized = nil;
    self.country_name = nil;
    self.country_value = nil;
    self.province_name = nil;
    self.province_value = nil;
    self.diploma_name = nil;
    self.diploma_value = nil;
    self.workexp_name = nil;
    self.workexp_value = nil;
    self.salary_name = nil;
    self.salary_value = nil;
    self.nature_name = nil;
    self.nature_value = nil;
    self.scale_name = nil;
    self.scale_value = nil;
    self.cometime_name = nil;
    self.cometime_value = nil;
    self.worktype_name = nil;
    self.worktype_value = nil;
    self.industry_name = nil;
    self.industry_value = nil;
    self.function_name = nil;
    self.function_value = nil;
    self.major_name = nil;
    self.major_value = nil;
    [_db close];
}
- (FMDatabase*)openDB{
        if(_db && [_db goodConnection])
            return _db;
    NSString* s = [NSString stringWithFormat:@"%@%@",imageFilePath,DB_NAME];
    [_db close];
    _db = [[FMDatabase alloc] initWithPath:s];
    if (![_db open]) {
        return nil;
    };
    return _db;
}
- (NSMutableArray *)emojiArray {
    NSString* sql= [NSString stringWithFormat:@"select filename,english,chinese,sort from emoji order by sort"];
    FMDatabase *db = [self openDB];
    FMResultSet *rs = [db executeQuery:sql];
    NSMutableArray *dataArr = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[rs stringForColumn:@"filename"] forKey:@"filename"];
        [dic setObject:[rs stringForColumn:@"english"] forKey:@"english"];
        [dic setObject:[rs stringForColumn:@"chinese"] forKey:@"chinese"];
        [dataArr addObject:dic];
    }
    return dataArr;
}
#pragma mark----获取语言字典
-(NSMutableDictionary*) getLocalized{
    NSString* sql= [NSString stringWithFormat:@"select ios,%@ from lang",_sysName];
    FMDatabase *db = [self openDB];
    FMResultSet *rs = [db executeQuery:sql];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while ([rs next]) {
        [dict setObject:[rs stringForColumn:_sysName] forKey:[rs stringForColumn:@"ios"]];
    }
    return dict;
}
-(NSMutableDictionary*) getCountrys{
    NSString* sql= [NSString stringWithFormat:@"select %@,id from tb_areas where type=1",_sysLanguage];
    return [self doGetDict1:sql name:_country_name value:_country_value];
}
-(NSMutableDictionary*) getProvince:(int)countryId{
    [_province_name removeAllObjects];
    [_province_value removeAllObjects];
    NSString* sql= [NSString stringWithFormat:@"select %@,id from tb_areas where type=2 and parent_Id=%d order by id",@"name",countryId];
    return [self doGetDict1:sql name:_province_name value:_province_value];
}
-(NSMutableDictionary*) getCity2{
    NSString* sql= [NSString stringWithFormat:@"select name,id from tb_areas"];
    return [self doGetDict2:sql name:nil value:nil];
}
-(NSMutableDictionary*) getCity{
    NSString* sql= [NSString stringWithFormat:@"select %@,id from tb_areas",@"name"];
    return [self doGetDict1:sql name:nil value:nil];
}
-(NSMutableDictionary*) getCity:(int)provinceId{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    FMDatabase* db = [self openDB];
    NSString* sql= [NSString stringWithFormat:@"select %@,id from tb_areas where type=3 and parent_Id=%d",@"name",provinceId];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [dict setObject:[rs objectForColumnName:@"name"] forKey:[self formatId:[rs objectForColumnName:@"id"]]];
    }
    return dict;
}
-(NSMutableDictionary*) getArea:(int)cityId{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    FMDatabase* db = [self openDB];
    NSString* sql= [NSString stringWithFormat:@"select %@,id from tb_areas where type=4 and parent_Id=%d",_sysLanguage,cityId];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [dict setObject:[rs objectForColumnName:_sysLanguage] forKey:[self formatId:[rs objectForColumnName:@"id"]]];
    }
    return dict;
}
-(NSMutableDictionary*) getDiploma{
    return [self doGetDict:1 name:_diploma_name value:_diploma_value];
}
-(NSMutableDictionary*) getWorkExp{
    return [self doGetDict:2 name:_workexp_name value:_workexp_value];
}
-(NSMutableDictionary*) getSalary{
    return [self doGetDict:3 name:_salary_name value:_salary_value];
}
-(NSMutableDictionary*) getNature{
    return [self doGetDict:32 name:_nature_name value:_nature_value];
}
-(NSMutableDictionary*) getScale{
    return [self doGetDict:44 name:_scale_name value:_scale_value];
}
-(NSMutableDictionary*) getComeTime{
    return [self doGetDict:52 name:_cometime_name value:_cometime_value];
}
-(NSMutableDictionary*) getWorkType{
    return [self doGetDict:59 name:_worktype_name value:_worktype_value];
}
-(NSMutableDictionary*) getIndustry{
    NSMutableDictionary* d = [[NSMutableDictionary alloc]init];
    [self getTree:63 name:_industry_name value:_industry_value];
    for (int i=0; i<[_industry_name count]; i++) {
        [d setObject:[_industry_name objectAtIndex:i] forKey:[_industry_value objectAtIndex:i]];
    }
    return d;
}
-(NSMutableDictionary*) getFunction{
    NSMutableDictionary* d = [[NSMutableDictionary alloc]init];
    [self getTree:64 name:_function_name value:_function_value];
    for (int i=0; i<[_function_name count]; i++) {
        [d setObject:[_function_name objectAtIndex:i] forKey:[_function_value objectAtIndex:i]];
    }
    return d;
}
-(NSMutableDictionary*) getMajor{
    NSMutableDictionary* d = [[NSMutableDictionary alloc]init];
    [self getTree:1005 name:_major_name value:_major_value];
    for (int i=0; i<[_major_name count]; i++) {
        [d setObject:[_major_name objectAtIndex:i] forKey:[_major_value objectAtIndex:i]];
    }
    return d;
}
-(NSMutableDictionary*)doGetDict2:(NSString*)sql name:(NSMutableArray*)name value:(NSMutableArray*)value{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    FMDatabase* db = [self openDB];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [name addObject:[rs objectForColumnName:@"id"]];
        [value addObject:[self formatId:[rs objectForColumnName:@"name"]]];
        [dict setObject:[rs objectForColumnName:@"id"] forKey:[self formatId:[rs objectForColumnName:@"name"]]];
    }
    return dict;
}
-(NSMutableDictionary*)doGetDict1:(NSString*)sql name:(NSMutableArray*)name value:(NSMutableArray*)value{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    FMDatabase* db = [self openDB];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [name addObject:[rs objectForColumnName:@"name"]];
        [value addObject:[self formatId:[rs objectForColumnName:@"id"]]];
        [dict setObject:[rs objectForColumnName:@"name"] forKey:[self formatId:[rs objectForColumnName:@"id"]]];
    }
    return dict;
}
-(NSMutableDictionary*)doGetDict:(int)n name:(NSMutableArray*)name value:(NSMutableArray*)value{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    FMDatabase* db = [self openDB];
    NSString* sql= [NSString stringWithFormat:@"select name,id from tb_constants where parent_Id=%d",n];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [name addObject:[rs objectForColumnName:@"name"]];
        [value addObject:[self formatId:[rs objectForColumnName:@"id"]]];
        [dict setObject:[rs objectForColumnName:@"name"] forKey:[self formatId:[rs objectForColumnName:@"id"]]];
    }
    return dict;
}
-(void)getNameValues:(int)n name:(NSMutableArray*)name value:(NSMutableArray*)value{
    FMDatabase* db = [self openDB];
    NSString* sql= [NSString stringWithFormat:@"select name,id from tb_constants where parent_Id=%d",n];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [name addObject:[rs objectForColumnName:@"name"]];
        [value addObject:[self formatId:[rs objectForColumnName:@"id"]]];
    }
}
-(void)getTree:(int)n name:(NSMutableArray*)name value:(NSMutableArray*)value{
    FMDatabase* db = [self openDB];
    NSString* sql= [NSString stringWithFormat:@"select name,id from tb_constants where parent_Id=%d",n];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        [name addObject:[rs objectForColumnName:@"name"]];
        [value addObject:[self formatId:[rs objectForColumnName:@"id"]]];
        [self getTree:[[rs objectForColumnName:@"id"] intValue] name:name value:value];
    }
}
-(NSNumber*)formatId:(NSNumber*)n{
    return n;
}
-(NSArray*)getSortKeys:(NSMutableDictionary*)dict{
    NSArray* keys = [dict allKeys];
    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    return keys;
}
-(NSArray*)getSortValues:(NSMutableDictionary*)dict{
    NSArray* keys = [self getSortKeys:dict];
    NSMutableArray* values = [[NSMutableArray alloc]init];
    for(int i=0;i<[keys count];i++)
        [values addObject:[dict objectForKey:[keys objectAtIndex:i]]];
    return values;
}
-(NSString*)getAddress:(NSString*)provinceId cityId:(NSString*)cityId areaId:(NSString*)areaId{
    NSString* s=nil;
    if(provinceId)
        s = provinceId;
    else
        s = @"";
    if(cityId){
        if(cityId != provinceId){
            if (s.length > 0) {
                s = [s stringByAppendingString:@"-"];
            }
            s = [s stringByAppendingString:cityId];
        }
    }
    if(areaId){
        if(cityId != areaId){
            if (s.length > 0) {
                s = [s stringByAppendingString:@"-"];
            }
            s = [s stringByAppendingString:areaId];
        }
    }
    return s;
}
-(NSString*)getAddressForInt:(int)provinceId cityId:(int)cityId areaId:(int)areaId{
    NSString* p  = [_city objectForKey:[NSNumber numberWithInt:provinceId]];
    NSString* c  = [_city objectForKey:[NSNumber numberWithInt:cityId]];
    NSString* a  = [_city objectForKey:[NSNumber numberWithInt:areaId]];
    NSString* address = [self getAddress:p cityId:c areaId:a];
    return address;
}
-(NSString*)getAddressForNumber:(NSNumber*)provinceId cityId:(NSNumber*)cityId areaId:(NSNumber*)areaId{
    NSString* p  = [_city objectForKey:provinceId];
    NSString* c  = [_city objectForKey:cityId];
    NSString* a  = [_city objectForKey:areaId];
    NSString* address = [self getAddress:p cityId:c areaId:a];
    return address;
}
#pragma mark----获取当前语言下的文字
- (NSString *)LocalizedWithStr:(NSString *)str{
    NSString *localizedStr = [_localized objectForKey:str];
    if (!localizedStr)
        localizedStr = [NSString stringWithFormat:@"%@SQL错误",str];
    return localizedStr;
}
- (void)getTelArea{
    [_telArea removeAllObjects];
    FMDatabase *db = [self openDB];
    NSString * sql = nil;
    if ([TFJunYou_MyTools isChineseLanguage:_sysLanguage]) {
        sql = [NSString stringWithFormat:@"select * from SMS_country order by prefix"];
    }else{
        sql = [NSString stringWithFormat:@"select * from SMS_country order by en"];
    }
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[self formatId:[rs objectForColumnName:@"id"]] forKey:@"id"];
        [dict setObject:[rs objectForColumnName:@"en"] forKey:@"enName"];
        [dict setObject:[rs objectForColumnName:@"zh"] forKey:@"country"];
        [dict setObject:[rs objectForColumnName:@"prefix"] forKey:@"prefix"];
        [dict setObject:[rs objectForColumnName:@"price"] forKey:@"price"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"big5"];
        [_telArea addObject:dict];
    }
}
-(NSString*)getCurCountryFieldName{
    NSString * name = nil;
    if ([_sysLanguage isEqualToString:@"zh"]) {
        name = [[NSString alloc] initWithFormat:@"%@",NAME];
    }else if ([_sysLanguage isEqualToString:@"big5"]) {
        name = [[NSString alloc] initWithFormat:@"%@",ZHHANTNAME];
    }else if ([_sysLanguage isEqualToString:@"malay"]) {
        name = [[NSString alloc] initWithFormat:@"%@",MALAYNAME];
    }else if ([_sysLanguage isEqualToString:@"th"]) {
        name = [[NSString alloc] initWithFormat:@"%@",THNAME];
    }
    else if ([_sysLanguage isEqualToString:@"en"]){
        name = [[NSString alloc] initWithFormat:@"%@",ENNAME];
    }
    else if ([_sysLanguage isEqualToString:@"ja"]){
        name = [[NSString alloc] initWithFormat:@"%@",JANAME];
    }
    else if ([_sysLanguage isEqualToString:@"ko"]){
        name = [[NSString alloc] initWithFormat:@"%@",KONAME];
    }
    else if ([_sysLanguage isEqualToString:@"idy"]){
        name = [[NSString alloc] initWithFormat:@"%@",IDYNAME];
    }
    else if ([_sysLanguage isEqualToString:@"vi"]){
        name = [[NSString alloc] initWithFormat:@"%@",VINAME];
    }
    else if ([_sysLanguage isEqualToString:@"ms"]){
        name = [[NSString alloc] initWithFormat:@"%@",MSNAME];
    }
    else if ([_sysLanguage isEqualToString:@"fy"]){
        name = [[NSString alloc] initWithFormat:@"%@",FYNAME];
    }
    return name;
}
- (NSMutableArray *) getSearchTelAreaWithName:(NSString *) name {
    FMDatabase* db = [self openDB];
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql= [NSString stringWithFormat:@"select * from SMS_country where (zh like '%%%@%%' or en like '%%%@%%' or big5 like '%%%@%%') order by %@",name,name,name,_sysName];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[self formatId:[rs objectForColumnName:@"id"]] forKey:@"id"];
        [dict setObject:[rs objectForColumnName:@"en"] forKey:@"enName"];
        [dict setObject:[rs objectForColumnName:@"zh"] forKey:@"country"];
        [dict setObject:[rs objectForColumnName:@"prefix"] forKey:@"prefix"];
        [dict setObject:[rs objectForColumnName:@"price"] forKey:@"price"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"big5"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"ja"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"ko"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"idy"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"vi"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"ms"];
        [dict setObject:[rs objectForColumnName:@"big5"] forKey:@"fy"];
        [array addObject:dict];
    }
    return array;
}
-(NSString*) getCityID:(NSString *)s{
    if (s == nil)
        return nil;
    NSString * str = [[NSString alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select id from tb_areas where lower(name)=lower(\"%@\")",s];
    FMDatabase* db = [self openDB];
    FMResultSet *rs=[db executeQuery:sql];
    BOOL isNull = YES;
    while ([rs next]) {
        str =[rs stringForColumn:@"id"];
        isNull = NO;
    }
    if (isNull) {
        NSArray * arr = [ s componentsSeparatedByCharactersInSet : [NSCharacterSet characterSetWithCharactersInString :@"县区市"]];
        NSString * cityNameF = [arr firstObject];
        sql= [NSString stringWithFormat:@"select id from tb_areas where lower(name) like lower(\"%%%@%%\")",cityNameF];
        FMResultSet *rs=[db executeQuery:sql];
        while ([rs next]) {
            str = [rs objectForColumnName:@"id"];
        }
    }
    return str;
}
-(NSString *)getParentWithCityId:(int)cityId{
    if (cityId <= 0 ) {
        return nil;
    }
    FMDatabase * db = [self openDB];
    NSString * sql = [NSString stringWithFormat:@"select parent_id from tb_areas where id=%d",cityId];
    FMResultSet * rs = [db executeQuery:sql];
    NSString * str = [[NSString alloc]init];
    while ([rs next]) {
        str = [rs stringForColumn:@"parent_id"];
    }
    return str;
}
- (void) resetlocalized {
    NSString *lang = [g_default stringForKey:kLocalLanguage];
    if (!lang || lang.length <= 0) {
        lang = [TFJunYou_MyTools getCurrentSysLanguage];
    }
    _sysLanguage =lang;
    _sysName = [self getCurCountryFieldName];
    [self getData];
    [g_theme resetInstence];
}
@end
