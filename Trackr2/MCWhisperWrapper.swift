//
//  MCWhisperWrapper.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

/*
    This class wraps around Whisper, a subtle notification UI.
    Using extensions on NavigationController and UIViewController it's easy to call a new message
 */

import Foundation
import Whisper

extension UINavigationController {


    /// Displays a Whisper (taller message below navigationBar)
    ///
    /// - Parameter errorMessage: The error message to be displayed
    func displayWhisperWithError(_ errorMessage: String) {
        let message = Message(title: errorMessage, backgroundColor: .red)
        Whisper.show(whisper: message, to: self)
    }
}

extension UIViewController {


    /// Displays a Whistle (small message on statusBar)
    ///
    /// - Parameter message: The message to be displayed
    func displayWhistleMessage(_ message: String) {
        let murmur = Murmur(title: message)
        Whisper.show(whistle: murmur)
    }
}
