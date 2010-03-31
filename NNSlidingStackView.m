//
//  NNSlidingStackView.m
//  lunchd
//
//  Created by MacRae Linton on 3/26/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNSlidingStackView.h"


@implementation NNSlidingStackView

@synthesize stackBottom;
@synthesize stripeHeight;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		stackBottom = 0.0;
		stripeHeight = 60.0;
		NSLog(@"I HAVE BEEN CREATED");
		arrangedSubViews = [[NSMutableArray alloc] initWithCapacity:5];
	}
    return self;
}

- (BOOL)isFlipped
{
	return YES;
}

- (void)addArrangedSubview:(NSView *)subView
{
	float subViewHeight = [subView frame].size.height;
	[subView setFrameOrigin:(NSPoint){ 0, stackBottom }];
	[self setStackBottom: stackBottom + subViewHeight];
	[self addSubview:subView];
	
	[arrangedSubViews addObject:subView];
	
	if (stackBottom > [self frame].size.height) {
		[self setFrameSize:(NSSize){ [self frame].size.width, stackBottom }];
	}
	
}

- (void)insertArrangedSubview:(NSView *)subView atIndex:(int)index
{
	[self addArrangedSubview:subView];
	[self slideViewAtIndex:[arrangedSubViews count]-1 toIndex:index];
}

- (void)drawRect:(NSRect)rect
{
	//NSLog(@"Drawing RecT!: %@",[NSValue valueWithRect:rect]);
	//Need to draw strips in the background.
	
	NSColor *stripeColor = [NSColor colorWithDeviceRed:.93 green:.95 blue:.99 alpha:1.0];
	[stripeColor set];
	
	int numSections = stackBottom / stripeHeight, i;
//	int startSection = rect.origin.y / stripeHeight;
	float stripeWidth = rect.size.width;
	
	NSRect stripeRect;
	stripeRect.origin = (NSPoint){ 0, stripeHeight };
	stripeRect.size = (NSSize){ stripeWidth, stripeHeight };
	for (i = 0; i< numSections; i++){
		if (i % 2){
			stripeRect.origin.y = i * stripeHeight;
			[NSBezierPath fillRect:stripeRect];
		}
	}
}

- (void)slideViewAtIndex:(int)startIndex toIndex:(int)endIndex
{
	if (startIndex == endIndex){
		return;
	}
	
	NSLog(@"MOVE FROM %d TO %d", startIndex, endIndex);
	
	//grey out layer
	//move all other layers while moving greyed out layer. 
	
	NSView *mommaView = [arrangedSubViews objectAtIndex:startIndex];
	
	NSRect aRect = [mommaView frame];
	
	//Right now we are giving no special treatment to the moved, could probably throw it in.
	[arrangedSubViews removeObjectAtIndex:startIndex];
	[arrangedSubViews insertObject:mommaView atIndex:endIndex];
	
	int i, bottomIndex;
	if (startIndex > endIndex){
		i = endIndex;
		bottomIndex = startIndex;
	}else {
		i = startIndex;
		bottomIndex = endIndex;
	}
	for (i; i <=bottomIndex; i++){
		NSView *babyView = [arrangedSubViews objectAtIndex:i];
		aRect.origin.y = i * stripeHeight;
		[[babyView animator] setFrame:aRect];
	}
	
}

- (void)updateAll
{
	for (NSView *view in arrangedSubViews){
		[view updateState];
	}
}

@end
