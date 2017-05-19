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
        }
    }

    func setMovie(movie: Movie) {
        self.movie = movie
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.coverImage.af_cancelImageRequest()
    }

}
