//
//  PickerViewAdapter.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/14.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ColorPickerViewAdapter : NSObject, UIPickerViewDataSource, UIPickerViewDelegate, RxPickerViewDataSourceType {
    
    typealias Element = [ColorType]
    private var items: [ColorType] = []
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        super.init()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 54
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = localizer.localized(items[row].rawValue)
        label.textColor = Color.charcoalGrey2
        label.font = Font.gothicNeoMedium26
        label.textAlignment = .center
        return label
    }
    
    // MARK: - RxPickerViewDataSourceType Delegate
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
