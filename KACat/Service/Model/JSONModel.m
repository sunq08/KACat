//
//  ModelBase.m
//  Steinlogic
//
//  Created by Mugunth Kumar on 26-Jul-10.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel

-(id) initWithDictionary:(NSMutableDictionary*) jsonObject {
    if((self = [super init])) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

-(BOOL) allowsKeyedCoding {
	return YES;
}

- (id) initWithCoder:(NSCoder *)decoder {
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	// do nothing.
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
	JSONModel *newModel = [[JSONModel allocWithZone:zone] init];
	return newModel;
}

-(id) copyWithZone:(NSZone *)zone {
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
	JSONModel *newModel = [[JSONModel allocWithZone:zone] init];
	return newModel;
}

- (id)valueForUndefinedKey:(NSString *)key {
    // subclass implementation should provide correct key value mappings for custom keys
//    NSLog(@"Undefined Key: %@", key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // subclass implementation should set the correct key value mappings for custom keys
//    NSLog(@"Undefined Key: %@", key);
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
