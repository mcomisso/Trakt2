//
//  MCDetailsViewController.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

final class MCDetailsViewController: UIViewController {

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setMovie(_ movie: Movie) {
        self.movie = movie
    }

    

}
