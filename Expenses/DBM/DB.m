//
//  DBMgr.m
//  Expenses
//
//  Created by Arzhan Kinzhalin on 6/23/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import <sqlite3.h>

#import "DB.h"
#import "Expenses.h"

@interface DB()
@property (strong, nonatomic) NSString *db_path;
@end

static sqlite3 *conn = NULL;

@implementation DB

+ (id)getDBM {
    static DB *mgr = nil;
    static dispatch_once_t tok;
    dispatch_once(&tok, ^{
        mgr = [[DB alloc] init];
    });
    return mgr;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    NSArray<NSString *> *doc_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc_path = doc_paths[0];
    self.db_path = [doc_path stringByAppendingPathComponent:@"expenses.db"];

    if ([self initNeeded]) {
        [self makeDB];
    }

    if (![self openDB]) {
        return nil;
    }

    return self;
}

- (BOOL)initNeeded {
    // TODO: implement
    return YES;
}

- (BOOL)makeDB {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.db_path]) {
        sqlite3 *conn = NULL;
        NSString *ddl_script_path = [[NSBundle mainBundle] pathForResource:@"ddl" ofType:@"sql"];
        NSString *dml_script_path = [[NSBundle mainBundle] pathForResource:@"dml" ofType:@"sql"];
        if (sqlite3_open_v2([self.db_path UTF8String], &conn, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) != SQLITE_OK) {
            NSLog(@"Failed to open/create the db.");
            return NO;
        }
        NSString *ddl = [NSString stringWithContentsOfFile:ddl_script_path encoding:NSUTF8StringEncoding error:NULL];
        if (sqlite3_exec(conn, [ddl UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
            NSLog(@"Failed to execute script from %@", [ddl_script_path lastPathComponent]);
            return NO;
        }
        NSString *dml = [NSString stringWithContentsOfFile:dml_script_path encoding:NSUTF8StringEncoding error:NULL];
        if (sqlite3_exec(conn, [dml UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
            NSLog(@"Failed to execute script from %@", [dml_script_path lastPathComponent]);
            return NO;
        }
    }
    return YES;
}

- (BOOL)openDB {
    if (sqlite3_open_v2([self.db_path UTF8String], &conn, SQLITE_OPEN_READWRITE, NULL) != SQLITE_OK) {
        NSLog(@"Failed to open the db.");
        return NO;
    }
    return YES;
}

- (BOOL)addExpense:(int)amount on:(NSDate *)expense_date in:(int)category {
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    const char *record_date = [[fmtr stringFromDate:[NSDate date]] UTF8String];
    const char *exp_date = [[fmtr stringFromDate:expense_date] UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(conn, "INSERT INTO expenses (amount, record_date, expense_date, cat_id, notes)"
                       " VALUES (?, ?, ?, ?, ?);", -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, amount);
    sqlite3_bind_text(stmt, 2, record_date, (int)strlen(record_date), SQLITE_STATIC);
    sqlite3_bind_text(stmt, 3, exp_date, (int)strlen(exp_date), SQLITE_STATIC);
    sqlite3_bind_int(stmt, 4, category);
    sqlite3_bind_null(stmt, 5);

    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSLog(@"Error inserting data: %s", "Shit happens");
        return NO;
    }

    return YES;
}

- (NSArray *)getCategories {
    static NSArray *r = nil;
    if (!r) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(conn, "SELECT ROWID, name FROM category", -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"getCategories: Failed to prepare statement");
            return nil;
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Category *c = [[Category alloc] init];
            c.cid = sqlite3_column_int(stmt, 0);
            c.name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            [result addObject:c];
        }
        r = [result copy];
    }
    return r;
}



@end
