//
//  ViewController.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.postSearchQuery(with: "Delis")
    }


}

