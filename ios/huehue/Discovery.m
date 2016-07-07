//
//  Discovery.m
//  Proxi
//
//  Created by master on 7/6/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "Discovery.h"
#import "RCTBridge.h"
#import "RCTBridgeDelegate.h"
#import "RCTEventEmitter.h"

@implementation Discovery

RCT_EXPORT_MODULE();

- (instancetype)init {
  self = [super init];
  
  self.UUID = @"0xBABE";
  self.blueToothReady = false;
//  RCTBridge *brg = [self.bridge initWithDelegate:self launchOptions:nil];
//  self.bridge = brg;
  self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
  
  return self;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  
  NSURL *source = [NSURL URLWithString:@"http://10.188.201.120:8081/index.ios.bundle?platform=ios&dev=true"];
  return source;
}

- (NSArray<NSString *> *)supportedEvents {
  NSArray *arr = @[@"found"];
  return arr;
}

- (void)discoverDevices: (CBCentralManager *)central {
  
  NSLog(@"discovering devices");
  
  CBUUID *serviceUUID = [CBUUID UUIDWithString: self.UUID];
  
  [central scanForPeripheralsWithServices: @[serviceUUID] options: nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  
  switch (central.state) {
      
    case CBCentralManagerStateUnknown:
      NSLog(@"CoreBluetooth BLE hardware is powered off");
      break;
    case CBCentralManagerStatePoweredOn:
      NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
      
      self.blueToothReady = true;
      
      break;
    case CBCentralManagerStateResetting:
      NSLog(@"CoreBluetooth BLE hardware is reseting");
      break;
    case CBCentralManagerStatePoweredOff:
      NSLog(@"CoreBluetooth BLE hardware is powered off");
      break;
    case CBCentralManagerStateUnsupported:
      NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
      break;
    case CBCentralManagerStateUnauthorized:
      NSLog(@"CoreBluetooth BLE hardware is unauthorised");
      break;
  }
  
  if (self.blueToothReady == true) {
    [self discoverDevices: central];
  }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  
  NSLog(@"Found peripheral -> %@\nwith data -> %@\nwith RSSI -> %@", peripheral, advertisementData, RSSI);
  
  [self sendEventWithName:@"found" body:advertisementData];
}

@end