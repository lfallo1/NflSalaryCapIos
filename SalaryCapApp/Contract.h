//
//  Contract.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/6/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Player.h"
#import "DbHandler.h"

@interface Contract : NSObject
{
    const DbObjectResolver contractResolver;
}

@property (nonatomic, strong) NSNumber *contractId;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *baseSalary;
@property (nonatomic, strong) NSNumber *capCharge;
@property (nonatomic, strong) NSNumber *capSavings;
@property (nonatomic, strong) NSNumber *deadMoney;
@property (nonatomic, strong) NSNumber *guaranteedBaseSalary;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSNumber *optionBonus;
@property (nonatomic, strong) NSNumber *signingBonus;
@property (nonatomic, strong) NSNumber *rosterBonus;
@property (nonatomic, strong) NSNumber *workoutBonus;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *position;

+(DbObjectResolver)getContractResolver;
@end
