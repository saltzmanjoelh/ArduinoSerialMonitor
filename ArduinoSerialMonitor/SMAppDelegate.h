//
//  SMAppDelegate.h
//  UnoIno
//
//  Created by Joel Saltzman on 4/15/13.
//  Copyright (c) 2013 joelsaltzman.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "ORSSerialPort.h"
#import "ORSSerialPortManager.h"

@interface SMAppDelegate : NSObject <NSApplicationDelegate, ORSSerialPortDelegate, NSUserNotificationCenterDelegate>
//------------------------------------------
#pragma mark Properties
//------------------------------------------
@property (strong) NSFileHandle *inHandle;
@property (strong) ORSSerialPort *serialPort;
//------------------------------------------
#pragma mark Methods
//------------------------------------------

- (void)setupForInput;
- (void)inputAvailable;
- (void)setupForPort:(NSString *)portPath;

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data;
- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort;


@end
