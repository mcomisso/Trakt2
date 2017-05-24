//
//  MCAPIProtocol.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

/// The Endpoint protocol adds a property to determine the current status of the host
protocol Endpoint: URLRequestConvertible {
    var isReachable: Bool { get }
}


/// The MCAPI Protocol requires to be implemented by API Classes. Shares some basic components like a SessionManager, properly configured to align all api requests and a request method
protocol MCAPI {
    var sessionManager: SessionManager { get }
    
    func request(endpoint: Endpoint) -> DataRequest
}
