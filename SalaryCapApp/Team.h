//
//  Team.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/4/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbHandler.h"

@interface Team : NSObject
{
    const DbObjectResolver teamResolver;
}
@property (nonatomic, strong) NSNumber *teamId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *primary_color;
@property (nonatomic, strong) NSString *secondary_color;

+ (DbObjectResolver)getResolver;
@end
