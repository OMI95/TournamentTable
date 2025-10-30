//
//  UIView+Nib.swift
//  TournamentTable
//
//  Created by Muhammad Omer on 30/10/2025.
//

import UIKit

extension UIView {
    static func fromNib<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Failed to load \(nibName) from nib.")
        }
        return view
    }
}
