//
//  LCNavigationController.m
//  LCNavigationControllerDemo
//
//  Created by Leo on 15/11/20.
//  Copyright © 2015年 Leo. All rights reserved.
//
//  V 1.0.2

#import "LCNavigationController.h"

static const CGFloat LCAnimationDuration = 0.35f;   // Push / Pop 动画持续时间
static const CGFloat LCMaxBlackMaskAlpha = 0.80f;   // 黑色背景透明度
static const CGFloat LCZoomRatio         = 0.90f;   // 后面视图缩放比
static const CGFloat LCShadowOpacity     = 0.80f;   // 滑动返回时当前视图的阴影透明度
static const CGFloat LCShadowRadius      = 8.00f;   // 滑动返回时当前视图的阴影半径

typedef enum : NSUInteger {
    PanDirectionNone,
    PanDirectionLeft,
    PanDirectionRight,
} PanDirection;

@interface LCNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *gestures;
@property (nonatomic,   weak) UIView *blackMask;
@property (nonatomic, assign) BOOL animationing;
@property (nonatomic, assign) CGPoint panOrigin;
@property (nonatomic, assign) CGFloat percentageOffsetFromLeft;

@end

@implementation LCNavigationController

- (void)dealloc {
    
    self.viewControllers = nil;
    self.gestures  = nil;
    self.blackMask = nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray arrayWithObject:rootViewController];
    }
    return self;
}

- (CGRect)viewBoundsWithOrientation:(UIInterfaceOrientation)orientation {
    
    CGRect bounds = [UIScreen mainScreen].bounds;
//
//    if ([[UIApplication sharedApplication]isStatusBarHidden]) {
//        
//        return bounds;
//        
//    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
//        
//        CGFloat width = bounds.size.width;
//        bounds.size.width = bounds.size.height;
//        bounds.size.height = width;
//        return bounds;
//    } else {
    
        return bounds;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    
    [super loadView];
    /**
     *  实际上还是view.bounds
     */
    CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
    
    UIViewController *rootViewController = [self.viewControllers firstObject];
    [rootViewController willMoveToParentViewController:self];
    [self addChildViewController:rootViewController];
    
    UIView *rootView = rootViewController.view;
    rootView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    rootView.frame = viewRect;
    [self.view addSubview:rootView];
    [rootViewController didMoveToParentViewController:self];
    
    UIView *blackMask = [[UIView alloc] initWithFrame:viewRect];
    blackMask.backgroundColor = [UIColor blackColor];
    blackMask.alpha = 0;
    blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:blackMask atIndex:0];
    self.blackMask = blackMask;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}


- (UIViewController *)currentViewController {
    
    UIViewController *result = nil;
    if (self.viewControllers.count) result = [self.viewControllers lastObject];
    return result;
}

- (UIViewController *)previousViewController {
    
    UIViewController *result = nil;
    if (self.viewControllers.count > 1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}

- (void)addPanGestureToView:(UIView*)view {
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(gestureRecognizerDidPan:)];
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];
    [self.gestures addObject:panGesture];
}

- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    
    if (self.animationing) return;
    
    CGPoint currentPoint = [panGesture translationInView:self.view];
    CGFloat x = currentPoint.x + self.panOrigin.x;
    
    PanDirection panDirection = PanDirectionNone;
    CGPoint vel = [panGesture velocityInView:self.view];
    
    if (vel.x > 0) {
        panDirection = PanDirectionRight;
    } else {
        panDirection = PanDirectionLeft;
    }
    CGFloat offset = 0;
    
    UIViewController *vc = [self currentViewController];

    if (self.pageType == PageTypeNorMal) {
        
        offset = CGRectGetWidth(vc.view.frame) - x;
        
    } else if (self.pageType == PageTypeLastLast) {
        
        offset = CGRectGetWidth(vc.view.frame) - x;
        
    } else if (self.pageType == PageTypeLastFir) {
        
        offset = CGRectGetWidth(self.pageFrame) - x;
    } else if (self.pageType == PageTypeLastSec) {
    
        offset = (CGRect){{0,0},self.pageFrame.size}.size.width - x;
    }
    vc.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    vc.view.layer.shadowOpacity = LCShadowOpacity;
    vc.view.layer.shadowRadius  = LCShadowRadius;
    
    self.percentageOffsetFromLeft = offset / [self viewBoundsWithOrientation:self.interfaceOrientation].size.width;

    vc.view.frame = [self getSlidingRectWithPercentageOffset:self.percentageOffsetFromLeft
                                                 orientation:self.interfaceOrientation];
    [self transformAtPercentage:self.percentageOffsetFromLeft];
    
    if (panGesture.state == UIGestureRecognizerStateEnded ||
        panGesture.state == UIGestureRecognizerStateCancelled) {
        
        if (fabs(vel.x) > 100) {
            
            [self completeSlidingAnimationWithDirection:panDirection];
            
        } else {
            
            [self completeSlidingAnimationWithOffset:offset];
        }
    }
}

