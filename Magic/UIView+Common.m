//
//  UIView+Common.m
//  CardByYou
//
//  Created by PerryJump on 15/12/9.
//  Copyright © 2015年 XuLiangMa. All rights reserved.
//  v1

#import "UIView+Common.h"

@implementation UIView (Common)

CGFloat screenWidth() {

    return [[UIScreen mainScreen] bounds].size.width;
}

CGFloat screehHeight() {

    return [[UIScreen mainScreen] bounds].size.height;
}

CGFloat minX(UIView *view) {
    return CGRectGetMinX(view.frame);
}

CGFloat maxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}

CGFloat minY(UIView *view) {
    return CGRectGetMinY(view.frame);
}

CGFloat maxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

CGFloat width(UIView *view) {
    return CGRectGetWidth(view.frame);
}


CGFloat height(UIView *view) {
    return CGRectGetHeight(view.frame);
}


@end
