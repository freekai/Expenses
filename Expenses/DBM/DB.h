//
//  DBMgr.h
//  Expenses
//
//  Created by Arzhan Kinzhalin on 6/23/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DB : NSObject

- (BOOL)addExpense:(int)amount on:(NSDate *)date in:(int)category;

- (NSArray *)getCategories;

+ (id)getDBM;

@end
