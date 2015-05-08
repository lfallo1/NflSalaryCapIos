//
//  ViewController.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/4/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    NSArray *teams;
    Team *selectedTeam;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DbHandler *db = [DbHandler getInstance];
    teams = [[NSArray alloc]initWithArray: [db query:@"select * from team where id > 0 order by name" withCallback:[Team getResolver]]];
    
    [self.teamTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [teams count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    Team *team = [teams objectAtIndex:indexPath.row];
    cell.teamLabel.text = [team name];
    cell.teamLogo.image = [UIImage imageNamed:team.logo];
    cell.teamLabel.textColor = [ColorUtilities colorFromHexString: (team.secondary_color)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedTeam = [teams objectAtIndex:indexPath.row];
    return indexPath;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"TeamToTeamPageSegue"]){
        TeamViewController *ctrl = segue.destinationViewController;
        [ctrl setTeam:selectedTeam];
    }
}

@end
