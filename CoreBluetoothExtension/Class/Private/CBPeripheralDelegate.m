//
//  CBPeripheralDelegate.m
//  Pods
//
//  Created by 谈超 on 2018/6/13.
//

#import "CBPeripheralDelegate.h"
#import "CBPeripheral+Private.h"
#import "CBService+Private.h"
#import "CBCharacteristic+Private.h"
@implementation CBPeripheralDelegate

/*!
 *  @method peripheralDidUpdateName:
 *
 *  @param peripheral    The peripheral providing this update.
 *
 *  @discussion            This method is invoked when the @link name @/link of <i>peripheral</i> changes.
 */
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(10_9, 6_0){
    
}

/*!
 *  @method peripheral:didModifyServices:
 *
 *  @param peripheral            The peripheral providing this update.
 *  @param invalidatedServices    The services that have been invalidated
 *
 *  @discussion            This method is invoked when the @link services @/link of <i>peripheral</i> have been changed.
 *                        At this point, the designated <code>CBService</code> objects have been invalidated.
 *                        Services can be re-discovered via @link discoverServices: @/link.
 */
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices NS_AVAILABLE(10_9, 7_0){
    
}

/*!
 *  @method peripheral:didReadRSSI:error:
 *
 *  @param peripheral    The peripheral providing this update.
 *  @param RSSI            The current RSSI of the link.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion            This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(10_13, 8_0){
    
}

/*!
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral    The peripheral providing this information.
 *    @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion            This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *                        <i>peripheral</i>'s @link services @/link property.
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    for (CBService *ser in peripheral.services) {
        void(^discoveryClosure)(CBService *service) = [peripheral discoverServiceClosures][ser.UUID.UUIDString];
        if (discoveryClosure) {
            discoveryClosure(ser);
        }
    }
}

/*!
 *  @method peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param peripheral    The peripheral providing this information.
 *  @param service        The <code>CBService</code> object containing the included services.
 *    @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion            This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully,
 *                        they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error{
    
}

/*!
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral    The peripheral providing this information.
 *  @param service        The <code>CBService</code> object containing the characteristic(s).
 *    @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion            This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *                        they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics) {
        void(^discoveryClosure)(CBCharacteristic *service) = service.discoverCharacteristicClosures[characteristic.UUID.UUIDString];
        if (discoveryClosure) {
            discoveryClosure(characteristic);
        }
    }
}

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
   void (^notifyValueDidUpdate)(CBCharacteristic *, NSError *) = characteristic.notifyValueDidUpdate;
    if (notifyValueDidUpdate) {
        notifyValueDidUpdate(characteristic,error);
    }
}

/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    void (^sendMessageClosure)(BOOL) = characteristic.sendMessageClosure;
    if (sendMessageClosure) {
        sendMessageClosure(error == nil);
    }
}

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    void (^notifyClosure)(BOOL) = characteristic.notifyClosure;
    if (notifyClosure) {
        notifyClosure(characteristic.isNotifying);
    }
}

/*!
 *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
 *                            they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}

/*!
 *  @method peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param descriptor        A <code>CBDescriptor</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link readValueForDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}

/*!
 *  @method peripheral:didWriteValueForDescriptor:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param descriptor        A <code>CBDescriptor</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link writeValue:forDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}

/*!
 *  @method peripheralIsReadyToSendWriteWithoutResponse:
 *
 *  @param peripheral   The peripheral providing this update.
 *
 *  @discussion         This method is invoked after a failed call to @link writeValue:forCharacteristic:type: @/link, when <i>peripheral</i> is again
 *                      ready to send characteristic value updates.
 *
 */
- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral{
    
}

/*!
 *  @method peripheral:didOpenL2CAPChannel:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param channel            A <code>CBL2CAPChannel</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link openL2CAPChannel: @link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error API_AVAILABLE(ios(11.0)){
    
}



+(nonnull instancetype)sharedDelegate{
    static dispatch_once_t predicate;
    static id sharedObject;
    dispatch_once(&predicate, ^{
        sharedObject=[[self alloc] init];
    });
    return sharedObject;
}

@end
