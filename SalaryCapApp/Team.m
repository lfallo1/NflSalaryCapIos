//
//  Team.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/4/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "Team.h"

@implementation Team

const DbObjectResolver teamResolver = ^id (sqlite3_stmt* statement){
    Team* team = [[Team alloc] init];
    team.teamId =  [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
    team.name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,1)];
    team.logo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,2)];
    team.primary_color = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,3)];
    team.secondary_color = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,4)];
    return team;
};

+ (DbObjectResolver)getResolver{
    return teamResolver;
}
@end
