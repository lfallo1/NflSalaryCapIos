//
//  PlayerViewController.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/7/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contract.h"
#import "ColorUtilities.h"
#import "StringFormatters.h"

@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *contractList;
@end
