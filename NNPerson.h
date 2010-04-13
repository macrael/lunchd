//
//  NNPerson.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNLStatics.h"

@interface NNPerson : NSObject {
	NSString *name;
	int state;
	NSString *veto;		//veto is a string if it has been used, or nil if it has not.
	NSMutableArray *votes;		//votes is a list of strings of restraunts they have voted for.
	NSString *host;
	BOOL gameIsOver;
}

@property (copy) NSString *name;
@property (assign) int state;
@property (copy) NSString *veto;
@property (retain) NSMutableArray *votes;
@property (copy) NSString *host;
@property (assign) BOOL gameIsOver;


- (void)voteFor:(NSString *)restaurant;
- (void)giveVeto:(NSString *)restaurant;


@end