//
//  MCMovieTableViewCell.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import AlamofireImage

class MCMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!

    var movie: Movie! {
        didSet {
            self.movieTitle.text = movie.title
            self.loadCover()
        }
    }

    func setMovie(_ movie: Movie) {
        self.movie = movie
    }


    func loadCover() {
        // Request the load of the current cover
        MCtmdbAPI().request(endpoint: tmdbEndpoints.movie(id: String(self.movie.tmdb))).response { (response) in
            if let error = response.error {
                print(error)
            }

            if let data = response.data {
                print(data)
            }
        }
    }

    func stopLoadingCover() {
        // Stops the load of the current cover

        self.coverImage.af_cancelImageRequest()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.stopLoadingCover()
    }

}
