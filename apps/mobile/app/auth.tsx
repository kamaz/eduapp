import { useEffect, useState } from 'react'
import { StyleSheet, TextInput, View, Pressable, ActivityIndicator } from 'react-native'
import { router } from 'expo-router'

import { ThemedText } from '@/components/themed-text'
import { ThemedView } from '@/components/themed-view'
import { mapAuthError } from '@/auth/auth-errors'
import { useAuth } from '@/auth/auth-provider'
import { validateEmail, validatePassword } from '@/auth/validators'

type Mode = 'signIn' | 'signUp'

export default function AuthModal() {
  const { signIn, signUp, user, initializing } = useAuth()
  const [mode, setMode] = useState<Mode>('signIn')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
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

  async function onSubmit() {
    const emailErr = validateEmail(email)
    const passErr = validatePassword(password)
    if (emailErr || passErr) {
      setError(emailErr || passErr)
      return
    }
    setSubmitting(true)
    setError(null)
    try {
      if (mode === 'signIn') {
        await signIn(email.trim(), password)
      } else {
        await signUp(email.trim(), password)
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
