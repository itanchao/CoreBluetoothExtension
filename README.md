# CoreBluetoothExtension

[![CI Status](https://img.shields.io/travis/itanchao/CoreBluetoothExtension.svg?style=flat)](https://travis-ci.org/itanchao/CoreBluetoothExtension)
[![Version](https://img.shields.io/cocoapods/v/CoreBluetoothExtension.svg?style=flat)](https://cocoapods.org/pods/CoreBluetoothExtension)
[![License](https://img.shields.io/cocoapods/l/CoreBluetoothExtension.svg?style=flat)](https://cocoapods.org/pods/CoreBluetoothExtension)
[![Platform](https://img.shields.io/cocoapods/p/CoreBluetoothExtension.svg?style=flat)](https://cocoapods.org/pods/CoreBluetoothExtension)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## CBCentralManager API

~~~objective-c
// new一个蓝牙中心
+ (nonnull instancetype)newCentral NS_SWIFT_NAME(newCentral());

/**
 扫描附近蓝牙外设
 
 @param duration 扫描时间
 @param responseBlock 扫描回调
 @param complete 结束回调
 @return 蓝牙中心
 */
- (nonnull CBCentralManager *)scanForPeripheralsWithDuration:(NSTimeInterval) duration
                                       responseBlock:(void(^)(CBPeripheral *peripheral,NSDictionary<NSString *, id> * advertisementData,NSNumber *RSSI,NSError *error))responseBlock complete:(void(^)(void))complete;

/*!
 *  @method connectPeripheral:options:
 *
 *  @param peripheral   The <code>CBPeripheral</code> to be connected.
 *  @param options      An optional dictionary specifying connection behavior options.
 *  @param complete     A block called when connect action done
 *
 *  @discussion         Initiates a connection to <i>peripheral</i>. Connection attempts never time out and, depending on the outcome, will result
 *                      in a call to either {@link centralManager:didConnectPeripheral:} or {@link centralManager:didFailToConnectPeripheral:error:}.
 *                      Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link cancelPeripheralConnection}.
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *,id> *)options duration:(NSTimeInterval)duration complete:(void(^)(CBPeripheral *peripheral,NSError *error))complete;
/*!
 *  @method cancelPeripheralConnection: resulte:
 *
 *  @param peripheral   A <code>CBPeripheral</code>.
 *  @param result       A <code>resultBlock</code>
 *
 *  @discussion         Cancels an active or pending connection to <i>peripheral</i>. Note that this is non-blocking, and any <code>CBPeripheral</code>
 *                      commands that are still pending to <i>peripheral</i> may or may not complete.
 *
 *
 */
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral resulte:(void(^)(CBPeripheral *peripheral,NSError *error))result;
~~~

## CBPeripheral  API

```objective-c
/**
 取消连接

 @param result 回调
 */
- (void)disConnectionWithResulte:(void(^)(CBPeripheral *peripheral,NSError *error))result;

/*!
 *  @method discoverServices:duration:complete:
 *  @param serviceUUID A CBUUID of <code>CBUUID</code> object representing the service types to be discovered. If <i>nil</i>,
 *                        None services will be discovered
 *  @param duration timeOut
 *  @discussion            Discovers available service(s) on the peripheral by UUID.
 *  @see complete completeBlock service is nullable
 *  @return CBPeripheral
 */
- (instancetype)disCovery:(CBUUID *)serviceUUID
                 duration:(NSTimeInterval)duration
                 complete:(void(^)(CBService *service))complete;
```

## CBService API

```objective-c
- (instancetype)disCovery:(CBUUID *)characteristicUUID
                 duration:(NSTimeInterval)duration
                 complete:(void(^)(CBCharacteristic *service))complete;
```

## CBCharacteristic API

~~~objective-c

/**
 订阅

 @param sucess 订阅回调
 @return CBCharacteristic
 */
- (instancetype)notify:(void(^)(BOOL sucess))sucess;

/**
 发送

 @param message 消息
 @param duration 耗时
 @param retryTimes 重试
 @param sucess 回调
 @return CBCharacteristic
 */
- (instancetype)sendMessage:(NSData *)message duration:(NSTimeInterval)duration retryTimes:(NSInteger)retryTimes result:(void (^)(BOOL))sucess;

/**
 监听外设返回消息

 @param valueDidUpdateBlock 回调闭包
 @return CBCharacteristic
 */
- (instancetype)notifyValueDidUpdate:(void(^)(CBCharacteristic *characteristic,NSError * error)) valueDidUpdateBlock;
~~~



## Requirements

## Installation

CoreBluetoothExtension is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoreBluetoothExtension'
```

## Author

itanchao, tanchao@mobike.com

## License

CoreBluetoothExtension is available under the MIT license. See the LICENSE file for more info.
