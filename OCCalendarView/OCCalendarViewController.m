//
//  OCCalendarViewController.m
//  OCCalendar
//
//  Created by Oliver Rickard on 3/31/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "OCCalendarViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OCCalendarViewController () <OCCalendarViewDelegate>

@property (nonatomic, strong) UILabel *toolTipLabel;
@property (nonatomic, strong) OCCalendarView *calView;

@property (nonatomic) CGPoint insertPoint;
@property (nonatomic) OCArrowPosition arrowPos;

@end

@implementation OCCalendarViewController

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap selectionMode:(OCSelectionMode)sm {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _insertPoint = point;
        _parentView = v;
        _arrowPos = ap;
        _selectionMode = sm;
    }
    return self;
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v arrowPosition:(OCArrowPosition)ap {
    return [self initAtPoint:point inView:v arrowPosition:ap selectionMode:OCSelectionDateRange];
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)v {
    return [self initAtPoint:point inView:v arrowPosition:OCArrowPositionCentered];
}

- (void)loadView {
    [super loadView];
    self.view.frame = self.parentView.frame;
    
    
    //this view sits behind the calendar and receives touches.  It tells the calendar view to disappear when tapped.
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] init];
    tapG.delegate = self;
    [bgView addGestureRecognizer:tapG];
    [bgView setUserInteractionEnabled:YES];
    
    [self.view addSubview:bgView];
    
    int width = 390;
    int height = 300;
    
    float arrowPosX = 208;
    
    if(self.arrowPos == OCArrowPositionLeft) {
        arrowPosX = 67;
    } else if(self.arrowPos == OCArrowPositionRight) {
        arrowPosX = 346;
    }
    
    self.calView = [[OCCalendarView alloc] initAtPoint:self.insertPoint withFrame:CGRectMake(self.insertPoint.x - arrowPosX, self.insertPoint.y - 31.4, width, height) arrowPosition:self.arrowPos];
    [self.calView setSelectionMode:self.selectionMode];
    self.calView.delegate = self;
    
    if(self.enabledDates) {
        [self.calView setEnabledDates:self.enabledDates];
    }
    if(self.startDate) {
        [self.calView setStartDate:self.startDate];
    }
    if(self.endDate) {
        [self.calView setEndDate:self.endDate];
    }
    [self.view addSubview:self.calView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setStartDate:(NSDate *)sDate {
    if(_startDate) {
        _startDate = nil;
    }
    _startDate = [sDate copy];
    [self.calView setStartDate:_startDate];
}

- (void)setEndDate:(NSDate *)eDate {
    if(_endDate) {
        _endDate = nil;
    }
    _endDate = [eDate copy];
    [self.calView setEndDate:_endDate];
}

- (void)setEnabledDates:(NSArray *)enabledDates
{
    _enabledDates = [enabledDates copy];
    [self.calView setEnabledDates:_enabledDates];
}

- (void)removeCalView {
    self.startDate = [self.calView getStartDate];
    self.endDate = [self.calView getEndDate];
    
    //NSLog(@"startDate:%@ endDate:%@", startDate.description, endDate.description);
    
    //NSLog(@"CalView Selected:%d", [calView selected]);
    
    if([self.calView selected]) {
        if([self.startDate compare:self.endDate] == NSOrderedAscending)
            [self.delegate completedWithStartDate:self.startDate endDate:self.endDate];
        else
            [self.delegate completedWithStartDate:self.endDate endDate:self.startDate];
    } else {
        [self.delegate completedWithNoSelection];
    }
    
    [self.calView removeFromSuperview];
    self.calView = nil;
}

- (void)didChangeSelection:(BOOL)selected
{
    [self removeCalViewAnimated];
}

- (void)removeCalViewAnimated
{
    [UIView beginAnimations:@"animateOutCalendar" context:nil];
    [UIView setAnimationDuration:0.4f];
    self.calView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.calView.alpha = 0.0f;
    [UIView commitAnimations];

    [self performSelector:@selector(removeCalView) withObject:nil afterDelay:0.4f];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(self.calView) {
        //Animate out the calendar view if it already exists
        [self removeCalViewAnimated];
    } else {
        //Recreate the calendar if it doesn't exist.
        
        //CGPoint insertPoint = CGPointMake(200+130*0.5, 200+10);
        CGPoint point = [touch locationInView:self.view];
        int width = 390;
        int height = 300;
        
        self.calView = [[OCCalendarView alloc] initAtPoint:point withFrame:CGRectMake(point.x - width*0.5, point.y - 31.4, width, height)];
        [self.view addSubview:self.calView];
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
