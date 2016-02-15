//
//  BtnTableViewCell.h
//  Magic
//
//  Created by mxl on 16/1/6.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageProtocol <NSObject>

- (void)pageBtnClick:(BOOL)isLeft;

@end

typedef void(^PageBlock)(BOOL isLeft);

@interface BtnTableViewCell : UITableViewCell

@property (nonatomic, copy) PageBlock pageBlock;

@property (nonatomic, weak) id<PageProtocol> delegate;

@end
