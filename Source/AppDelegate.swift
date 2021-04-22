//
//  AppDelegate.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	private var manager: SwitcherManager!
	private var statusItem: NSStatusItem!

	var window: NSWindow!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		initStatusBar()
		manager = SwitcherManager()
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		false
	}

	private func initStatusBar() {
		statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

		let icon = NSImage(named: "StatusBarIcon")
		icon?.size = CGSize(width: 18, height: 18)
		icon?.isTemplate = true
		statusItem.button?.image = icon

		let menu = NSMenu(title: "Menu")

		let enableToggle = NSMenuItem(
			title: "Enable autochange 🤖",
			action: #selector(enableToggleAction),
			keyEquivalent: "")
		enableToggle.state = SettingsHelper.shared.isSwitchEnable ? .on : .off
		menu.addItem(enableToggle)

		let manualItem = NSMenuItem(
			title: "Manual change selected text ✍️",
			action: #selector(manualItemAction),
			keyEquivalent: "A")
		manualItem.state = SettingsHelper.shared.isEnableHandlingManual ? .on : .off
		menu.addItem(manualItem)

		let soundEnableItem = NSMenuItem(
			title: "Sound enable 🎶",
			action: #selector(soundEnableAction),
			keyEquivalent: "")
		soundEnableItem.state = SettingsHelper.shared.isSoundEnable ? .on : .off
		menu.addItem(soundEnableItem)

		menu.addItem(NSMenuItem.separator())

		menu.addItem(
			withTitle: "Quit",
			action: #selector(NSApplication.terminate(_:)),
			keyEquivalent: "q")

		statusItem.menu = menu
	}

	@objc private func enableToggleAction(_ sender: NSMenuItem) {
		sender.toggle()
		SettingsHelper.shared.isSwitchEnable = sender.isOn
	}

	@objc private func manualItemAction(_ sender: NSMenuItem) {
		sender.toggle()
		SettingsHelper.shared.isEnableHandlingManual = sender.isOn
	}

	@objc private func soundEnableAction(_ sender: NSMenuItem) {
		sender.toggle()
		SettingsHelper.shared.isSoundEnable = sender.isOn
	}
}

