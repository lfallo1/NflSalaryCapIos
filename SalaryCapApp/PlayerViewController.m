//
//  PlayerViewController.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/7/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
{
    NSUInteger maxIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@property (weak, nonatomic) IBOutlet UITableView *playerContractsTableView;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerContractsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.playerContractsTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    maxIndex = [[NSNumber numberWithUnsignedInteger:[self.contractList count]]unsignedIntegerValue] - 1;
    
    //set label values
    self.nameLabel.text = [[[self.contractList objectAtIndex: maxIndex]player]name];
    self.positionLabel.text = [(Contract *)[self.contractList objectAtIndex:maxIndex]position];
    self.teamLogo.image = [UIImage imageNamed:[[[self.contractList objectAtIndex:maxIndex]team]logo]];
    
    //set label colors
    NSString *primaryColor = [[[self.contractList objectAtIndex:maxIndex]team]primary_color];
    [self.nameLabel setTextColor:[ColorUtilities colorFromHexString:primaryColor]];
    [self.positionLabel setTextColor:[ColorUtilities colorFromHexString:primaryColor]];
    
    //resize labels
    [self.nameLabel sizeToFit];
    [self.positionLabel sizeToFit];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contractList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerContractsCell" forIndexPath:indexPath];
    NSNumber *year = [(Contract *)[self.contractList objectAtIndex:indexPath.row]year];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", year];
    cell.detailTextLabel.text = [StringFormatters formatCurrency: [[self.contractList objectAtIndex:indexPath.row] capCharge]];
    return cell;
}

@end
