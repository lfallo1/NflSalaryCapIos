//
//  Model.m
//  SqliteDemo
//
//  Created by Lance Fallon on 4/26/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//
#import "DbHandler.h"

@interface DbHandler()
@property (nonatomic, strong) NSString* documents;
@property (nonatomic, strong) NSString* database;
@end

@implementation DbHandler

static DbHandler *instance;

+(DbHandler*) getInstance
{
    if(instance == nil)
    {
        //TODO: Replace this hardcoded string with a cnofigurable string
        instance = [[DbHandler alloc] initWithDatabaseFilename:@"nflsalarycap.sqlite"];
    }
    return instance;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"SingletonInstantiationException" reason:@"This class is a singleton and should be accessed through the getInstance method" userInfo:nil];
}

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename
{
    self = [super init];
    if (self)
    {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documents = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.database = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

-(void) copyDatabaseIntoDocumentsDirectory
{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documents stringByAppendingPathComponent:self.database];
    
    // copy db from main bundle regardless, because no data is to ever be permanently persisted.
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.database];
    NSError *error;
    
    //delete db in documents directory, and copy over template
    [[NSFileManager defaultManager]removeItemAtPath:destinationPath error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    
    // Check if any error occurred during copying and display it.
    if (error != nil)
    {
        //TODO: replace with logging implmentation
        NSLog(@"%@", [error description]);
    }

}

-(NSNumber*) execute:(NSString *)sql
{
    NSNumber *returnCount = 0;
    sqlite3 *database;
    NSString *connection = [self.documents stringByAppendingPathComponent:self.database];
    if(sqlite3_open([connection UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt *query;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &query, nil) == SQLITE_OK)
        {
            if(sqlite3_step(query) == SQLITE_DONE)
            {
                returnCount = [NSNumber numberWithInt:sqlite3_changes(database)];
            } else
            {
                //TODO: replace with logging implementation
                NSLog(@"Error: %s", sqlite3_errmsg(database));
                
            }
        }
        sqlite3_finalize(query);
    }
    sqlite3_close_v2(database);
    return returnCount;
}

-(NSArray*) query:(NSString *)sql withCallback:(DbObjectResolver) callback
{
    sqlite3 *database;
    NSMutableArray *returnObjects = [[NSMutableArray alloc]init];
    
    NSString *connection = [self.documents stringByAppendingPathComponent:self.database];
    if(sqlite3_open([connection UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                id tmp = callback(statement);
                [returnObjects addObject:tmp];
            }
        }
    }
    return returnObjects;
    
}

@end
