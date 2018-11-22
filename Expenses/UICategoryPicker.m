//
//  UICategoryPicker.m
//  Expenses
//
//  Created by Arzhan Kinzhalin on 11/17/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import "UICategoryPicker.h"
#import "DBM/DB.h"
#import "Expenses.h"

@interface UICategoryDataSource : NSObject<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *categories;

@end

@implementation UICategoryDataSource

- (instancetype)init:(NSArray *)categories {
    self = [super init];
    if (!self) return nil;

    self.categories = categories;

    for (id o in self.categories) {
        Category *c = (Category *)o;
        NSLog(@"%@, %d", c.name, c.cid);
    }

    return self;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSLog(@"Categories: %lu", [self.categories count]);
    return [self.categories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row > [self.categories count]) {
        return nil;
    }
    NSLog(@"Called with row %ld, component %ld", row, component);
    Category *c = (Category *)self.categories[row];
    return c.name;
}

@end

@interface UICategoryPicker() {
    UICategoryDataSource *ds;
}
@end

@implementation UICategoryPicker

- (nonnull instancetype)init { 
    self = [super init];
    if (!self)
        return nil;

    /* get data */
    DB *mgr = [DB getDBM];

    ds = [[UICategoryDataSource alloc] init:[mgr getCategories]];
    self.dataSource = ds;
    self.delegate = ds;

    return self;
}

- (Category *)category {
    NSInteger idx = [self selectedRowInComponent:0];
    if (idx >= 0) {
        return [((UICategoryDataSource *)[self delegate]).categories objectAtIndex:idx];
    } else {
        return nil;
    }
}

@end
