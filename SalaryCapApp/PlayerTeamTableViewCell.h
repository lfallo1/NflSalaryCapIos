//
//  PlayerTeamTableViewCell.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerTeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *capChargeLabel;
@end
