//
//  OnboardView.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import SwiftUI

struct OnboardView: View {
	var body: some View {
		VStack {
			Text("Hello 👋")
				.font(.system(size: 36, weight: .bold, design: .serif))
				.padding(.bottom, 10
				)
			Text("Following permissions are required for PuntoSwitcher to work:")
				.font(.system(size: 18, weight: .bold, design: .serif))
			HStack {
				Text("⌨️")
					.font(.system(size: 70, weight: .bold, design: .default))
					.padding(.trailing, 15)
				Text("Input monitor")
					.font(.system(size: 24, weight: .bold, design: .default))
			}
			HStack {
				Text("♿️")
					.font(.system(size: 70, weight: .bold, design: .default))
					.padding(.trailing, 15)
				Text("Accessibility")
					.font(.system(size: 24, weight: .bold, design: .default))
			}
			Button("Go to settings") {
				NSApplication.shared.openPrivacySettings()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

#if DEBUG
struct OnboardView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardView()
	}
}
#endif
