import Constants from 'expo-constants'
import { getAuth, connectAuthEmulator } from '@react-native-firebase/auth'

// Configure Firebase runtime behaviors for development.
// - Connects Auth to local emulator when enabled in app.json (expo.extra.useEmulators)
export function configureFirebaseForDev() {
  const extra = (Constants?.expoConfig?.extra || {}) as any
  const useEmulators = !!extra?.useEmulators

  if (__DEV__ && useEmulators) {
    try {
      // React Native Firebase: connect to emulator
      // Note: Calling more than once throws; guard with try/catch.
      connectAuthEmulator(getAuth(), 'http://127.0.0.1:9099')
    } catch {
      // no-op if already configured
    }
  }
}
