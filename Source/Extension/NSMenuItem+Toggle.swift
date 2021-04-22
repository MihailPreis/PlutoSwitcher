//
//  NSMenuItem+Toggle.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import AppKit

extension NSMenuItem {
	var isOn: Bool { state == .on }

	func toggle() {
		state = isOn ? .off : .on
	}
}
