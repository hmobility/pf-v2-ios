//
//  ParkinglotDetailHeaderView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/07.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ImageSlideshow
import MXParallaxHeader

class ParkinglotDetailHeaderView: UIView {
    @IBOutlet weak var imageSlideView: ImageSlideshow!
    @IBOutlet weak var dimmedImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var navigationButton: UIButton!
    
    var bookmarkAction: ((_ flag:Bool) -> Void)?
    var navigationAction: ((_ id:String) -> Void)?
    
    private lazy var viewModel: ParkinglotDetailHeaderViewModelType = ParkinglotDetailHeaderViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
      
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupImageView()
        setupImageBinding()
        setupFavoriteState()
    }
    
    private func setupContents() {
        setupPageControl()
        setupButtonBinding()
    }
    
    // MARK: - Public Methods
    
    public func getViewModel() -> ParkinglotDetailHeaderViewModel? {
        return (viewModel as! ParkinglotDetailHeaderViewModel)
    }

    public func setImageUrl(_ urls:[ImageElement]) {
        let sources = urls.map {
            return KingfisherSource(urlString: $0.url)
        }
        
        self.imageSlideView.setImageInputs(sources as! [InputSource])
    }
    
    public func setAlpha(_ value:CGFloat) {
        if dimmedImageView != nil {
            dimmedImageView.alpha = value
        }
    }
    
    // MARK: - Local Methods
    
    private func setupImageView() {
        imageSlideView.contentScaleMode = UIViewContentMode.scaleAspectFill
    }
    
    private func setupPageControl() {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.init(white: 1.0, alpha: 0.48)

        imageSlideView.pageIndicator = pageControl
        imageSlideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customTop(padding: 87))
    }
    
    // MARK: -  Binding
    
    private func setupImageBinding() {
        viewModel.imageList
            .asDriver()
            .drive(onNext: { images in
                if images.count > 0 {
                    self.setImageUrl(images)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFavoriteState() {
        viewModel.favoriteState.asDriver()
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        favoriteButton.rx.tap.asDriver()
            .map {
                return !self.favoriteButton.isSelected
            }
            .drive(onNext: { selected in
                self.viewModel.changeFavorite(selected)
            })
            .disposed(by: disposeBag)
        
        navigationButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                if let action = self.navigationAction {
                    action("text")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Drawings
      
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

    override func draw(_ rect: CGRect) {
        setupContents()
    }
}

// MARK: - Parallax header delegate

extension ParkinglotDetailHeaderView: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
        let alpha = (1 - parallaxHeader.progress / 1)
        NSLog("progress %f , alpha %f", parallaxHeader.progress, alpha)
        setAlpha(alpha)
    }
}
