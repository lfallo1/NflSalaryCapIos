//
//  StringFormatters.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/9/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFormatters : NSObject
+(NSString *)formatDate:(NSDate *)date withFormat:(NSString *)format;
+(NSString *)formatCurrency:(NSNumber *)number;
@end
