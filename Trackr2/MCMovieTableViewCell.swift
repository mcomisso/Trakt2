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

            MCNetworkLayer.fetchImageForMovie(movie: movie, dimension: .small) { (success, url) in
                if let url = url as? URL {
                    self.coverImage.af_setImage(withURL: url)
                }
            }
        }
    }

    func setMovie(movie: Movie) {
        self.movie = movie
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.coverImage.image = nil
        self.movieTitle.text = nil
        self.coverImage.af_cancelImageRequest()
    }

}
