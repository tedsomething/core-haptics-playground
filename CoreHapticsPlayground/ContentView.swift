import SwiftUI

struct ContentView: View {
    @StateObject private var hapticsModel = HapticsModelView()
    
    @State var hapticsExpaned = true
    @State var audioExpaned = true
    @State var otherExpaned = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Haptics", isExpanded: $hapticsExpaned, content: {
                    Toggle("Enabled", isOn: $hapticsModel.hasHaptics)
                        .padding(.vertical, 4)
                        .font(.headline)
                    
                    HapticItemView(title: "Intensity", value: $hapticsModel.settings.hapticIntensity, range: 0...1)
                        .disabled(!hapticsModel.hasHaptics)
                    
                    HapticItemView(title: "Sharpness", value: $hapticsModel.settings.hapticSharpness, range: 0...1)
                        .disabled(!hapticsModel.hasHaptics)
                })
                
                Section("Audio", isExpanded: $audioExpaned, content: {
                    Toggle("Enabled", isOn: $hapticsModel.hasAudio)
                        .font(.headline)
                        .padding(.vertical, 4)
                    
                    HapticItemView(title: "Volume", value: $hapticsModel.settings.audioVolume, range: 0...1)
                        .disabled(!hapticsModel.hasAudio)
                    
                    HapticItemView(title: "Pitch", value: $hapticsModel.settings.audioPitch, range: -1...1)
                        .disabled(!hapticsModel.hasAudio)
                    
                    HapticItemView(title: "Pan", value: $hapticsModel.settings.audioPan, range: -1...1)
                        .disabled(!hapticsModel.hasAudio)
                    
                    HapticItemView(title: "Brightness", value: $hapticsModel.settings.audioBrightness, range: 0...1)
                        .disabled(!hapticsModel.hasAudio)
                })
                            
                Section("Other", isExpanded: $otherExpaned, content: {
                    HapticItemView(title: "Attack time", value: $hapticsModel.settings.attackTime, range: -1...1)
                    
                    HapticItemView(title: "Decay time", value: $hapticsModel.settings.decayTime, range: -1...1)
                    
                    HapticItemView(title: "Release time", value: $hapticsModel.settings.releaseTime, range: 0...1)
                    
                    HapticItemView(title: "Sustained", value: $hapticsModel.settings.sustained, range: 0...1)
                })
            }
            .listStyle(.sidebar)
            .navigationTitle("Core Haptics Playground")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            hapticsModel.startHaptics()
        }
        .onReceive(
            hapticsModel.$settings.debounce(for: 0.05, scheduler: RunLoop.main)) {_ in
            hapticsModel.playPattern()
        }
    }
}

#Preview {
    ContentView()
}
