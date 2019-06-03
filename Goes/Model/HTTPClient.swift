//
//  HTTPClient.swift
//  Goes
//
//  Created by Yenting Chen on 2019/6/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

enum Result<Success, Failure> where Failure : Error {
    
    case success(Success)
    
    case failure(Failure)
}

enum NetworkError: Error {

    case domainError
    case decoingError
}
