//
//  OCDaysView.m
//  OCCalendar
//
//  Created by Oliver Rickard on 3/30/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "OCDaysView.h"
#import "CCLocalizationManager.h"

@interface OCDaysView()

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation OCDaysView

- (void)setEnabledDates:(NSArray *)enabledDates
{
    _enabledDates = [enabledDates copy];
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [CCLocalizationManager calendarForCurrentLanguage];
    }
    return _calendar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
        startCellX = 3;
        startCellY = 0;
        endCellX = 3;
        endCellY = 0;
        
		hDiff = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 41 : 43;
        vDiff = 30;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGSize shadow2Offset = CGSizeMake(1, 1);
    CGFloat shadow2BlurRadius = 1;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    
    int month = currentMonth;
    int year = currentYear;
	
	//Get the first day of the month
	NSDateComponents *dateParts = [[NSDateComponents alloc] init];
	[dateParts setMonth:month];
	[dateParts setYear:year];
	[dateParts setDay:1];
	NSDate *dateOnFirst = [self.calendar dateFromComponents:dateParts];
	
    NSDateComponents *weekdayComponents = [self.calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
	int weekdayOfFirst = [weekdayComponents weekday];
    
    weekdayOfFirst = [self.calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:dateOnFirst];
    
    //NSLog(@"weekdayOfFirst:%d", weekdayOfFirst);

	int numDaysInMonth = [self.calendar rangeOfUnit:NSDayCalendarUnit 
										inUnit:NSMonthCalendarUnit 
                                       forDate:dateOnFirst].length;
    
    //NSLog(@"month:%d, numDaysInMonth:%d", currentMonth, numDaysInMonth);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    didAddExtraRow = NO;
    
    
    
    //Find number of days in previous month
    NSDateComponents *prevDateParts = [[NSDateComponents alloc] init];
	[prevDateParts setMonth:month-1];
	[prevDateParts setYear:year];
	[prevDateParts setDay:1];
    
    NSDate *prevDateOnFirst = [self.calendar dateFromComponents:prevDateParts];
    
    int numDaysInPrevMonth = [self.calendar rangeOfUnit:NSDayCalendarUnit
										inUnit:NSMonthCalendarUnit 
                                       forDate:prevDateOnFirst].length;
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    //Draw the text for each of those days.
    for(int i = 0; i <= weekdayOfFirst-2; i++) {
        int day = numDaysInPrevMonth - weekdayOfFirst + 2 + i;
        
        NSString *str = [NSString stringWithFormat:@"%d", day];
        
        
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
        CGRect dayHeader2Frame = CGRectMake((i)*hDiff, 0, 21, 14);
        [[UIColor colorWithWhite:0.6f alpha:1.0f] setFill];
        [str drawInRect: dayHeader2Frame withFont: [UIFont fontWithName: @"Helvetica" size: 12] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
        CGContextRestoreGState(context);
    }
    
    
    BOOL endedOnSat = NO;
	int finalRow = 0;
	int day = 1;
	NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    for (int i = 0; i < 6; i++) {
		for(int j = 0; j < 7; j++) {
			int dayNumber = i * 7 + j;
			
			if(dayNumber >= (weekdayOfFirst-1) && day <= numDaysInMonth) {
                NSString *str = [NSString stringWithFormat:@"%d", day];
                
                CGContextSaveGState(context);
                CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
                CGRect dayHeader2Frame = CGRectMake(j*hDiff, i*vDiff, 21, 14);
                if([today day] == day && [today month] == month && [today year] == year) {
                    [[UIColor colorWithRed: 0.98 green: 0.24 blue: 0.09 alpha: 1] setFill];
                } else {
                    [comps setDay:day]; [comps setMonth:month]; [comps setYear:year];
                    NSDate *date = [self.calendar dateFromComponents:comps];
                    if ([self.enabledDates containsObject:date]) {
                        [[UIColor whiteColor] setFill];
                    }
                    else {
                        [[UIColor grayColor] setFill];
                    }
                }
                [str drawInRect: dayHeader2Frame withFont: [UIFont fontWithName: @"Helvetica" size: 12] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
                CGContextRestoreGState(context);
                
                finalRow = i;
                
                if(day == numDaysInMonth && j == 6) {
                    endedOnSat = YES;
                }
                
                if(i == 5) {
                    didAddExtraRow = YES;
                    //NSLog(@"didAddExtraRow");
                }
                
				++day;
			}
		}
	}
    
    //Find number of days in previous month
    NSDateComponents *nextDateParts = [[NSDateComponents alloc] init];
	[nextDateParts setMonth:month+1];
	[nextDateParts setYear:year];
	[nextDateParts setDay:1];
    
    NSDate *nextDateOnFirst = [self.calendar dateFromComponents:nextDateParts];
    
    NSDateComponents *nextWeekdayComponents = [self.calendar components:NSWeekdayCalendarUnit fromDate:nextDateOnFirst];
	int weekdayOfNextFirst = [nextWeekdayComponents weekday];
    
    if(!endedOnSat) {
        //Draw the text for each of those days.
        for(int i = weekdayOfNextFirst - 1; i < 7; i++) {
            int day = i - weekdayOfNextFirst + 2;
            
            NSString *str = [NSString stringWithFormat:@"%d", day];
            
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
            CGRect dayHeader2Frame = CGRectMake((i)*hDiff, finalRow * vDiff, 21, 14);
            [[UIColor colorWithWhite:0.6f alpha:1.0f] setFill];
            [str drawInRect: dayHeader2Frame withFont: [UIFont fontWithName: @"Helvetica" size: 12] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
            CGContextRestoreGState(context);
        }
    }
}

- (void)setMonth:(int)month {
    currentMonth = month;
    [self setNeedsDisplay];
}

- (void)setYear:(int)year {
    currentYear = year;
    [self setNeedsDisplay];
}

- (void)resetRows {
    int month = currentMonth;
    int year = currentYear;
	
	//Get the first day of the month
	NSDateComponents *dateParts = [[NSDateComponents alloc] init];
	[dateParts setMonth:month];
	[dateParts setYear:year];
	[dateParts setDay:1];
	NSDate *dateOnFirst = [self.calendar dateFromComponents:dateParts];
	
    NSDateComponents *weekdayComponents = [self.calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
	int weekdayOfFirst = [weekdayComponents weekday];	
    
	int numDaysInMonth = [self.calendar rangeOfUnit:NSDayCalendarUnit 
										inUnit:NSMonthCalendarUnit 
                                       forDate:dateOnFirst].length;
    didAddExtraRow = NO;
	
	int day = 1;
	for (int i = 0; i < 6; i++) {
		for(int j = 0; j < 7; j++) {
			int dayNumber = i * 7 + j;
			if(dayNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                if(i == 5) {
                    didAddExtraRow = YES;
                    //NSLog(@"didAddExtraRow");
                }
				++day;
			}
		}
	}
}

- (BOOL)addExtraRow {
    return didAddExtraRow;
}


@end
