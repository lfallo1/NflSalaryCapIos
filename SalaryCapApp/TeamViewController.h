//
//  TeamViewController.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contract.h"
#import "PlayerTeamTableViewCell.h"
#import "PlayerViewController.h"

@interface TeamViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Team *team;
@end
