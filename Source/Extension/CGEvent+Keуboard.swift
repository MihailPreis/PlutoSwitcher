//
//  CGEvent+Keуboard.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import Foundation

extension CGEvent {
	func withFlags(_ flags: CGEventFlags?) -> Self {
		flags.flatMap { self.flags = $0 }
		return self
	}

	static func send(key: UInt16, flags: CGEventFlags? = nil) {
		let src = CGEventSource(stateID: .hidSystemState)
		CGEvent(keyboardEventSource: src, virtualKey: key, keyDown: true)?
			.withFlags(flags)
			.post(tap: .cgSessionEventTap)
		CGEvent(keyboardEventSource: src, virtualKey: key, keyDown: false)?
			.post(tap: .cgSessionEventTap)
	}
}

extension UInt16 {
	static let aKeyCode: UInt16 = 0x00
	static let cKeyCode: UInt16 = 0x08
	static let vKeyCode: UInt16 = 0x09
	static let leftArrowKeyCode: UInt16 = 0x7B
}
