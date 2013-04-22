//
//  SMAppDelegate.m
//  UnoIno
//
//  Created by Joel Saltzman on 4/15/13.
//  Copyright (c) 2013 joelsaltzman.com. All rights reserved.
//

#import "SMAppDelegate.h"

@implementation SMAppDelegate

//------------------------------------------
#pragma mark Properties
//------------------------------------------

//------------------------------------------
#pragma mark Methods
//------------------------------------------
- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self.serialPort close];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _inHandle = nil;
    [_serialPort close];
    _serialPort = nil;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self setupNotifications];
        [self setupForInput];
    }
    return self;
}
- (void)setupForInput
{
    // Read from stdin
    self.inHandle = [NSFileHandle fileHandleWithStandardInput];
    
    // Listen for incoming data notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputAvailable) name:NSFileHandleDataAvailableNotification object:self.inHandle];
    
    //waits in the background for input
    [self.inHandle waitForDataInBackgroundAndNotify];
}
- (void)inputAvailable
{
    NSData *data = NULL;
    NSString *inputStr = NULL;
    
    //get the data from input
    data = [self.inHandle availableData];
    if ([data length] == 0) {
        return;
    }
    
    //if we aren't getting output, disconnect the USB, reconnect it and wait. If still nothing, type reconnect in the console to manually try to reconnect.
    inputStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([inputStr isEqualToString:@"reconnect\n"]){
        NSLog(@"trying to reconnect");
        [self setupForPort:self.serialPort.path];
        return;
    }
    
    
    //send it to the serial
    [self.serialPort sendData:data];
    
    //wait for more input
    [self.inHandle waitForDataInBackgroundAndNotify];
}

- (void)setupForPort:(NSString *)portPath
{
    if([portPath rangeOfString:@"*"].location != NSNotFound){
        NSLog(@"Do not use * in the board path");
        portPath = [portPath stringByReplacingOccurrencesOfString:@"*" withString:@""];
    }
    
    NSArray *ports = [[ORSSerialPortManager sharedSerialPortManager] availablePorts];
	for (ORSSerialPort *port in ports) {
        [port close];
        if([port.path rangeOfString:portPath].location != NSNotFound){
            self.serialPort = port;
        }
    }
    
    if(!self.serialPort){
        NSLog(@"Failed to find port: %@\nThis is what is available:\n%@", portPath, [[ports valueForKeyPath:@"path"] componentsJoinedByString:@"\n"]);
        return;
    }
    
    self.serialPort.baudRate = @9600;
    self.serialPort.delegate = self;
    [self.serialPort open];
    NSLog(@"serial port opened: %@", self.serialPort.path);
}
- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if ([string length] == 0) return;
    printf("%s", string.UTF8String);
    
}
- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort
{
    NSLog(@"Serial port removed: %@", serialPort.path);
    if(serialPort == self.serialPort){
        [self.serialPort close];
    }
}
- (void)serialPortsWereConnected:(NSNotification *)notification
{
	NSArray *connectedPorts = [[notification userInfo] objectForKey:ORSConnectedSerialPortsKey];
	NSLog(@"Ports were connected: %@", connectedPorts);
    //try to reconnect
    [self performSelector:@selector(setupForPort:) withObject:self.serialPort.path afterDelay:2];
}


#pragma mark Notifications
- (void)setupNotifications
{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(serialPortsWereConnected:) name:ORSSerialPortsWereConnectedNotification object:nil];
    [nc addObserver:self selector:@selector(serialPortsWereDisconnected:) name:ORSSerialPortsWereDisconnectedNotification object:nil];
    
}


- (void)serialPortsWereDisconnected:(NSNotification *)notification
{
	NSArray *disconnectedPorts = [[notification userInfo] objectForKey:ORSDisconnectedSerialPortsKey];
	NSLog(@"Ports were disconnected: %@", disconnectedPorts);
	
}
@end
