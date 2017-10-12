//
//  Collection.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/10/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
