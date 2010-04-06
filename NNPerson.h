//
//  NNPerson.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNLStatics.h"
#import "AsyncSocket.h"

@interface NNPerson : NSObject {
	NSString *name;
	int state;
	NSString *veto;		//veto is a string if it has been used, or nil if it has not.
	NSMutableArray *votes;		//votes is a list of strings of restraunts they have voted for.
	AsyncSocket *socket;
}

@property (copy) NSString *name;
@property (assign) int state;
@property (copy) NSString *veto;
@property (retain) NSMutableArray *votes;
@property (retain) AsyncSocket *socket;


- (void)voteFor:(NSString *)restaurant;
- (void)giveVeto:(NSString *)restaurant;


@end