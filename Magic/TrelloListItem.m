//
//  TrelloListItem.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/5.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "TrelloListItem.h"

@implementation TrelloListItem

/**
 *  @param rowItems  这个就是newDatasModel
 */
- (id)initWithTitle:(NSString *)title level:(NSInteger)level rowNumber:(NSInteger)rowNumber rowItems:(NSMutableArray *)rowItems
{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.heightLevel = level;
        self.rowNumber = rowNumber;
        self.rowItemsArray = rowItems;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowItemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
