//
//  PK-ios
//
//  Created by peikua on 15/9/15.
//  Copyright (c) 2015年 peikua. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+ (NSString*) getSecrectStringWithPhoneNumber:(NSString*)phoneNum {
    if (phoneNum.length==11) {
        NSMutableString *newStr = [NSMutableString stringWithString:phoneNum];
        NSRange range = NSMakeRange(3, 7);
        [newStr replaceCharactersInRange:range withString:@"*****"];
        return newStr;
    }
    return nil;
}

+ (NSString*) getSecrectStringWithAccountNo:(NSString*)accountNo {
    NSMutableString *newStr = [NSMutableString stringWithString:accountNo];
    NSRange range = NSMakeRange(4, 8);
    if (newStr.length>12) {
        [newStr replaceCharactersInRange:range withString:@" **** **** "];
    }
    return newStr;
}

+ (NSString *)countNumAndChangeformat:(NSString *)num {
    NSNumberFormatter *moneyFormatter = [[NSNumberFormatter alloc] init];
    moneyFormatter.positiveFormat = @"###,###";
    //如要增加小数点请自行修改为@"###,###,##"
    return [moneyFormatter stringFromNumber:[num toNumber]];
}

-(CGFloat)heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

- (CGFloat) widthWithFontSize:(CGFloat)fontSize height:(CGFloat)maxHeight {
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [self boundingRectWithSize:CGSizeMake(0, maxHeight) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}

- (NSNumber*)toNumber {
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number=[formatter numberFromString:self];
    return number;
}

/*抹除运费小数末尾的0*/
- (NSString *)removeUnwantedZero {
    if ([[self substringWithRange:NSMakeRange(self.length- 3, 3)] isEqualToString:@"000"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-4)]; // 多一个小数点
    } else if ([[self substringWithRange:NSMakeRange(self.length- 2, 2)] isEqualToString:@"00"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-2)];
    } else if ([[self substringWithRange:NSMakeRange(self.length- 1, 1)] isEqualToString:@"0"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-1)];
    } else {
        return self;
    }
}

/** 取出所有空格 */
- (NSString *)allTrimmedString {
    return [self stringByReplacingOccurrencesOfString:@" "
                                           withString:@""];
}

//去掉前后空格
- (NSString *)trimmedString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
}

- (NSString *)subStringWithlength:(NSInteger)length{
    if(!self || [self isEqualToString:@""]) {
        return @"";
    }
    if(self.length<=length){
        return self;
    }
    return [self substringToIndex:length];
}

- (NSString *)reviseString {
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [self doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (NSString *)toJSONStringForDictionary:(NSMutableDictionary *)dict{
    if(dict!=nil && [dict isKindOfClass:[NSDictionary class]]){
        NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end


NSString * format(NSString *format, ...)
{
    va_list ap;
    va_start (ap, format);
    
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    va_end (ap);
    
    return body;
}



