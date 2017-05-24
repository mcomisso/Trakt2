//
//  MCDetailsViewController.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import TMDBSwift

final class MCDetailsViewController: UIViewController {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!

    @IBOutlet weak var vibrancyEffect: UIVisualEffectView!

    lazy var detailsTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var backgroundImageView: UIImageView! = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var blurEffectView: UIVisualEffectView! = {
        let visualEffect = UIBlurEffect(style: .light)
        let ev = UIVisualEffectView(effect: visualEffect)

        ev.translatesAutoresizingMaskIntoConstraints = false
        return ev
    }()

    lazy var vibrancyEffectView: UIVisualEffectView! = { [weak self] in
        guard let strongSelf = self,
        let blurEffect = self?.blurEffectView.effect as? UIBlurEffect else { fatalError() }

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)

        let ve = UIVisualEffectView(effect: vibrancyEffect)

        ve.translatesAutoresizingMaskIntoConstraints = false
        return ve
    }()

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Effect view
        self.view.insertSubview(self.blurEffectView, at: 0)
        self.view.insertSubview(self.backgroundImageView, at: 0)

        NSLayoutConstraint.activate([self.backgroundImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                                     self.backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                                     self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                                     ])

        NSLayoutConstraint.activate([self.blurEffectView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                                     self.blurEffectView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                                     self.blurEffectView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.blurEffectView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])

        self.vibrancyEffectView.contentView.addSubview(self.detailsTextLabel)
        self.blurEffectView.contentView.addSubview(self.vibrancyEffectView)

        NSLayoutConstraint.activate([self.detailsTextLabel.widthAnchor.constraint(equalTo: self.vibrancyEffectView.widthAnchor),
                                     self.detailsTextLabel.heightAnchor.constraint(equalTo: self.vibrancyEffectView.heightAnchor),
                                     self.detailsTextLabel.centerXAnchor.constraint(equalTo: self.vibrancyEffectView.centerXAnchor),
                                     self.detailsTextLabel.centerYAnchor.constraint(equalTo: self.vibrancyEffectView.centerYAnchor)])

        NSLayoutConstraint.activate([self.vibrancyEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     self.vibrancyEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     self.vibrancyEffectView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
                                     self.vibrancyEffectView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)])
    }

    func setMovie(_ movie: Movie) {
        self.movie = movie

        MCNetworkLayer.fetchDetailsForMovie(movie: self.movie) { [weak self] (success, result) in
            if success {
                if let details = result as? MovieDetailedMDB,
                    let conf = UserDefaults.standard.read(structType: ConfigurationMDB.self) as? ConfigurationMDB {
                    self?.titleLabel.text = details.title

                    // Set image

                    if let poster = details.poster_path {
                        let url = conf.generatePosterUrl(secure: true).appendingPathComponent(poster)

                        UIView.animate(withDuration: 0.4, animations: { 
                            self?.coverImage.af_setImage(withURL: url)
                            self?.backgroundImageView.af_setImage(withURL: url)
                        })
                    }

                    self?.taglineLabel.text = details.tagline

                    // Set genres

                    var descriptionString: String = ""
                    descriptionString.append(details.genres.map { $0.name }.reduce("\nGenres: ", { $1 != nil ? $0 + " " + $1! : $0 }))

                    let flatVars: [String] = Mirror(reflecting: details).children.flatMap {

                        if let label = $0.label,
                            let value = $0.value as? String {
                            return "\n\(String(describing: label)): \(value)"
                        }
                        return nil
                        }

                    flatVars.forEach { descriptionString.append($0) }

                    self?.detailsTextLabel.text = descriptionString
                }
            } else {
                if let error = result as? String {
                    self?.displayWhistleMessage(error)
                }
            }
        }



    }

    

}
