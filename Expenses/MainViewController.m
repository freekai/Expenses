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

@interface MainViewController ()

@property (nonatomic) NSInteger categoryID;

@end

@implementation MainViewController

void callback(void * unused, int argc, char **argv, char **names) {
    int i = 0;
    for (; i < argc; i++) {
        NSLog(@"%s, %s", argv[0], argv[1]);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /* the date picker */
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.dateUI setInputView:datePicker];

    UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [datePickerToolbar setTintColor:[UIColor blueColor]];
    UIBarButtonItem *datePickerDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
    [datePickerToolbar setItems:[NSArray arrayWithObjects:datePickerDoneBtn, nil]];
    [self.dateUI setInputAccessoryView:datePickerToolbar];

    /* the category picker */
    categoryPicker = [[UICategoryPicker alloc] init];
    [self.categoryUI setInputView:categoryPicker];
    UIToolbar *categoryPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *categoryPickerDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedCategory)];
    [categoryPickerToolbar setItems: [NSArray arrayWithObjects:categoryPickerDoneBtn, nil]];
    [self.categoryUI setInputAccessoryView:categoryPickerToolbar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* datePickerDoneBtn: show selected date when pressed */
- (void)showSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, YYYY"];
    self.dateUI.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
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
}


@end
