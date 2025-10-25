import { useEffect, useMemo, useState } from 'react'
import { StyleSheet, TextInput, View, Pressable, ActivityIndicator, Platform } from 'react-native'
import { router } from 'expo-router'
import { getAuth } from '@react-native-firebase/auth'
import DateTimePicker, {
  DateTimePickerEvent,
  DateTimePickerAndroid,
} from '@react-native-community/datetimepicker'

import { ThemedText } from '@/components/themed-text'
import { ThemedView } from '@/components/themed-view'
import { mapAuthError } from '@/auth/auth-errors'
import { useAuth } from '@/auth/auth-provider'
import { validateEmail, validatePassword } from '@/auth/validators'
import { useProfile } from '@/profile/profile-provider'

type Mode = 'signIn' | 'signUp'
const MIN_REGISTRATION_AGE_YEARS = 11

function formatYYYYMMDD(date: Date) {
  const y = date.getFullYear()
  const m = `${date.getMonth() + 1}`.padStart(2, '0')
  const d = `${date.getDate()}`.padStart(2, '0')
  return `${y}-${m}-${d}`
}

async function mockSendProfileToBackend(payload: {
  uid: string
  firstName: string
  lastName: string
  phone: string
  dob: string
}) {
  // Simulate 1s network request
  await new Promise((res) => setTimeout(res, 1000))
  return { ok: true }
}

