//
//  ColorDialogView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import SwiftMessages

class ColorDialogView: MessageView {
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var colorImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var cancelAction: (() -> Void)?
    var completionAction: ((_ item:ColorType) -> Void)?
    
    private let colorItems:[ColorType] = [.white, .black, .dark_gray, .silver, .blue, .red, .gold, .blue_green, .dark_green, .brown, .sky_blue]
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Button Action
    
    @IBAction func cancel() {
        cancelAction?()
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBinding()
        colorPicker.selectRow(0, inComponent: 0, animated: false)
        self.displaySelectedColor(ColorType.white)
        customPickerIndicator()
    }
    
    // MARK: - Public Methdos
    
    // Set default value as showing dialog
    public func selected(color:ColorType) {
        if let index = colorItems.firstIndex(of: color) {
            colorPicker.selectRow(index, inComponent: 0, animated: false)
            self.displaySelectedColor(color)
        }
    }
    
    // MARK: - Local Methods
    
    private func customPickerIndicator() {
        for i in [1, 2] {
            colorPicker.subviews[i].backgroundColor = Color.malangGreen
        }
    }
    
    private func displaySelectedColor(_ color:ColorType) {
        if let imageView = self.colorImageView {
            imageView.image = color.image
        }
    }
    
    // MARK: - Drawings
      
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initialize()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        Observable.just(colorItems)
            .bind(to: colorPicker.rx.items(adapter: ColorPickerViewAdapter()))
            .disposed(by: disposeBag)
        
        colorPicker.rx.itemSelected
            .asObservable()
            .subscribe(onNext: { row, item in
                let color = self.colorItems[row]
                self.displaySelectedColor(color)
                
                if let completion = self.completionAction {
                    completion(color)
                }
            })
            .disposed(by:disposeBag)
    }
}
