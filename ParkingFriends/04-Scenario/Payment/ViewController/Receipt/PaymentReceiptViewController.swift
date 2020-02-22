//
//  PaymentReceiptViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import WebKit

class PaymentReceiptViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sharingButton: UIButton!
    
    private var viewModel:PaymentReceiptViewModelType = PaymentReceiptViewModel()

    private var urlString:String?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement) {
        viewModel.setOrderElement(with: element)
    }
    
    public func setUrl(with urlString:String) {
        self.urlString = urlString
    }

    // MARK: - Private Methods
    
    private func setupWebView() {
        if let url = urlString {
            loadWebUrl(url)
        }
    }
    
    private func loadWebUrl(_ urlString:String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.closeText
            .asDriver()
            .drive(closeButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.sharingText
              .asDriver()
              .drive(sharingButton.rx.title())
              .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.dismissModal()
            })
            .disposed(by: disposeBag)
        
        sharingButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
               
            })
            .disposed(by: disposeBag)
    }
    
    private func setupReceiptBinding() {
        viewModel.getReceipt()
            .map { $0.imageUrl}
            .subscribe(onNext: { [unowned self] url in
                self.loadWebUrl(url)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
        setupButtonBinding()
        setupWebView()
        setupReceiptBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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

extension PaymentReceiptViewController: WKUIDelegate, WKNavigationDelegate {
    
    // MARK: - WKUIDelegate
    
    // MARK: - WKNavigationDelegate
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
