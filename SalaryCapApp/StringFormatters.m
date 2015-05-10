//
//  StringFormatters.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/9/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "StringFormatters.h"

@implementation StringFormatters

+(NSString *)formatCurrency:(NSNumber *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [formatter stringFromNumber:number];
}

+(NSString *)formatDate:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

@end
