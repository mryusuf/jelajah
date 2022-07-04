//
//  ViewController.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarBinding()
        setupLoadingObserver()
    }

    private func setupSearchBarBinding() {
        searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(
                onNext: { [unowned self] query in
                    self.viewModel.postSearchQuery(with: query)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setupLoadingObserver() {
        viewModel.isLoading
            .subscribe (
                onNext: { [unowned self] isLoading in
                    isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = !isLoading
                }
            )
            .disposed(by: disposeBag)
        
    }

}

