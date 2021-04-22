//
//  CGEvent+Flags.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import AppKit

extension NSEvent.ModifierFlags {
	func `is`(_ flags: NSEvent.ModifierFlags) -> Bool {
		intersection(.deviceIndependentFlagsMask) == flags
	}
}
