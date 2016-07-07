//
//  Discovery.m
//  Proxi
//
//  Created by master on 7/6/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "Discovery.h"
#import "RCTEventEmitter.h"

@implementation Discovery

RCT_EXPORT_MODULE()

- (instancetype)init {
  
  self = [super init];
  
  if (self != nil) {
    self.UUID = @"0xBABE";
    self.blueToothReady = false;
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
  }
  
  return self;
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

- (void)startObserving {
  NSLog(@"started observing");
}

- (void)stopObserving {
  NSLog(@"stopped observing");
}

RCT_EXPORT_METHOD(hallo:(NSString *)message)
{
  NSLog(@"%@", message);
}

@end