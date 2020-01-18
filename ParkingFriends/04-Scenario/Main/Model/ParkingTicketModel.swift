//
//  ParkingTicketModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkingTicketModelType {
    var elements:BehaviorRelay<[WithinElement]> { get }
    var districts:BehaviorRelay<[WithinDistrictElement]> { get }
    
    
    var selectedSort : BehaviorRelay<SortType> { get set }
}


class ParkingTicketModel: ParkingTicketModelType {
    var elements: BehaviorRelay<[WithinElement]>
    var districts: BehaviorRelay<[WithinDistrictElement]>
    var selectedSort : BehaviorRelay<SortType>
    
    var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        elements = BehaviorRelay(value:[])
        districts = BehaviorRelay(value:[])
        selectedSort = BehaviorRelay(value:.distance)
    }
    
    /*
    private func updateParkinglot(coord:CoordType, district:Bool = false, search:Bool = false) {
        let option:FilterOption = UserData.shared.filter
        
        debugPrint("[RADIUS] ", radius)
        let time = UserData.shared.getReservableTime()
        let today = Date().toString(format: .custom("yyyyMMdd"))
        
        if district == true {
            self.withinDistrict(coordinate: coord, radius: radius)
                .subscribe(onNext: { elements in
                    self.updateMarker(districts: elements)
                    self.updateSubModel(district: true, within: nil)
                })
                .disposed(by: disposeBag)
        } else {
            self.within(coordinate:coord, radius: radius, filter:option.filter, month:(today, 1), time:(time.start, time.end))
                .subscribe(onNext: { elements in
                    self.updateMarker(lots: elements)
                    self.updateSubModel(district: false, within: elements, section: search ? (list:false, search:true) : nil)
                })
                .disposed(by: disposeBag)
        }
    }
 */
    
    private func within(coordinate:CoordType, radius:Double, filter:FilterType, month:(from:String, count:Int), time:(start:String, end:String)) -> Observable<[WithinElement]> {
        return ParkingLot.within(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius:radius.toString, start:time.start, end:time.end, productType:.time, monthlyFrom:month.from, monthlyCount:month.count, filter: filter)
            .asObservable()
            .map { (within, response) in
                return within?.elements ?? []
            }
    }
    
    private func withinDistrict(coordinate:CoordType, radius:Double) -> Observable<[WithinDistrictElement]> {
        return ParkingLot.within_district(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius: radius.toString)
            .asObservable()
            .map { (district, response) in
                return district?.elements ?? []
            }
    }
}