export default function AuthModal() {
  const { signIn, signUp, user, initializing } = useAuth()
  const { setProfile } = useProfile()
  const [mode, setMode] = useState<Mode>('signIn')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  // Registration extra fields
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [phone, setPhone] = useState('')
  const [dobDate, setDobDate] = useState<Date | null>(null)
  const [showIosPicker, setShowIosPicker] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!initializing && user) {
      router.replace('/(tabs)')
    }
  }, [initializing, user])

  if (initializing || user) {
    return (
      <ThemedView style={styles.loadingContainer}>
        <ActivityIndicator size="large" />
      </ThemedView>
    )
  }

  const ageValid = () => {
    if (!dobDate) return false
    const today = new Date()
    let age = today.getFullYear() - dobDate.getFullYear()
    const m = today.getMonth() - dobDate.getMonth()
    if (m < 0 || (m === 0 && today.getDate() < dobDate.getDate())) age--
    return age >= MIN_REGISTRATION_AGE_YEARS
  }

  function onPickDate() {
    const initial = dobDate ?? new Date()
    if (Platform.OS === 'android') {
      DateTimePickerAndroid.open({
        mode: 'date',
        value: initial,
        onChange: (_e: DateTimePickerEvent, date?: Date) => {
          if (date) setDobDate(date)
        },
      })
    } else {
      setShowIosPicker((v) => !v)
    }
  }

  async function onSubmit() {
    const emailErr = validateEmail(email)
    const passErr = validatePassword(password)
    if (emailErr || passErr) {
      setError(emailErr || passErr)
      return
    }
    if (mode === 'signUp') {
      if (!firstName.trim() || !lastName.trim() || !phone.trim()) {
        setError('Please complete all fields.')
        return
      }
      if (!dobDate) {
        setError('Please select your date of birth.')
        return
      }
      if (!ageValid) {
        setError(`You must be at least ${MIN_REGISTRATION_AGE_YEARS} years old.`)
        return
      }
    }
    setSubmitting(true)
    setError(null)
    try {
      if (mode === 'signIn') {
        await signIn(email.trim(), password)
      } else {
        await signUp(email.trim(), password)
        const u = getAuth().currentUser
        if (u) {
          await u.updateProfile({ displayName: `${firstName.trim()} ${lastName.trim()}`.trim() })
          await mockSendProfileToBackend({
            uid: u.uid,
            firstName: firstName.trim(),
            lastName: lastName.trim(),
            phone: phone.trim(),
            dob: formatYYYYMMDD(dobDate!),
          })
          setProfile({
            firstName: firstName.trim(),
            lastName: lastName.trim(),
            phone: phone.trim(),
            dob: formatYYYYMMDD(dobDate!),
          })
        }
      }
    } catch (e) {
      setError(mapAuthError(e))
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <ThemedView style={styles.container}>
      <ThemedText type="title" style={styles.title} testID="auth-title">
        {mode === 'signIn' ? 'Sign in' : 'Create account'}
      </ThemedText>

      {error ? (
        <ThemedText type="error" style={styles.error} testID="auth-error">
          {error}
        </ThemedText>
      ) : null}

      <View style={styles.field}>
        <ThemedText>Email</ThemedText>
        <TextInput
          style={styles.input}
          autoCapitalize="none"
          autoComplete="email"
          keyboardType="email-address"
          placeholder="you@example.com"
          value={email}
          onChangeText={setEmail}
          editable={!submitting}
          testID="auth-email"
        />
      </View>

      <View style={styles.field}>
        <ThemedText>Password</ThemedText>
        <TextInput
          style={styles.input}
          secureTextEntry
          placeholder="••••••••"
          value={password}
          onChangeText={setPassword}
          editable={!submitting}
          testID="auth-password"
        />
      </View>

      {mode === 'signUp' && (
        <>
          <View style={styles.field}>
            <ThemedText>First name</ThemedText>
            <TextInput
              style={styles.input}
              autoCapitalize="words"
              placeholder="First name"
              value={firstName}
              onChangeText={setFirstName}
              editable={!submitting}
            />
          </View>
          <View style={styles.field}>
            <ThemedText>Last name</ThemedText>
            <TextInput
              style={styles.input}
              autoCapitalize="words"
              placeholder="Last name"
              value={lastName}
              onChangeText={setLastName}
              editable={!submitting}
            />
          </View>
          <View style={styles.field}>
            <ThemedText>Phone</ThemedText>
            <TextInput
              style={styles.input}
              keyboardType="phone-pad"
              placeholder="Phone number"
              value={phone}
              onChangeText={setPhone}
              editable={!submitting}
            />
          </View>
          <View style={styles.field}>
            <ThemedText>Date of birth</ThemedText>
            <Pressable onPress={onPickDate} style={styles.input} accessibilityRole="button">
              <ThemedText>{dobDate ? formatYYYYMMDD(dobDate) : 'Select date'}</ThemedText>
            </Pressable>
            {Platform.OS === 'ios' && showIosPicker && (
              <View style={styles.iosPickerContainer}>
                <DateTimePicker
                  mode="date"
                  display="inline"
                  value={dobDate ?? new Date()}
                  onChange={(_e, date) => {
                    if (date) setDobDate(date)
                  }}
                />
              </View>
            )}
          </View>
        </>
      )}

      <Pressable
        disabled={submitting}
        onPress={onSubmit}
        accessibilityRole="button"
        testID="auth-submit"
        style={({ pressed }) => [
          styles.button,
          pressed && styles.buttonPressed,
          submitting && styles.buttonDisabled,
        ]}
      >
        {submitting ? (
          <ActivityIndicator color="#fff" />
        ) : (
          <ThemedText style={styles.buttonText}>
            {mode === 'signIn' ? 'Sign in' : 'Create account'}
          </ThemedText>
        )}
      </Pressable>

      <Pressable
        disabled={submitting}
        onPress={() => setMode((m) => (m === 'signIn' ? 'signUp' : 'signIn'))}
        accessibilityRole="button"
        testID="auth-toggle"
        style={({ pressed }) => [styles.link, pressed && styles.linkPressed]}
      >
        <ThemedText type="link">
          {mode === 'signIn' ? "Don't have an account? Create one" : 'Have an account? Sign in'}
        </ThemedText>
      </Pressable>
    </ThemedView>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    gap: 16,
    padding: 20,
    justifyContent: 'center',
  },
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    textAlign: 'center',
    marginBottom: 8,
  },
  field: {
    gap: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 16,
    backgroundColor: 'white',
  },
  iosPickerContainer: { marginTop: 8 },
  button: {
    backgroundColor: '#1e88e5',
    paddingVertical: 12,
    borderRadius: 8,
    alignItems: 'center',
  },
  buttonPressed: {
    opacity: 0.9,
  },
  buttonDisabled: {
    opacity: 0.7,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
  link: {
    alignItems: 'center',
    paddingVertical: 8,
  },
  linkPressed: {
    opacity: 0.7,
  },
  error: {
    color: '#d32f2f',
    textAlign: 'center',
  },
})
