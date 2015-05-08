//
//  TeamViewController.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "TeamViewController.h"

@interface TeamViewController ()
{
    NSNumber *year;
    NSArray *contracts;
    NSArray *selectedPlayerContracts;
}
@property (nonatomic, strong) IBOutlet UITableView *playerTeamTableView;
@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.team name];
    year = @2014;
    DbHandler *handler = [DbHandler getInstance];
    NSString *sql = [NSString stringWithFormat:@"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.team = %@ and c.year = %@", [self.team teamId], year];
    contracts = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[Contract getContractResolver]]];
    
    contracts = [contracts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Contract *c1 = (Contract *)obj1;
        Contract *c2 = (Contract *)obj2;
        return -[c1.capCharge compare:c2.capCharge];
    }];
    
    [self.playerTeamTableView reloadData];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DbHandler *handler = [DbHandler getInstance];
    
    NSNumber *playerId = [[[contracts objectAtIndex:[indexPath row]]player]playerId];
    
    NSString *sql = [NSString stringWithFormat:@"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.player = %@", playerId];
    selectedPlayerContracts = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[Contract getContractResolver]]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return indexPath;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contracts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerTeamTableViewCell" forIndexPath:indexPath];
    Contract *contract = [contracts objectAtIndex:[indexPath row]];
    
    cell.nameLabel.text = [[contract player]name];
    [cell.nameLabel sizeToFit];
    cell.positionLabel.text = [contract position];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *capChargeFormatted = [formatter stringFromNumber:[contract capCharge]];
    
    cell.capChargeLabel.text = capChargeFormatted;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"teamToPlayerDetailsSegue"]){
        PlayerViewController *ctrl = segue.destinationViewController;
        [ctrl setContractList:selectedPlayerContracts];
    }
}

@end
