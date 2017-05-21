//
//  MCWhisperWrapper.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Whisper

extension UINavigationController {

    func displayWhisperWithError(_ errorMessage: String) {
        let message = Message(title: errorMessage, backgroundColor: .red)
        Whisper.show(whisper: message, to: self)
    }

}

extension UIViewController {

    func displayWhistleMessage(_ message: String) {
        let murmur = Murmur(title: message)
        Whisper.show(whistle: murmur)
    }

}
