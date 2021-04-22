//
//  SwitcherManager.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import SwiftUI
import AudioToolbox

private let kPurrSoundName = "Purr"

class SwitcherManager {
	private var eventMonitor: Any?
	private var controller: NSWindowController?
	private var timer: Timer?
	private var buffer: String = "" {
		didSet {
			timer?.invalidate()
			guard !buffer.isEmpty else { return }
			timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
				self.flatMap { $0.check($0.buffer) }
			}
		}
	}
	private lazy var pb: NSPasteboard = {
		let pb = NSPasteboard.general
		pb.declareTypes([.string], owner: nil)
		return pb
	}()

	var hasPermission: Bool {
		AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
	}

	init?() {
		guard hasPermission else {
			openPermissionAlert()
			return nil
		}
		eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
			guard let self = self else { return }
			guard
				SettingsHelper.shared.isSwitchEnable,
				event.modifierFlags.is([]) || event.modifierFlags.is(.shift),
				let chars = event.characters,
				!chars.isEmpty
			else {
				self.buffer.removeAll()
				if SettingsHelper.shared.isEnableHandlingManual, event.modifierFlags.is([.command, .shift]) {
					self.manualChange()
				}
				return
			}
			if event.keyCode == 51 {
				self.buffer = String(self.buffer.dropLast())
			} else {
				self.buffer += chars
			}
		}
	}

	deinit {
		timer?.invalidate()
		eventMonitor.flatMap { NSEvent.removeMonitor($0) }
	}

	func openPermissionAlert() {
		if SettingsHelper.shared.isFirstRun {
			let title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Onboard"
			NSApplication.shared.runModal(view: OnboardView(), title: title, rect: NSRect(x: 0, y: 0, width: 650, height: 350))
			SettingsHelper.shared.isFirstRun = false
		} else {
			let alert = NSAlert()
			alert.messageText = "Need permissions"
			alert.informativeText = "Following permissions are required for PuntoSwitcher to work:\n⌨️ Input monitor\n♿️ Accessibility"
			alert.alertStyle = .warning
			alert.addButton(withTitle: "Settings")
			alert.addButton(withTitle: "Exit")
			if alert.runModal() == .alertFirstButtonReturn {
				NSApplication.shared.openPrivacySettings()
			} else {
				NSApplication.shared.terminate(nil)
			}
		}
	}

	private func check(_ buffer: String) {
		guard let raw = buffer.split(separator: " ").last else { return }
		let str = String(raw)
		guard let ln = str.languageCode else { return }
		let rStr = str.translated(toRu: ln == Locale.enRaw)
		guard rStr.isReal && !str.isReal else { return }
		change(rStr)
	}

	private func manualChange() {
		CGEvent.send(key: .cKeyCode, flags: .maskCommand) // copy
		guard let str = pb.string(forType: .string) else { return }
		guard let ln = str.languageCode else { return }
		pb.clearContents()
		guard pb.setString(str.translated(toRu: ln == Locale.enRaw), forType: .string) else { return }
		CGEvent.send(key: .aKeyCode, flags: .maskCommand) // select all
		CGEvent.send(key: .vKeyCode, flags: .maskCommand) // paste
	}

	private func change(_ buffer: String) {
		let lastBuffer = pb.string(forType: .string)
		pb.clearContents()
		guard pb.setString(buffer, forType: .string) else { return }
		defer { lastBuffer.flatMap { _ = pb.setString($0, forType: .string) } }
		buffer.count.repeat { CGEvent.send(key: .leftArrowKeyCode, flags: .maskShift) } // Shift + ←
		CGEvent.send(key: .vKeyCode, flags: .maskCommand) // paste
		self.buffer.removeAll()
		playSound()
	}

	private func playSound() {
		guard SettingsHelper.shared.isSoundEnable else { return }
		NSSound(named: kPurrSoundName)?.play()
	}
}
