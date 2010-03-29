//
//  NNNetworkSync.m
//  lunchd
//
//  Created by MacRae Linton on 3/28/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNNetworkSync.h"

#define LUNCH_SERVICE_PORT 2763

@implementation NNNetworkSync

- (IBAction)startServer:(id)sender
{
	NSLog(@"Starting SErVER");
	
	connectedSockets = [[NSMutableArray alloc] initWithCapacity:5];
	
	// Start listening socket
    NSError *error;
    listeningSocket = [[AsyncSocket alloc] initWithDelegate:self];
    if ( ![listeningSocket acceptOnPort:LUNCH_SERVICE_PORT error:&error] ) {
        NSLog(@"Failed to create listening socket");
        return;
    }
	
    // Advertise service with bonjour
//    NSString *serviceName = [NSString stringWithFormat:@"Lunchd on %@", 
//							 [[NSProcessInfo processInfo] hostName]];
//    netService = [[NSNetService alloc] initWithDomain:@"" 
//												 type:@"_lunchd._tcp." 
//												 name:serviceName 
//												 port:listeningSocket.localPort];
//    netService.delegate = self;
//    [netService publish];
	
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	[connectedSockets addObject:newSocket];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Accepted client %@:%hu", host, port);
	
	//Send no message on accepting. 
	
	//NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
	//NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
	
	//[sock writeData:welcomeData withTimeout:-1 tag:0];
	
	// We could call readDataToData:withTimeout:tag: here - that would be perfectly fine.
	// If we did this, we'd want to add a check in onSocket:didWriteDataWithTag: and only
	// queue another read if tag != WELCOME_MSG.
	
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] autorelease];
	if(msg)
	{
		NSLog(@"SERVER REC:%@",msg);
	}
	else
	{
		NSLog(@"Error converting received data into UTF-8 String");
	}
	
	NSString *responseMsg = @"I AM SERVER\r\n";
	
	// Even if we were unable to write the incoming data to the log,
	// we're still going to echo it back to the client.
	
	NSData *responseData = [responseMsg dataUsingEncoding:NSUTF8StringEncoding];
	[sock writeData:responseData withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[connectedSockets removeObject:sock];
}

@end








@implementation NNMessageSender

- (IBAction)testServer:(id)sender
{
	NSLog(@"Testing SERVER");
	
	AsyncSocket *sendSocket = [[AsyncSocket alloc] initWithDelegate:self];
	NSError *err;
	if (! [sendSocket connectToHost:@"192.168.10.101" onPort:LUNCH_SERVICE_PORT error:&err]){
		NSLog(@"FAILED TO CONNNECT");
		return;
	}
	
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	NSLog(@"ACCEPTED");
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Got server %@:%hu", host, port);
	
	NSString *welcomeMsg = @"I AM CLIENT MACRAE\r\n";
	NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:welcomeData withTimeout:-1 tag:0];
	
	// We could call readDataToData:withTimeout:tag: here - that would be perfectly fine.
	// If we did this, we'd want to add a check in onSocket:didWriteDataWithTag: and only
	// queue another read if tag != WELCOME_MSG.
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] autorelease];
	if(msg)
	{
		NSLog(@"CLIENT REC:%@",msg);
	}
	else
	{
		NSLog(@"Error converting received data into UTF-8 String");
	}
	
	// Even if we were unable to write the incoming data to the log,
	// we're still going to echo it back to the client.
	//[sock writeData:data withTimeout:-1 tag:1];
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	
}

@end





@implementation NNNMessage

@synthesize tag;
@synthesize state;
@synthesize name;
@synthesize veto;
@synthesize votes;
@synthesize restaurantList;

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self){
		[self setAnumber: [aDecoder decodeIntForKey:@"aNumber"]];
		[self setMessage: [aDecoder decodeObjectForKey:@"message"]];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:[self anumber] forKey:@"aNumber"];
	[aCoder encodeObject:[self message] forKey:@"message"];
}

@end