- (void)completeSlidingAnimationWithDirection:(PanDirection)direction {
    
    if (direction == PanDirectionRight){
        
        [self popViewController];
        
    } else {
        
        [self rollBackViewController];
    }
}

- (void)completeSlidingAnimationWithOffset:(CGFloat)offset{
    
    if (offset < [self viewBoundsWithOrientation:self.interfaceOrientation].size.width * 0.5f) {
        
        [self popViewController];
        
    } else {
        
        [self rollBackViewController];
    }
}

- (void)rollBackViewController {
    
    self.animationing = YES;
    
    UIViewController *vc = [self currentViewController];
    UIViewController *nvc = [self previousViewController];
    CGRect rect;
    
    if (self.pageType == PageTypeNorMal) {
        
        rect = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
        
    } else if (self.pageType == PageTypeLastLast) {
        
        rect = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
        
    } else if (self.pageType == PageTypeLastFir) {
        
        rect = self.pageFrame;
    } else if (self.pageType == PageTypeLastSec) {
        
        rect = (CGRect){{0,0},self.pageFrame.size};
    }
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGAffineTransform transf = CGAffineTransformIdentity;
        nvc.view.transform = CGAffineTransformScale(transf, LCZoomRatio, LCZoomRatio);
        vc.view.frame = rect;
        self.blackMask.alpha = LCMaxBlackMaskAlpha;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.animationing = NO;
        }
    }];
}

- (CGRect)getSlidingRectWithPercentageOffset:(CGFloat)percentage orientation:(UIInterfaceOrientation)orientation {
    
    CGRect viewRect = [self viewBoundsWithOrientation:orientation];
    CGRect rectToReturn = CGRectZero;
    rectToReturn.size = viewRect.size;
    
    if (self.pageType == PageTypeNorMal) {
        
        rectToReturn.origin = CGPointMake(MAX(0, (1 - percentage) * viewRect.size.width), 0);
    
    } else if (self.pageType == PageTypeLastLast) {
        
        rectToReturn.origin = CGPointMake(MAX(0, (1 - percentage) * viewRect.size.width), 0);
    
    } else if (self.pageType == PageTypeLastFir) {
        
        CGRect rect = (CGRect){{0,0},self.pageFrame.size};
        rectToReturn.origin = CGPointMake(MAX(0, (1 - percentage) * rect.size.width), 60);
    
    } else if (self.pageType == PageTypeLastSec) {
        
        CGRect rect = (CGRect){{0,0},self.pageFrame.size};
        rectToReturn.origin = CGPointMake(MAX(0, (1 - percentage) * rect.size.width), 0);
    }
    return rectToReturn;
}

- (void)transformAtPercentage:(CGFloat)percentage {
    
    CGAffineTransform transf = CGAffineTransformIdentity;
    CGFloat newTransformValue =  1 - percentage * (1 - LCZoomRatio);
    CGFloat newAlphaValue = percentage * LCMaxBlackMaskAlpha;
    [self previousViewController].view.transform = CGAffineTransformScale(transf, newTransformValue, newTransformValue);
    
    self.blackMask.alpha = newAlphaValue;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)pushViewController:(UIViewController *)viewController completion:(LCNavigationControllerCompletionBlock)completion {
    
    self.animationing = YES;
    
    viewController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    viewController.view.layer.shadowOpacity = LCShadowOpacity;
    viewController.view.layer.shadowRadius  = LCShadowRadius;
    
    if (self.pageType == PageTypeNorMal) {
        
        viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
    } else if (self.pageType == PageTypeLastLast) {
        
        viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
        
    } else if (self.pageType == PageTypeLastFir) {
        
        viewController.view.frame = CGRectOffset(self.pageFrame, self.view.bounds.size.width, 0);
    } else if (self.pageType == PageTypeLastSec) {
        
        viewController.view.frame = (CGRect){{0,0},self.pageFrame.size};
    }
    
    viewController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.blackMask.alpha = 0;
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    
    [self.view bringSubviewToFront:self.blackMask];
    [self.view addSubview:viewController.view];
    
    [UIView animateWithDuration:LCAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGAffineTransform transf = CGAffineTransformIdentity;
        
        [self currentViewController].view.transform = CGAffineTransformScale(transf, LCZoomRatio, LCZoomRatio);
        
        if (self.pageType == PageTypeNorMal) {
            
            viewController.view.frame = self.view.frame;
        } else if (self.pageType == PageTypeLastLast) {
            
            viewController.view.frame = self.view.frame;
            
        } else if (self.pageType == PageTypeLastFir) {
            
            viewController.view.frame = self.pageFrame;
        } else if (self.pageType == PageTypeLastSec) {
            
            viewController.view.frame = (CGRect){{0,0},self.pageFrame.size};
        }

        self.blackMask.alpha = LCMaxBlackMaskAlpha;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.viewControllers addObject:viewController];
            [viewController didMoveToParentViewController:self];
            
            self.animationing = NO;
            self.gestures = [[NSMutableArray alloc] init];
            [self addPanGestureToView:[self currentViewController].view];
            
            if (completion != nil) completion();
        }
    }];
}

