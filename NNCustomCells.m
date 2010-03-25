//
//  NNCustomCells.m
//  lunchd
//
//  Created by MacRae Linton on 3/24/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNCustomCells.h"


@implementation NNRestaurantCell

//@synthesize representedRestaurant;

- (id)initTextCell:(NSString *)aString
{
	self = [super initTextCell:aString];
	if (self){
		NSLog(@"CELL INITING!");
		downbutton = 0;
	}
	return self;
}

- (void)awakeFromNib
{
	NSLog(@"NINY CIELLL Woke Up");
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NNRestaurant *representedRestaurant = [self objectValue];
	
	NSDictionary * textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont userFontOfSize:12.0],NSFontAttributeName, nil];
	
	
	NSImage *vetoRegImage = [NSImage imageNamed:@"veto_reg.png"];
	
	NSPoint cellPoint = cellFrame.origin;
	NSPoint endPoint = NSMakePoint(NSMaxX(cellFrame), NSMaxY(cellFrame));
	
	NSImage *displayVote;
	
	[controlView lockFocus];
	if (downbutton == -1){
		displayVote = [NSImage imageNamed:@"vote_press.png"];
	}else {
		displayVote = [NSImage imageNamed:@"vote_reg.png"];
	}
	
	[displayVote compositeToPoint:NSMakePoint(cellPoint.x+4, cellPoint.y+17) operation:NSCompositeSourceOver];
	
	[[representedRestaurant name] drawAtPoint:NSMakePoint(cellPoint.x+23, cellPoint.y+2) withAttributes:textAttributes];
	
	[vetoRegImage compositeToPoint:NSMakePoint(endPoint.x-20, endPoint.y) operation:NSCompositeSourceOver];
	
	[controlView unlockFocus];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView
{
	return 1 << 2;
}
- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{
	NSLog(@"START TRACK");
	NSLog(@"x:%f\ty:%f",startPoint.x,startPoint.y);
	
	if (startPoint.x < 20){
		downbutton = -1;
	}else {
		downbutton = 0;
	}
	
	return YES;
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView
{
	NSLog(@"CONT TRACK");
	if (lastPoint.x < 20){
		downbutton = -1;
	}else {
		downbutton = 0;
	}
	
	return YES;
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
	downbutton = 0;
	if (stopPoint.x <20){
		[[self representedObject] giveVote];
		//animate?
	}
	NSLog(@"STOP THAT TRCK>");
	
	
}


@end


@implementation NNPersonCell

@end