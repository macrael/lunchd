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
	NSArray *votes;		//votes is a list of strings of restraunts they have voted for. 
}

@property (copy) NSString *name;
@property (assign) int state;
@property (copy) NSString *veto;
@property (retain) NSArray *votes;

@end
