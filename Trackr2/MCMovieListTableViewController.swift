//
//  MCMovieListTableViewController.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

class MCMovieListTableViewController: UITableViewController {


    lazy var feedbackLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading... 🎬"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    // MARK: Properties

    var movies: [Movie] = [] {
        didSet {
            self.feedbackLabel.isHidden = !movies.isEmpty
        }
    }

    var viewModel = MCMovieListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trending Movies"

        self.view.addSubview(self.feedbackLabel)

        NSLayoutConstraint.activate([self.feedbackLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.feedbackLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     self.feedbackLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                                     self.feedbackLabel.heightAnchor.constraint(equalToConstant: 60)])

        viewModel.readMoviesFromDataLayer { (success, movies) in
            if success {
                self.movies = movies
                self.tableView.reloadData()
            } else {
                // Present an error
                self.displayWhistleMessage("Couldn't load movies")
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.movieCell, for: indexPath) else {
            fatalError("This tableView supports only MCMovieTableViewCell cells")
        }

        cell.setMovie(movie: self.movies[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == R.segue.mCMovieListTableViewController.detailsSegue.identifier {
            if let vc = segue.destination as? MCDetailsViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                vc.setMovie(self.movies[indexPath.row])
            }
        }

    }
}
