//
//  AppDelegate.h
//  Expenses
//
//  Created by Arzhan Kinzhalin on 6/20/18.
//  Copyright © 2018 Arzhan Kinzhalin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

