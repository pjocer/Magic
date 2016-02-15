//
//  LCNavigationController.h
//  LCNavigationControllerDemo
//
//  Created by Leo on 15/11/20.
//  Copyright © 2015年 Leo. All rights reserved.
//
//  V 1.0.2

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PageTypeNorMal,
    PageTypeLastFir,
    PageTypeLastSec,
    PageTypeLastLast,
} PageType;

typedef void (^LCNavigationControllerCompletionBlock)(void);

@interface LCNavigationController : UIViewController

@property(nonatomic, strong) NSMutableArray *viewControllers;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController;

- (void)pushViewController:(UIViewController *)viewController
                completion:(LCNavigationControllerCompletionBlock)completion;

- (void)popViewController;

- (void)popViewControllerCompletion:(LCNavigationControllerCompletionBlock)completion;

- (void)popToRootViewController;

- (void)popToViewController:(UIViewController*)toViewController;

@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, assign) BOOL isSecoPage;
@property (nonatomic, assign) BOOL isSSSPage;

@property (nonatomic, assign) CGRect pageFrame;

@property (nonatomic, assign) PageType pageType;

@property (nonatomic, assign) BOOL isComment;

@end



@interface UIViewController (LCNavigationController)

@property (nonatomic, strong) LCNavigationController *lcNavigationController;

@end
