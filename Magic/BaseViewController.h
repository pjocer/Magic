//
//  BaseViewController.h
//  Magic
//
//  Created by mxl on 16/1/3.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end


