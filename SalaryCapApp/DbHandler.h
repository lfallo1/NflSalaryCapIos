//
//  Model.h
//  SqliteDemo
//
//  Created by Lance Fallon on 4/26/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

typedef id (^DbObjectResolver)(sqlite3_stmt*);

@interface DbHandler : NSObject
+(DbHandler*) getInstance;
-(NSNumber*)execute:(NSString*)sql;
-(NSArray*) query:(NSString *)sql withCallback:(DbObjectResolver)callback;

@end
