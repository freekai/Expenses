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

@property (nonatomic) NSInteger amount;
@property (nonatomic) NSDate *date;
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
    [categoryPickerToolbar setItems:[NSArray arrayWithObjects:categoryPickerDoneBtn, nil]];
    [self.categoryUI setInputAccessoryView:categoryPickerToolbar];
    [self.categoryUI setDelegate:self];

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
    self.date = date;
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

- (void)clearForm {
    self.amountUI.text = @"";
    self.categoryUI.text = @"";
    self.dateUI.text = @"";
}

- (IBAction)addUIClicked:(id)sender {
    [self.view endEditing:YES];
    if (!self.amount) {
        [self.amountUI becomeFirstResponder];
        return;
    }
    if (!self.categoryID) {
        [self.categoryUI becomeFirstResponder];
        return;
    }
    if (!self.date) {
        [self.dateUI becomeFirstResponder];
    }
    DB *db = [DB getDBM];
    if ([db addExpense:(int)self.amount on:self.date in:self.categoryID]) {
        [self clearForm];
    }
}


/* --- UITextFieldDelegate implementation */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.dateUI || textField == self.categoryUI) {
        return NO;
    } else if (textField == self.amountUI) {
        static NSNumberFormatter *nf = nil;
        if (!nf) {
            nf = [[NSNumberFormatter alloc] init];
        }
        NSString *result = [self.amountUI.text stringByReplacingCharactersInRange:range withString:string];
        NSNumber *number = [nf numberFromString:result];
        if (!number) return NO;
        if (((int)([number doubleValue]*1000)) % 10) {
            return NO;
        }
        self.amount = [number longValue];
    }
    return YES;
}


@end
