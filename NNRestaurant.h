//
//  NNRestaurant.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNLStatics.h"

@interface NNRestaurant : NSObject <NSCopying> {
	NSString *name;
	int votes;		//-1 for vetoed, 0 for neutral, + for number?
	BOOL hasYourVote;
}

@property (copy) NSString *name;
@property (assign) int votes;
@property (assign) BOOL hasYourVote;

- (id)initWithName:(NSString *)theName;

- (void)giveVote;
- (void)giveVeto;

@end
