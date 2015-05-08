//
//  Player.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "Player.h"

@implementation Player
const DbObjectResolver playerResolver = ^id (sqlite3_stmt* statement){
    Player* player = [[Player alloc] init];
    player.playerId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
    player.accrued = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
    player.dateOfBirth = sqlite3_column_text(statement, 2) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
    player.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
    player.notes = sqlite3_column_text(statement, 4) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
    player.college = sqlite3_column_text(statement, 5) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
    player.draftPick = sqlite3_column_int(statement, 6) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
    player.draftRound = sqlite3_column_int(statement, 7) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 7)];
    player.draftYear = sqlite3_column_int(statement, 8) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
    player.height = sqlite3_column_int(statement, 9) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 9)];
    player.weight = sqlite3_column_int(statement, 10) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 10)];
    
    Team *team = [[Team alloc]init];
    [team setTeamId:[NSNumber numberWithInt:sqlite3_column_int(statement, 11)]];
    player.originalTeam = team;
    
    return player;
};

+(DbObjectResolver)getPlayerResolver{
    return playerResolver;
}
@end
