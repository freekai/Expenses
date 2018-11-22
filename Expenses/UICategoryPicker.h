//
//  UICategoryPicker.h
//  Expenses
//
//  Created by Arzhan Kinzhalin on 11/17/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expenses.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICategoryPicker : UIPickerView

@property (strong, nonatomic) Category *category;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
