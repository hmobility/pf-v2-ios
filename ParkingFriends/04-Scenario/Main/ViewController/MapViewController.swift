//
//  MainViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap

extension MapViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] MainMap"
    }
}

class MapViewController: UIViewController {
    @IBOutlet var zoomInButton: UIButton!
    @IBOutlet var zoomOutButton: UIButton!
    @IBOutlet var placeCenterButton: UIButton!
    
    @IBOutlet var timeSelView: CustomTimeSelectionView!
    
    @IBOutlet weak var mapView:NMFMapView!
    
    let location = CLLocationManager()
    
    var disposeBag = DisposeBag()
    private lazy var viewModel: MapViewModelType = MapViewModel(view: mapView)
    
    private lazy var titleView = NavigationTitleView()
    
    // MARK: - Initialize
     
    init() {
      //  self.viewModel = MapViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       // viewModel = MapViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        // setupMapBindings()
        setupNavigation()
        buttonBindings()
        timeSelAreaBinding()
    }
    
    // MARK: - Bindings
    
    private func setupNavigation() {
        navigationItem.titleView = titleView
        
        titleView.titleColor = Color.darkGrey
        titleView.titleFont = Font.gothicNeoMedium26
        titleView.subTitleColor = Color.darkGrey
        titleView.subTitleFont = Font.helvetica12
    }
    
    
    private func setupMapBinding() {
 
    }
    
    private func buttonBindings() {
        zoomInButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.zoomIn()
            })
            .disposed(by: disposeBag)
                
        zoomOutButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.zoomOut()
            })
            .disposed(by: disposeBag)
        
        placeCenterButton.rx.tap
            .bind { _ in 
                self.viewModel.placeCenter()
            }
            .disposed(by: disposeBag)
    }
    
    private func timeSelAreaBinding() {
        timeSelView.tapSearchArea()
            .subscribe { _ in
                
            }
            .disposed(by: disposeBag)
            
        timeSelView.tapSelectTime()
            .subscribe { _ in
                    
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        titleView.set(title: "TTT", subTitle: "SSSs")
        
        location.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
