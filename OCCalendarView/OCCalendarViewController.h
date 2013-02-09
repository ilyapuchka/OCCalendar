//
//  OCCalendarViewController.h
//  OCCalendar
//
//  Created by Oliver Rickard on 3/31/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarView.h"

@class OCCalendarView;

@protocol OCCalendarDelegate <NSObject>

-(void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

-(void)completedWithNoSelection;

@end

@interface OCCalendarViewController : UIViewController <UIGestureRecognizerDelegate> {
}

@property (nonatomic, weak) id <OCCalendarDelegate> delegate;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic) OCSelectionMode selectionMode;
@property (nonatomic, copy) NSArray *enabledDates;
@property (nonatomic, weak) UIView *parentView;

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v;
- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap;
- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap selectionMode:(OCSelectionMode)sm;
- (void)removeCalViewAnimated;

@end
