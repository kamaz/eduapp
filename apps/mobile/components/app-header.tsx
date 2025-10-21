import React from 'react'
import { View, StyleSheet, Pressable } from 'react-native'
import { Ionicons } from '@expo/vector-icons'
import { useRouter } from 'expo-router'

import { ThemedText } from '@/components/themed-text'
import { useThemeColor } from '@/hooks/use-theme-color'

type AppHeaderProps = {
  title: string
}

export function AppHeader({ title }: AppHeaderProps) {
  const router = useRouter()
  const textColor = useThemeColor({}, 'text')

  return (
    <View style={styles.container}>
      <ThemedText type="title" style={styles.title}>
        {title}
      </ThemedText>
      <Pressable
        accessibilityRole="button"
        accessibilityLabel="Open account"
        onPress={() => router.push('/account')}
        hitSlop={8}
        style={styles.iconButton}
      >
        <Ionicons name="person-circle" size={28} color={textColor} />
      </Pressable>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  title: {
    flexShrink: 1,
  },
  iconButton: {
    padding: 4,
    borderRadius: 16,
  },
})

export default AppHeader
