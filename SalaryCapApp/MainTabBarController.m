//
//  MainTabBarController.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 6/18/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:NO forKey:@"isPremium"];
    BOOL isPremium = [defaults boolForKey:@"isPremium"];
    [defaults synchronize];
    
//    if(!isPremium){
//        [[[[self tabBar]items]objectAtIndex:1]setEnabled:FALSE];
//        [[[[self tabBar]items]objectAtIndex:2]setEnabled:FALSE];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
