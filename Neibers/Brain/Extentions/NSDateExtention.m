//
//  NSDateExtention.m
//  CoffeeConnect
//
//  Created by Ivan Chubov on 3/12/12.
//  Copyright 2012 Ideas. All rights reserved.
//

#import "NSDateExtention.h"


@implementation NSDate (NSDateExtention)
- (NSDate *)addDays:(short)days {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *resultDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    
    return resultDate;
}

- (NSDateComponents *)diffWithDate:(NSDate *)toDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit
                                                   fromDate:self 
                                                     toDate:toDate 
                                                    options:0];
    
    return dateComponents;
}

- (int)yearsDiffWithDate:(NSDate *)date {
    return [[self diffWithDate:date] year];
}

- (int)mountsDiffWithDate:(NSDate *)date {
    return [[self diffWithDate:date] month];
}

- (int)daysDiffWithDate:(NSDate *)date {
    return [[self diffWithDate:date] day];
}

- (int)hourDiffWithDate:(NSDate *)date {
    return [[self diffWithDate:date] hour];
}

- (int)minutesDiffWithDate:(NSDate *)date {
    return [[self diffWithDate:date] minute];
}

- (int)secondsDiffWithDate:(NSDate *)date {
    return [[self diffWithDate:date] second];
}

@end
