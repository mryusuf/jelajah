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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarBinding()
        setupCollectionViewBinding()
        setupLoadingObserver()
    }

    private func setupSearchBarBinding() {
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "sort"), for: .bookmark, state: .normal)
        
        searchBar
            .rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty && $0.count >= 3 }
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
    
    private func setupCollectionViewBinding() {
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResultCollectionViewCell")
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.businessItems
            .bind(to: collectionView.rx.items(cellIdentifier: "ResultCollectionViewCell", cellType: ResultCollectionViewCell.self)) { row, item, cell in
                cell.setItem(with: item)
            }
            .disposed(by: disposeBag)
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let cellWidth = (width - 36) / 2
        return CGSize(width: cellWidth, height: 350)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let alert = UIAlertController(
            title: "Sort by",
            message: "",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "Nearest Distance",
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel.sortItems(by: .distance)
        }))
        
        alert.addAction(UIAlertAction(
            title: "Greatest Rating",
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel.sortItems(by: .rating)
        }))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
            
        }))
        present(alert,
                animated: true,
                completion: nil
        )
    }
}

