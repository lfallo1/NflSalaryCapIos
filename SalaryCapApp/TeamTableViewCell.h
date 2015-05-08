//
//  TeamTableViewCell.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/4/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@end
