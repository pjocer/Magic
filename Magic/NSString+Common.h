//
//  NSString+Common.h
//  CardByYou
//
//  Created by PerryJump on 15/12/14.
//  Copyright © 2015年 XuLiangMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

+ (NSString *)changeJsonStringToTrueJsonString:(NSString *)json;

NSString * URLEncodedString(NSString *str);

NSString * MD5Hash(NSString *aString);

- (NSString *) MD5Hash;

@end
