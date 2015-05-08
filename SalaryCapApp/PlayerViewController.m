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
    [self.playerContractsTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    maxIndex = [[NSNumber numberWithUnsignedInteger:[self.contractList count]]unsignedIntegerValue] - 1;
    self.nameLabel.text = [[[self.contractList objectAtIndex: maxIndex]player]name];
    self.positionLabel.text = [(Contract *)[self.contractList objectAtIndex:maxIndex]position];
    self.teamLogo.image = [UIImage imageNamed:[[[self.contractList objectAtIndex:maxIndex]team]logo]];
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *capChargeFormatted = [formatter stringFromNumber:[[self.contractList objectAtIndex:indexPath.row] capCharge]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", year];
    cell.detailTextLabel.text = capChargeFormatted;
    return cell;
}

@end
