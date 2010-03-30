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
	int votes;		//- for vetoes, 0 for neutral, + for number?  BADBAD if you unveto, you lose the votes. 
	int vetos;		//TODO use vetos count instead. just increment and decrement. if it is greater than zero, you have a veto. 
	BOOL hasYourVote;
}

@property (copy) NSString *name;
@property (assign) int votes;
@property (assign) BOOL hasYourVote;

- (id)initWithName:(NSString *)theName;

- (void)giveVote;
- (void)giveVeto;

@end
