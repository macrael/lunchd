//
//  NNNetworkSync.h
//  lunchd
//
//  Created by MacRae Linton on 3/28/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"


@interface NNNetworkSync : NSObject {
	AsyncSocket *listeningSocket;
	NSNetService *netService;
	NSMutableArray *connectedSockets;
}

- (IBAction)startServer:(id)sender;

@end


@interface NNMessageSender : NSObject{
	
}

- (IBAction)testServer:(id)sender;

@end



@interface NNNMessage : NSObject <NSCoding> {
	int tag;
	int state;
	NSString *name;
	NSString *veto;
	NSArray *votes;
	NSArray *restaurantList;
	
}

@property (assign) int tag;
@property (assign) int state;
@property (copy) NSString *name;
@property (copy) NSString *veto;
@property (retain) NSArray *votes;
@property (retain) NSArray *restaurantList;

@end