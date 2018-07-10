//
//  NSString+Category.m
//  SmartHome
//
//  Created by kiwik on 10/27/15.
//  Copyright © 2015 几维信息科技有限公司. All rights reserved.
//

#import "NSString+Category.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Category)

+ (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

// URL编码
- (NSString *)URLEncodedString{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

//普通的MD5加密
-(NSString*)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

//UTF16的MD5加密
- (NSString *)md5ForUTF16 {
    NSData *temp = [self dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    UInt8 *cStr = (UInt8 *)[temp bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)[temp length], result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",  result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

//去掉前后的空格
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//行中的多个空格只会留一个
- (NSString *)trimTheExtraSpaces{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}

- (NSString *)removeSpaceAndNewline {
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@""];
}

- (NSString*)pureDigital
{
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c >= '0' && c <= '9') {
            [result appendFormat:@"%c",c];
        }
    }
    return result;
}

//是否是空字符串
- (BOOL)isEmpty {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
    return [trimmed isEqualToString:@""];
}

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreakMode];
}

//自适应大小
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        
        CGRect boundingRect = [self boundingRectWithSize:constrainedSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes context:nil];
        
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

-(CGSize)sizeWithFont:(UIFont*)font
{
    CGSize size;
    if (OS_VERSION >= 7.0) {
        size = [self sizeWithAttributes:@{ NSFontAttributeName:font}];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
    return size;
}

@end
