//
//  MCMovieListTableViewController.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

class MCMovieListTableViewController: UITableViewController {


    // MARK: Properties

    var movies: [Movie] = [] {
        didSet {
            if movies.isEmpty {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        }
    }

    var viewModel = MCMovieListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trending Movies"

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


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

        cell.setMovie(self.movies[indexPath.row])

        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
}