- (void)pushViewController:(UIViewController *)viewController {
    
    [self pushViewController:viewController completion:nil];
}

- (void)popViewControllerCompletion:(LCNavigationControllerCompletionBlock)completion {
    
    if (self.viewControllers.count < 2) return;
    
    self.animationing = YES;
    
    UIViewController *currentVC = [self currentViewController];
    UIViewController *previousVC = [self previousViewController];
    [previousVC viewWillAppear:NO];
    
    currentVC.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    currentVC.view.layer.shadowOpacity = LCShadowOpacity;
    currentVC.view.layer.shadowRadius  = LCShadowRadius;
    
    [UIView animateWithDuration:LCAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if (self.pageType == PageTypeNorMal) {
            
            currentVC.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
        } else if (self.pageType == PageTypeLastLast) {
            
            currentVC.view.frame = CGRectOffset((CGRect){{0,0},self.pageFrame.size}, self.view.bounds.size.width, 0);
            
        } else if (self.pageType == PageTypeLastFir) {
            
            currentVC.view.frame = CGRectOffset(self.pageFrame, self.view.bounds.size.width, 0);
        } else if (self.pageType == PageTypeLastSec) {
            
            currentVC.view.frame = CGRectOffset((CGRect){{0,0},self.pageFrame.size}, self.view.bounds.size.width, 0);
        }
        
        CGAffineTransform transf = CGAffineTransformIdentity;
        previousVC.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
        
        if (self.pageType == PageTypeNorMal) {
            previousVC.view.frame = self.view.frame;
            
        } else if (self.pageType == PageTypeLastLast) {
            if (_isComment) {
                previousVC.view.frame = self.view.frame;
                _isComment = NO;
            } else {
                previousVC.view.frame = self.view.frame;
                self.pageType = PageTypeLastSec;
            }
        } else if (self.pageType == PageTypeLastFir) {
         
            previousVC.view.frame = self.view.frame;
            self.pageType = PageTypeNorMal;
            
        } else if (self.pageType == PageTypeLastSec) {
            
            previousVC.view.frame = self.pageFrame;
            
            self.pageType = PageTypeLastFir;
        }
        self.blackMask.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [currentVC.view removeFromSuperview];
            [currentVC willMoveToParentViewController:nil];
            
            [self.view bringSubviewToFront:[self previousViewController].view];
            [currentVC removeFromParentViewController];
            [currentVC didMoveToParentViewController:nil];
            
            [self.viewControllers removeObject:currentVC];
            self.animationing = NO;
            [previousVC viewDidAppear:NO];
            
            if (completion != nil) completion();
        }
    }];
}

- (void) popViewController {
    
    [self popViewControllerCompletion:nil];
}

- (void)popToViewController:(UIViewController*)toViewController {
    
    NSMutableArray *controllers = self.viewControllers;
    NSInteger index = [controllers indexOfObject:toViewController];
    UIViewController *needRemoveViewController = nil;
    
    for (int i = (int)controllers.count - 2; i > index; i--) {
        
        needRemoveViewController = [controllers objectAtIndex:i];
        [needRemoveViewController.view setAlpha:0];
        
        [needRemoveViewController removeFromParentViewController];
        [controllers removeObject:needRemoveViewController];
    }
    [self popViewController];
}

- (void)popToRootViewController {
    
    UIViewController *rootController = [self.viewControllers objectAtIndex:0];
    [self popToViewController:rootController];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

@end


@implementation UIViewController (LCNavigationController)

@dynamic lcNavigationController;

- (LCNavigationController *)lcNavigationController {
    
    UIResponder *responder = [self nextResponder];
    
    while (responder) {
        
        if ([responder isKindOfClass:[LCNavigationController class]]) {
            
            return (LCNavigationController *)responder;
        }
        // 保证响应者是LCNavigationController
        responder = [responder nextResponder];
    }
    
    return nil;
}


@end
