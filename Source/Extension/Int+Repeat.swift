//
//  Int+Repeat.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import Foundation

extension Int {
	func `repeat`(action: @escaping () -> Void) {
		guard self > 0 else { return }
		(0..<self).forEach { _ in action() }
	}
}
