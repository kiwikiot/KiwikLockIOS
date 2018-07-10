//
//  NSString+Category.h
//  SmartHome
//
//  Created by kiwik on 10/27/15.
//  Copyright © 2015 几维信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KIsBlankString(str)  [NSString isBlankString:str]

@interface NSString(Category)

+ (BOOL)isBlankString:(NSString *)str;
- (NSString *)URLEncodedString;
- (NSString *)md5;
- (NSString *)md5ForUTF16;
- (NSString *)trim;
- (NSString *)trimTheExtraSpaces;
- (NSString *)pureDigital;
- (BOOL)isEmpty;
- (NSString *)removeSpaceAndNewline;

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFont:(UIFont*)font;

@end
