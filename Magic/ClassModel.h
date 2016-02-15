//
//  ClassModel.h
//  Magic
//
//  Created by mxl on 16/1/7.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *ico_url;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *en_name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *ID;//id

@end
