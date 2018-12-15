//
//  DBMgr.h
//  Expenses
//
//  Created by Arzhan Kinzhalin on 6/23/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DB : NSObject

- (BOOL)addExpense:(NSInteger)amount on:(NSDate *)date in:(NSInteger)category;

- (NSArray *)getCategories;

+ (id)getDBM;

@end
