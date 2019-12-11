//
//  ParkingLot.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Common : HttpSession {
    
    // 차량 브랜드 조회 /v1/cars/brands
    static public func cars_brands() -> Observable<(Parkinglots?, ResponseCodeType)>  {
        let data = CommonAPI.cars_brands()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Parkinglots(JSON: result.data), result.codeType)
            })
    }
    
    // 차량 모델 조회 /v1/cars/brands/{brandId}/models
    static public func cars_brands_models(brandId:String) -> Observable<(CarBrands?, ResponseCodeType)>  {
        let data = CommonAPI.cars_brands_models(brandId: brandId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (CarBrands(JSON: result.data), result.codeType)
            })
       }
    
    // 차량 상세 모델 조회 /v1/cars/brands/{brandId}/models/{modelId}/trims
    static public func cars_brands_models_trim(brandId:String, modelId:String) -> Observable<(CarModels?, ResponseCodeType)>  {
        let data = CommonAPI.cars_brands_models_trims(brandId: brandId, modelId: modelId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (CarModels(JSON: result.data), result.codeType)
            })
    }
    
    // 약관 목록 조회 /v1/agreements
    static public func agreements() -> Observable<(Agreements?, ResponseCodeType)>  {
        let data = CommonAPI.agreements()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Agreements(JSON: result.data), result.codeType)
            })
    }
    
    // 주소 조회 /v1/address
    static public func address(keyword:String) -> Observable<(SearchAddress?, ResponseCodeType)>  {
        let data = CommonAPI.address(keyword: keyword)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (SearchAddress(JSON: result.data), result.codeType)
            })
    }
    
    // 주차장 공유 문의 /v1/parkinglots/inquiry
    static public func inquiry(postalCode:String, address:String, phoneNumber:String, comment:String, images:[UIImage]) -> Observable<ResponseCodeType>  {
        let data = CommonAPI.parkinglots_inquiry(postalCode:postalCode, address:address, phoneNumber:phoneNumber, comment:comment, images:images)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    // Parameters
    // 주차장 최신정보 제보 /v1/parkinglots/{id}/suggest
    static public func suggest(id:Int, type:String, comment:String) -> Observable<ResponseCodeType>  {
        let data = CommonAPI.parkinglots_suggest(id:id, type:type, comment:comment)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 주차장 발굴 요청 /v1/parkinglots/suggest-location
    static public func suggest(postalCode:String, address:String) -> Observable<ResponseCodeType>  {
        let data = CommonAPI.parkinglots_suggest_location(postalCode:postalCode, address:address)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 분류 목록 조회 (각종 유형 정보 조회)  /v1/contents/{type}
    static public func contents(type:ContentType) -> Observable<(Contents?, ResponseCodeType)>  {
        let data = CommonAPI.contents(type:type)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Contents(JSON: result.data), result.codeType)
            })
    }
    
    // 이용 후기 등록  /v1/parkinglots/{id}/reviews
    static public func reviews(id:Int, rating:Int, review:String) -> Observable<ResponseCodeType>  {
        let data = CommonAPI.parkinglots_reviews(id:id, rating:rating, review:review)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 이용 후기 목록 조회  /v1/parkinglots/{id}/reviews
    static public func reviews(id:Int) -> Observable<(Reviews?, ResponseCodeType)>  {
        let data = CommonAPI.parkinglots_reviews(id:id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Reviews(JSON: result.data),result.codeType)
            })
    }
    
    // 공지사항 목록 조회   /v1/notices
    static public func notices() -> Observable<(Notices?, ResponseCodeType)>  {
        let data = CommonAPI.notices()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Notices(JSON: result.data),result.codeType)
            })
    }
    
    //  공지사항 상세 조회  /v1/notices/{id}
     static public func notices(id:Int) -> Observable<(Notices?, ResponseCodeType)>  {
         let data = CommonAPI.notices(id:id)
         
         return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
             .map ({  result in
                 return (Notices(JSON: result.data),result.codeType)
             })
     }
    
    //  이벤트 목록 조회  /v1/events
    static public func events() -> Observable<(Events?, ResponseCodeType)>  {
        let data = CommonAPI.events()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Events(JSON: result.data),result.codeType)
            })
    }
    
    //  이벤트사항 상세 조회  /v1/events/{id}
    static public func events(id:Int) -> Observable<(EventsContents?, ResponseCodeType)>  {
        let data = CommonAPI.events(id:id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (EventsContents(JSON: result.data),result.codeType)
            })
    }
    
    //  FAQ 목록 조회   /v1/faqs
    static public func faqs(type:String) -> Observable<(FAQs?, ResponseCodeType)>  {
        let data = CommonAPI.faqs(type:type)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (FAQs(JSON: result.data),result.codeType)
            })
    }
    
    // FAQ 상세 조회  /v1/faqs/{id}
    static public func faqs(id:Int) -> Observable<(FAQsContents?, ResponseCodeType)>  {
        let data = CommonAPI.faqs(id:id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (FAQsContents(JSON: result.data),result.codeType)
            })
    }
}
