//
//  NNSlidingStackView.h
//  lunchd
//
//  Created by MacRae Linton on 3/26/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//It is assumed this is in a scrollview.

@interface NNSlidingStackView : NSView {
	NSMutableArray *arrangedSubViews;
	float stackBottom;
	float stripeHeight;
}
@property (assign) float stackBottom;
@property (assign) float stripeHeight;

- (void)addArrangedSubview:(NSView *)subView;
- (void)insertArrangedSubview:(NSView *)subView atIndex:(int)index;
- (void)slideViewAtIndex:(int)startIndex toIndex:(int)endIndex;



@end
