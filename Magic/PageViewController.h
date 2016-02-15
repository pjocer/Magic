//
//  PageViewController.h
//  Magic
//
//  Created by mxl on 16/1/6.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface PageViewController : UIViewController

@property (nonatomic, strong) CollectionController1 *cvc1;
@property (nonatomic, strong) CollectionController2 *cvc2;

@property (nonatomic, assign) CGRect selfFrame;

@end
