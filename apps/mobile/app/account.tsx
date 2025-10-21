import React, { useMemo } from 'react'
import { StyleSheet, View, Pressable, Alert } from 'react-native'
import { router } from 'expo-router'

import { ThemedText } from '@/components/themed-text'
import { ThemedView } from '@/components/themed-view'
import { useAuth } from '@/auth/auth-provider'

export default function AccountModal() {
  const { user, signOut } = useAuth()

  const { firstName, lastName, email } = useMemo(() => {
    const displayName = user?.displayName?.trim() ?? ''
    const [first, ...rest] = displayName.split(/\s+/).filter(Boolean)
    return {
      firstName: first ?? '',
      lastName: rest?.length ? rest.join(' ') : '',
      email: user?.email ?? '',
    }
  }, [user])

  async function handleSignOut() {
    try {
      await signOut()
      // After sign-out, the Protected routes will switch to auth.
      // Replace to root to ensure a clean stack.
      router.replace('/')
    } catch (e: any) {
      Alert.alert('Sign out failed', e?.message ?? 'Please try again.')
    }
  }

  return (
    <ThemedView style={styles.container}>
      <View style={styles.headerRow}>
        <ThemedText type="title">Account</ThemedText>
        <Pressable
          accessibilityRole="button"
          accessibilityLabel="Close"
          onPress={() => router.back()}
        >
          <ThemedText type="link">Done</ThemedText>
        </Pressable>
      </View>

      <View style={styles.section}>
        <ThemedText type="subtitle">Profile</ThemedText>
        <View style={styles.item}>
          <ThemedText type="defaultSemiBold">Name</ThemedText>
          <ThemedText>{[firstName, lastName].filter(Boolean).join(' ') || '—'}</ThemedText>
        </View>
        <View style={styles.item}>
          <ThemedText type="defaultSemiBold">Email</ThemedText>
          <ThemedText>{email || '—'}</ThemedText>
        </View>
      </View>

      <View style={styles.footer}>
        <Pressable
          onPress={handleSignOut}
          accessibilityRole="button"
          accessibilityLabel="Sign out"
          style={styles.signOutButton}
        >
          <ThemedText style={styles.signOutText}>Sign out</ThemedText>
        </Pressable>
      </View>
    </ThemedView>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 24,
    gap: 16,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  section: {
    gap: 8,
    paddingVertical: 8,
  },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 8,
  },
  footer: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  signOutButton: {
    backgroundColor: '#e11d48',
    paddingVertical: 12,
    borderRadius: 8,
    alignItems: 'center',
  },
  signOutText: {
    color: '#fff',
    fontWeight: '600',
  },
})
