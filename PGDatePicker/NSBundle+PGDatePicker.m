//
//  NSBundle+PGDatePicker.m
//
//  Created by piggybear on 2017/11/4.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "NSBundle+PGDatePicker.h"
#import "PGDatePicker.h"

@implementation NSBundle (PGDatePicker)
+ (instancetype)safeBundle {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[PGDatePicker class]] pathForResource:@"PGDatePicker" ofType:@"bundle"]];
    }
    return bundle;
}

+ (NSString *)pg_localizedStringForKey:(NSString *)key {
    return [self pg_localizedStringForKey:key value:nil];
}

+ (NSString *)pg_localizedStringForKey:(NSString *)key language:(NSString *)language {
    if (language == nil) {
        return [self pg_localizedStringForKey:key value:nil];
    }
    // 对外部传入的 language 进行标准化映射
    NSString *normalizedLanguage = [self pg_normalizedLanguage:language];
    return [self pg_localizedStringForKey:key value:nil language:normalizedLanguage];
}

// 语言标准化映射，支持外部传入的各种格式
+ (NSString *)pg_normalizedLanguage:(NSString *)language {
    if ([language hasPrefix:@"en"]) {
        return @"en";
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            return @"zh-Hans"; // 简体中文
        } else if ([language rangeOfString:@"Hant"].location != NSNotFound ||
                   [language rangeOfString:@"HK"].location != NSNotFound ||
                   [language rangeOfString:@"TW"].location != NSNotFound) {
            return @"zh-Hant"; // 繁體中文
        } else {
            // 默认简体中文 (zh, zh-CN 等)
            return @"zh-Hans";
        }
    } else if ([language hasPrefix:@"ms"]) {
        return @"ms"; // 马来语
    } else if ([language hasPrefix:@"id"]) {
        return @"id"; // 印尼语
    } else if ([language hasPrefix:@"ja"]) {
        return @"ja"; // 日语
    } else if ([language hasPrefix:@"th"]) {
        return @"th"; // 泰语
    } else if ([language hasPrefix:@"vi"]) {
        return @"vi"; // 越南语
    } else if ([language hasPrefix:@"pt"]) {
        return @"pt"; // 葡萄牙语
    } else if ([language hasPrefix:@"hi"]) {
        return @"hi"; // 印地语
    } else if ([language hasPrefix:@"es"]) {
        return @"es"; // 西班牙语
    } else if ([language hasPrefix:@"ru"]) {
        return @"ru"; // 俄语
    } else if ([language hasPrefix:@"ko"]) {
        return @"ko"; // 韩语
    } else if ([language hasPrefix:@"fr"]) {
        return @"fr"; // 法语
    } else if ([language hasPrefix:@"de"]) {
        return @"de"; // 德语
    } else if ([language hasPrefix:@"it"]) {
        return @"it"; // 意大利语
    }
    return @"en"; // 默认英语
}

+ (NSString *)pg_localizedStringForKey:(NSString *)key value:(NSString *)value {
    NSString *language = [NSLocale preferredLanguages].firstObject;
    NSString *normalizedLanguage = [self pg_normalizedLanguage:language];
    return [self pg_localizedStringForKey:key value:value language:normalizedLanguage];
}

+ (NSString *)pg_localizedStringForKey:(NSString *)key value:(NSString *)value language:(NSString *)language {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle safeBundle] pathForResource:language ofType:@"lproj"]];
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
