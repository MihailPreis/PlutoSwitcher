//
//  SettingsHelper.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import Foundation

class SettingsHelper {
	private let switchEnableKey = "SWITCH_ENABLE"
	private let enableHandlingManualKey = "HANDLING_MANUAL_SHORTCUT"
	private let soundEnableKey = "SOUND_ENABLE"
	private let firstRunKey = "FIRST_RUN"

	static let shared = SettingsHelper()

	private let store = UserDefaults.standard

	var isSwitchEnable: Bool {
		get { store.object(forKey: switchEnableKey) as? Bool ?? false }
		set { store.set(newValue, forKey: switchEnableKey) }
	}

	var isEnableHandlingManual: Bool {
		get { store.object(forKey: enableHandlingManualKey) as? Bool ?? true }
		set { store.set(newValue, forKey: enableHandlingManualKey) }
	}

	var isSoundEnable: Bool {
		get { store.object(forKey: soundEnableKey) as? Bool ?? true }
		set { store.set(newValue, forKey: soundEnableKey) }
	}

	var isFirstRun: Bool {
		get { store.bool(forKey: firstRunKey) }
		set { store.set(newValue, forKey: firstRunKey) }
	}
}
