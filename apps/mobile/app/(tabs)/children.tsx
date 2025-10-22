import React from 'react'
import { FlatList, Pressable, StyleSheet, View } from 'react-native'
import { router } from 'expo-router'

import AppHeader from '@/components/app-header'
import { ThemedText } from '@/components/themed-text'
import { ThemedView } from '@/components/themed-view'
import { useChildren } from '@/children/children-provider'

export default function ChildrenTab() {
  const { children } = useChildren()

  return (
    <ThemedView style={styles.container}>
      <AppHeader title="Children" />

      <FlatList
        data={children}
        keyExtractor={(item) => item.id}
        contentContainerStyle={children.length === 0 ? styles.emptyContainer : undefined}
        ListEmptyComponent={() => (
          <View style={styles.empty}>
            <ThemedText>No children added yet.</ThemedText>
          </View>
        )}
        renderItem={({ item }) => (
          <View style={styles.childCard}>
            <ThemedText type="defaultSemiBold">
              {`${item.firstName} ${item.lastName}`.trim()}
            </ThemedText>
            <ThemedText>DOB: {item.dob}</ThemedText>
          </View>
        )}
      />

      <View style={styles.footer}>
        <Pressable
          onPress={() => router.push('/children/add')}
          accessibilityRole="button"
          accessibilityLabel="Add child"
          style={styles.addButton}
        >
          <ThemedText style={styles.addButtonText}>Add</ThemedText>
        </Pressable>
      </View>
    </ThemedView>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  emptyContainer: { flexGrow: 1, justifyContent: 'center' },
  empty: { alignItems: 'center' },
  childCard: {
    padding: 12,
    borderRadius: 8,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: '#e5e7eb',
    marginBottom: 12,
  },
  footer: {
    position: 'absolute',
    left: 16,
    right: 16,
    bottom: 24,
  },
  addButton: {
    backgroundColor: '#2563eb',
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
  },
  addButtonText: { color: '#fff', fontWeight: '600' },
})
