//
//  ViewController.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/4/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "DbHandler.h"
#import "TeamTableViewCell.h"
#import "ColorUtilities.h"
#import "TeamViewController.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *teamTableView;
@end

