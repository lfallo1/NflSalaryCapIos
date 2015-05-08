//
//  Player.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "DbHandler.h"

@interface Player : NSObject
{
    const DbObjectResolver playerResolver;
}
@property (nonatomic, strong) NSNumber *playerId;
@property (nonatomic, strong) NSNumber *accrued;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *college;
@property (nonatomic, strong) NSNumber *draftPick;
@property (nonatomic, strong) NSNumber *draftRound;
@property (nonatomic, strong) NSNumber *draftYear;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) Team *originalTeam;

+(DbObjectResolver)getPlayerResolver;

@end
