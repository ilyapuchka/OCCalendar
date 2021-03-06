//
//  OCCalendarView.h
//  OCCalendar
//
//  Created by Oliver Rickard on 3/30/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCTypes.h"
typedef enum {
  OCArrowPositionLeft = -1,
  OCArrowPositionCentered = 0,
  OCArrowPositionRight = 1,
  OCArrowPositionNone = 99
} OCArrowPosition;


@class OCSelectionView;
@class OCDaysView;

@protocol OCCalendarViewDelegate <NSObject>

- (void)didChangeSelection:(BOOL)selected;

@end


@interface OCCalendarView : UIView {
    int currentMonth;
    int currentYear;
    
    int startCellX;
    int startCellY;
    int endCellX;
    int endCellY;
    
    float hDiff;
    float vDiff;
    
    OCSelectionView *selectionView;
    OCDaysView *daysView;
    
    int arrowPosition;
}

- (id)initAtPoint:(CGPoint)p withFrame:(CGRect)frame;
- (id)initAtPoint:(CGPoint)p withFrame:(CGRect)frame arrowPosition:(OCArrowPosition)arrowPos;

//Valid Positions: OCArrowPositionLeft, OCArrowPositionCentered, OCArrowPositionRight
- (void)setArrowPosition:(OCArrowPosition)pos;

- (NSDate *)getStartDate;
- (NSDate *)getEndDate;

- (BOOL)selected;

- (void)setStartDate:(NSDate *)sDate;
- (void)setEndDate:(NSDate *)eDate;

- (void)setEnabledDates:(NSArray *)enableDates;

@property OCSelectionMode selectionMode;
@property (nonatomic, retain) NSArray *enabledDates;
@property (nonatomic, assign) id<OCCalendarViewDelegate> delegate;

@end
