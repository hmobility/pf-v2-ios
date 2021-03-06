//
//  Order.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Order : HttpSession {
    static public func preview(type:ProductType, parkingLotId:Int, productId:Int, from:String, to:String, quantity:Int, ext:(extensionType:OrderExtensionType, originOrderId:Int, extensionMinutes:Int)? = nil) -> Observable<(OrderPreview?, ResponseCodeType)>  {
        let data = OrdersAPI.preview(type:type, parkingLotId:parkingLotId, productId:productId, from:from, to:to, quantity:quantity, ext:ext)
 
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (OrderPreview(JSON: result.data), result.codeType)
            })
    }

    static public func orders(itemId: Int, parkingItemType:ProductType, parkingLotId:Int, from: String, to: String, quantity: Int, paymentMethod: PaymentMethodType, usePoint: Int, totalAmount: Int, paymentAmount: Int, couponId: Int, giftFlag:Bool = false, car:(number: String, phoneNumber: String), ext:(extensionType:OrderExtensionType, originOrderId:Int, extensionMinutes:Int)?) -> Observable<(Transaction?, ResponseCodeType)>  {
        let data = OrdersAPI.orders(itemId: itemId, parkingItemType:parkingItemType, parkingLotId:parkingLotId, from: from, to: to, quantity: quantity, paymentMethod: paymentMethod.rawValue, usePoint: usePoint, totalAmount: totalAmount, paymentAmount: paymentAmount, couponId: couponId, giftFlag: giftFlag, car:(car.number, car.phoneNumber), ext:ext)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Transaction(JSON: result.data), result.codeType)
            })
    }
    
    static public func orders(page:Int, size:Int = 100, from:String, to:String, status:[OrderStatusType]) -> Observable<(Orders?, ResponseCodeType)>  {
        let data = OrdersAPI.orders(page: page, size: size, from: from, to: to, status: status)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Orders(JSON: result.data), result.codeType)
            })
    }
    
    static public func orders(id:Int) -> Observable<(Orders?, ResponseCodeType)>  {
        let data = OrdersAPI.orders(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Orders(JSON: result.data), result.codeType)
            })
    }
    
    static public func cancel_fee(id:Int) -> Observable<(CancelFee?, ResponseCodeType)>  {
        let data = OrdersAPI.cancel_fee(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path:data.url, parameters: data.params)
            .map ({  result in
                return (CancelFee(JSON: result.data), result.codeType)
            })
    }
    
    static public func delete_orders(id:Int) -> Observable<(CancelFee?, ResponseCodeType)>  {
        let data = OrdersAPI.delete_orders(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (CancelFee(JSON: result.data), result.codeType)
            })
    }
    
    static public func change_orders(id:Int, parkinglotId:Int) -> Observable<ResponseCodeType>  {
        let data = OrdersAPI.change_orders(id:id, parkinglotId:parkinglotId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func accuse(id:Int) -> Observable<ResponseCodeType>  {
        let data = OrdersAPI.accuse(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func over_fee(id:Int) -> Observable<(OverFee?, ResponseCodeType)>  {
        let data = OrdersAPI.over_fee(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (OverFee(JSON: result.data), result.codeType)
            })
    }
    
    static public func expend(id:Int, minutes:Int) -> Observable<ResponseCodeType>  {
        let data = OrdersAPI.expend(id: id, minutes: minutes)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func parkinglots_ble(bleId:String) -> Observable<ResponseCodeType>  {
        let data = OrdersAPI.parkinglots_ble(bleId: bleId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func mypage_usages(id:Int) -> Observable<(Usages?, ResponseCodeType)>  {
        let data = OrdersAPI.mypage_usages(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Usages(JSON: result.data), result.codeType)
            })
    }
    
    static public func recommend(id:Int) -> Observable<(Recommend?, ResponseCodeType)>  {
        let data = OrdersAPI.recommend(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Recommend(JSON: result.data), result.codeType)
            })
    }
    
    static public func gift(id:Int, phoneNumber:String, carNumber:String) -> Observable<ResponseCodeType>  {
        let data = OrdersAPI.gift(id: id, phoneNumber: phoneNumber, carNumber: carNumber)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func receipt(id:Int) -> Observable<(Receipt?, ResponseCodeType)>  {
        let data = OrdersAPI.receipt(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Receipt(JSON: result.data), result.codeType)
            })
    }
    
    static public func receipt_send(id:Int, sentType:ReceiptSendType, phoneNumber:String, email:String) -> Observable<ResponseCodeType>  {
        let data = OrdersAPI.receipt_send(id: id, sendType: sentType, phoneNumber: phoneNumber, email: email)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
}
