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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
