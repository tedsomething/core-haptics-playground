import SwiftUI
import CoreHaptics

enum HapticsMode {
    case haptics, audio
}

struct HapticSettings: Equatable {
    var hapticIntensity: Float = 0.5
    var hapticSharpness: Float = 0.5
    
    var audioVolume: Float = 0.5
    var audioPitch: Float = 0.0
    var audioPan: Float = 0.0
    var audioBrightness: Float = 0.5
    
    var attackTime: Float = 0.0
    var decayTime: Float = 0.0
    var releaseTime: Float = 0.5
    var sustained: Float = 0.5
}

class HapticsModelView: ObservableObject {
    @Published var hasHaptics: Bool = true
    @Published var hasAudio: Bool = false
    
    @Published var settings = HapticSettings()
    
    private var engine: CHHapticEngine?
    
    func startHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support Haptics.")

            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to start haptics engine: \(error.localizedDescription)")
            
            return
        }
    }
    
    func createHapticEvent() -> CHHapticEvent {
        var parameters: [CHHapticEventParameter] = []
        
        parameters.append(CHHapticEventParameter(parameterID: .hapticIntensity, value: settings.hapticIntensity))
        parameters.append(CHHapticEventParameter(parameterID: .hapticSharpness, value: settings.hapticSharpness))
        
        parameters.append(CHHapticEventParameter(parameterID: .attackTime, value: settings.attackTime))
        parameters.append(CHHapticEventParameter(parameterID: .decayTime, value: settings.decayTime))
        parameters.append(CHHapticEventParameter(parameterID: .releaseTime, value: settings.releaseTime))
        parameters.append(CHHapticEventParameter(parameterID: .sustained, value: settings.sustained))
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: parameters,
            relativeTime: 0
        )
        
        return event
    }
    
    func createAudioEvent() -> CHHapticEvent {
        var parameters: [CHHapticEventParameter] = []
        
        parameters.append(CHHapticEventParameter(parameterID: .audioVolume, value: settings.audioVolume))
        parameters.append(CHHapticEventParameter(parameterID: .audioPitch, value: settings.audioPan))
        parameters.append(CHHapticEventParameter(parameterID: .audioPitch, value: settings.audioPitch))
        parameters.append(CHHapticEventParameter(parameterID: .audioPitch, value: settings.audioBrightness))
        
        parameters.append(CHHapticEventParameter(parameterID: .attackTime, value: settings.attackTime))
        parameters.append(CHHapticEventParameter(parameterID: .decayTime, value: settings.decayTime))
        parameters.append(CHHapticEventParameter(parameterID: .releaseTime, value: settings.releaseTime))
        parameters.append(CHHapticEventParameter(parameterID: .sustained, value: settings.sustained))
        
        let event = CHHapticEvent(
            eventType: .audioContinuous,
            parameters: parameters,
            relativeTime: 0,
            duration: 0.1
        )
        
        return event
    }
    
    func createPattern() -> CHHapticPattern? {
        var events = [CHHapticEvent]()
                
        if hasHaptics {
            events.append(createHapticEvent())
        }
        
        if hasAudio {
            events.append(createAudioEvent())
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
           
            return pattern
        } catch {
            print("Failed to make a pattern: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func playPattern() {
        guard let engine = engine else {
            return
        }
        
        do {
            try engine.start()
        } catch {
            print("Failed to start haptics engine: \(error.localizedDescription)")
            return
        }
        
        guard let pattern = createPattern() else {
            return
        }
        
        do {
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
