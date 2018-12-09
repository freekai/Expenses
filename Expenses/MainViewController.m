//
//  MainViewController.m
//  Expenses
//
//  Created by Arzhan Kinzhalin on 6/20/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import "MainViewController.h"
#import "UICategoryPicker.h"
#import "DBM/DB.h"

@interface MainViewController () <UITextFieldDelegate>

@property (nonatomic) NSInteger categoryID;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /* the amount UI */
    UIToolbar *amountPadToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *amountPadDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showEnteredAmount)];
    [amountPadToolbar setItems:[NSArray arrayWithObjects:amountPadDoneBtn, nil]];
    [self.amountUI setInputAccessoryView:amountPadToolbar];
    [self.amountUI setDelegate:self];

    /* the category picker */
    categoryPicker = [[UICategoryPicker alloc] init];
    [self.categoryUI setInputView:categoryPicker];
    UIToolbar *categoryPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *categoryPickerDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedCategory)];
    [categoryPickerToolbar setItems: [NSArray arrayWithObjects:categoryPickerDoneBtn, nil]];
    [self.categoryUI setInputAccessoryView:categoryPickerToolbar];

    /* the date picker */
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.dateUI setInputView:datePicker];
    [self.dateUI setDelegate:self];

    [self showDate:[NSDate date]];

    UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [datePickerToolbar setTintColor:[UIColor blueColor]];
    UIBarButtonItem *datePickerDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
    [datePickerToolbar setItems:[NSArray arrayWithObjects:datePickerDoneBtn, nil]];
    [self.dateUI setInputAccessoryView:datePickerToolbar];

}

- (void)viewDidAppear:(BOOL)animated {
    [self.amountUI becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showEnteredAmount {
    [self.categoryUI becomeFirstResponder];
}

/* datePickerDoneBtn: show selected date when pressed */
- (void)showDate:(NSDate *)date {
    if (!date) return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, YYYY"];
    self.dateUI.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
}

- (void)showSelectedDate {
    [self showDate:datePicker.date];
    [self.dateUI resignFirstResponder];
}

- (void)showSelectedCategory {
    Category *c = categoryPicker.category;
    if (c) {
        self.categoryUI.text = c.name;
        self.categoryID = c.cid;
    } else {
        self.categoryUI.text = nil;
        self.categoryID = -1;
    }
    [self.categoryUI resignFirstResponder];
    
}

- (IBAction)addUIClicked:(id)sender {
    NSString *date = self.dateUI.text;
    NSString *amount = self.amountUI.text;
    NSInteger cid = self.categoryID;
    NSLog(@"%@", date);
    NSLog(@"%@", amount);
    NSLog(@"%ld", (long)cid);
}


/* --- UITextFieldDelegate implementation */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.dateUI) return NO;
    return NO;
}


@end
