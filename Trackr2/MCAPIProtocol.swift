//
//  MCAPIProtocol.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

typealias Endpoint = URLRequestConvertible

protocol MCAPI {

    var sessionManager: SessionManager { get }

    func request(endpoint: Endpoint) -> DataRequest
}
