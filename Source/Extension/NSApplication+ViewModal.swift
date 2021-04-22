//
//  NSApplication+ViewModal.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import SwiftUI

extension NSApplication {
	@discardableResult
	func runModal<T: View>(view: T, title: String?, rect: NSRect) -> NSApplication.ModalResponse {
		let window = NSWindow(
			contentRect: rect,
			styleMask: [.titled, .closable, .miniaturizable],
			backing: .buffered, defer: false)
		window.isReleasedWhenClosed = true
		window.center()
		window.setFrameAutosaveName("\(view)")
		title.flatMap { window.title = $0 }
		window.contentView = NSHostingView(rootView: view)
		defer { window.makeKeyAndOrderFront(nil) }
		return NSApplication.shared.runModal(for: window)
	}

	func openPrivacySettings() {
		URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")
			.flatMap { _ = NSWorkspace.shared.open($0) }
	}
}
