//
//  MCMovieTableListViewModel.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation


// ViewModel
final class MCMovieListViewModel {

    let dataLayer = MCDataLayer()

    func readMoviesFromDataLayer(completion: @escaping MovieCompletion) {
        dataLayer.listMovies(completion: completion)
    }

}
