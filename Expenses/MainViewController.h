//
//  MainViewController.h
//  Expenses
//
//  Created by Arzhan Kinzhalin on 6/20/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICategoryPicker.h"

@interface MainViewController : UIViewController {
    UIDatePicker *datePicker;
    UICategoryPicker *categoryPicker;
}

@property (strong, nonatomic) IBOutlet UITextField *amountUI;
@property (strong, nonatomic) IBOutlet UITextField *dateUI;
@property (strong, nonatomic) IBOutlet UITextField *categoryUI;

@property IBOutlet UIButton *addUI;

@end

