//
//  TrelloListTabView.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "TrelloListTabView.h"

@implementation TrelloListTabView

- (id)initWithFrame:(CGRect)frame withListArray:(NSArray *)listItems {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.listItems = [listItems mutableCopy];
        self.listItemViews = [NSMutableArray array];
        self.selectedIndex = 0;
        self.isBriefMode = YES;
        self.isFoldedMode = NO;
//        self.scrollEnabled = NO;
//        self.alwaysBounceHorizontal = YES;
        
        self.contentSize = CGSizeMake(70.0f + listItems.count * 30.0f, self.height);
        [self initSubViews];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tgr {
    if(self.HeaderDidSwitchCallBack) {
        self.HeaderDidSwitchCallBack();
    }
    if (self.isBriefMode) {
        return;
    }
    [self.listView setContentOffset:CGPointMake((tgr.view.tag - 1) * (ScreenWidth - 45.0f), 0) animated:YES];
}

- (void)initSubViews {
    CGFloat nextX = 70.0f;
    for(TrelloListItem *t_item in self.listItems){
        // TrelloListItem包含数据模型以及标题等
        TrelloListItemView *view = [[TrelloListItemView alloc]initWithItem:t_item];
        CGRect frame = view.frame;
        frame.origin.x = nextX;
        view.frame = frame;
        nextX += view.width;
        
        static NSInteger i = 1;
        view.tag = i++;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tap:)];
        [view addGestureRecognizer:tap];

        [self addSubview:view];
        [self.listItemViews addObject:view];
    }
    PlayAnimatView *playView = [PlayAnimatView sharePlayAnimatView];
    playView.animatFrame = CGRectMake(self.width - 80, 3, 50, 35);
    [self addSubview:playView];
}

//- (void)reloadData {
//    self.contentSize = CGSizeMake(70.0f + self.listItems.count * 30.0f, self.height);
//    for(TrelloListItemView *view in self.listItemViews){
//        [view removeFromSuperview];
//    }
//    [self.listItemViews removeAllObjects];
//    
//    CGFloat nextX = 70.0f;
//    for(TrelloListItem *t_item in self.listItems){
//        TrelloListItemView *view = [[TrelloListItemView alloc]initWithItem:t_item];
//        CGRect frame = view.frame;
//        frame.origin.x = nextX;
//        view.frame = frame;
//        nextX += view.width;
//        [self addSubview:view];
//        [self.listItemViews addObject:view];
//    }
//    [self selectBoardAtIndex:self.selectedIndex];
//}

// TrelloView中调用
- (void)selectBoardAtIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2f animations:^{
        for(NSInteger i=0;i<self.listItemViews.count;i++){
            TrelloListItemView *t_boardView = [self.listItemViews objectAtIndex:i];
            if(i == index){
                // 当按钮多的时候有效果
                [self scrollRectToVisible:t_boardView.frame animated:NO];
                // 注： tabView 会自动将未显示部分显示出来
                t_boardView.boardView.alpha = 1.0f;
            }
            else{
                t_boardView.boardView.alpha = 0.5f;
            }
        }
    } completion:^(BOOL finished) {
        if(finished){
            self.selectedIndex = index;
        }
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(touches.count == 1){
        for(UITouch *touch in touches){
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled){
                [super touchesMoved:touches withEvent:event];
                return;
            }
            else if(touch.phase == UITouchPhaseMoved){
                CGPoint currentPoint = [touch locationInView:self];
                CGPoint prevPoint = [touch previousLocationInView:self];
                if(currentPoint.y - prevPoint.y > 2){
                    if(self.isBriefMode){
                        if(self.HeaderDidSwitchCallBack){
                            self.HeaderDidSwitchCallBack();
                        }
                    }
                }
                else if(currentPoint.y - prevPoint.y < -2){
                    if(!self.isBriefMode){
                        if(self.HeaderDidSwitchCallBack){
                            self.HeaderDidSwitchCallBack();
                        }
                    }
                }
                else{
                    return;
                }
            }
        }
    }

}

@end
