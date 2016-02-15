//
//  SoundsModel.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "SoundsModel.h"
@implementation SoundsChannelModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation SoundsUserModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation SoundsDatasModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end


@implementation SoundsDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation SoundsResultModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data": @"detailData"}];
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
@implementation SoundsModel

@end
