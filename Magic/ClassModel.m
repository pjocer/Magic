//
//  ClassModel.m
//  Magic
//
//  Created by mxl on 16/1/7.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
