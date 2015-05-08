//
//  Contract.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "Contract.h"

@implementation Contract
const DbObjectResolver contractResolver = ^id (sqlite3_stmt* statement){
    //Create Player
    Player *player = [[Player alloc]init];
    player.playerId = [NSNumber numberWithInt:sqlite3_column_int(statement, 18)];
    player.accrued = [NSNumber numberWithInt:sqlite3_column_int(statement, 19)];
    player.dateOfBirth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
    player.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
    
    //Create Team
    Team *team = [[Team alloc]init];
    team.teamId =  [NSNumber numberWithInt:sqlite3_column_int(statement, 30)];
    team.name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,31)];
    team.logo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,32)];
    team.primary_color = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,33)];
    team.secondary_color = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,34)];

    Contract* contract = [[Contract alloc] init];
    @try {
        contract.contractId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        contract.player = player;
        contract.team = team;
        contract.year = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
        contract.baseSalary = [NSNumber numberWithInt:sqlite3_column_int(statement, 4)];
        contract.capCharge = [NSNumber numberWithInt:sqlite3_column_int(statement, 5)];
        contract.capSavings = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
        contract.deadMoney = [NSNumber numberWithInt:sqlite3_column_int(statement, 7)];
        contract.guaranteedBaseSalary = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
        contract.notes = sqlite3_column_text(statement,9) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        contract.optionBonus = sqlite3_column_int(statement, 10) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 10)];
        contract.signingBonus = sqlite3_column_int(statement, 11) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 11)];
        contract.rosterBonus = sqlite3_column_int(statement, 12) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 12)];
        contract.workoutBonus = sqlite3_column_int(statement, 13) == nil ? nil : [NSNumber numberWithInt:sqlite3_column_int(statement, 13)];
        contract.teamName = sqlite3_column_text(statement, 14) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
        contract.role = sqlite3_column_text(statement, 15) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
        contract.status = sqlite3_column_text(statement, 16) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
        contract.position = sqlite3_column_text(statement, 17) == nil ? nil : [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
    } @catch(NSException *theException) {
        //TODO Log error
    }
    
    return contract;
};


+(DbObjectResolver)getContractResolver{
    return contractResolver;
}

@end
