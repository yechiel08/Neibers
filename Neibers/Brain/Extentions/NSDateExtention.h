//
//  NSDateExtention.h
//  CoffeeConnect
//
//  Created by Ivan Chubov on 3/12/12.
//  Copyright 2012 Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (NSDateExtention)

/*
 Add days to current date;
 */
- (NSDate *)addDays:(short)days;

/*
 Return difference between current date and 'toDate';
 */
- (NSDateComponents *)diffWithDate:(NSDate *)toDate;

/*
 Return difference between current date and 'date' in years;
 */
- (int)yearsDiffWithDate:(NSDate *)date;

/*
 Return difference between current date and 'date' in days;
 */
- (int)daysDiffWithDate:(NSDate *)date;

/*
 Return difference between current date and 'date' in minutes;
 */
- (int)minutesDiffWithDate:(NSDate *)date;

- (int)hourDiffWithDate:(NSDate *)date;

- (int)mountsDiffWithDate:(NSDate *)date;

- (int)secondsDiffWithDate:(NSDate *)date;

@end
