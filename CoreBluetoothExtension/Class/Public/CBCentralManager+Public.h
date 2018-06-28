//
//  CBCentralManager+Public.h
//  Pods
//
//  Created by 谈超 on 2018/6/8.
//


@import CoreBluetooth;
@interface CBCentralManager (Public)
// new一个蓝牙中心
+ (nonnull instancetype)newCentral NS_SWIFT_NAME(newCentral());

/*!
 *  @method scanForPeripheralsWithServices:options:duration:responseBlock:complete:
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service(s) to scan for.
 *  @param options      An optional dictionary specifying options for the scan.
 *  @param duration     a duration for timeout
 *  @param responseBlock a closure for scan operation block
 *  @param complete a closure for scan complete block
 *
 *  @discussion         Starts scanning for peripherals that are advertising any of the services listed in <i>serviceUUIDs</i>. Although strongly discouraged,
 *                      if <i>serviceUUIDs</i> is <i>nil</i> all discovered peripherals will be returned. If the central is already scanning with different
 *                      <i>serviceUUIDs</i> or <i>options</i>, the provided parameters will replace them.
 *                      Applications that have specified the <code>bluetooth-central</code> background mode are allowed to scan while backgrounded, with two
 *                      caveats: the scan must specify one or more service types in <i>serviceUUIDs</i>, and the <code>CBCentralManagerScanOptionAllowDuplicatesKey</code>
 *                      scan option will be ignored.
 *
 *  @seealso            CBCentralManagerScanOptionAllowDuplicatesKey
 *    @seealso            CBCentralManagerScanOptionSolicitedServiceUUIDsKey
 *
 */
- (nonnull CBCentralManager *)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs
                                                     options:(nullable NSDictionary<NSString *,id> *)options
                                                    duration:(NSTimeInterval)duration
                                               responseBlock:(void (^)(CBPeripheral *, NSDictionary<NSString *,id> *, NSNumber *, NSError *))responseBlock
                                                    complete:(void (^)(void))complete;
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
@end
