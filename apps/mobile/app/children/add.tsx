import React, { useMemo, useState } from 'react'
import { Alert, Platform, Pressable, StyleSheet, TextInput, View } from 'react-native'
import { router } from 'expo-router'
import DateTimePicker, { DateTimePickerEvent } from '@react-native-community/datetimepicker'
import { DateTimePickerAndroid } from '@react-native-community/datetimepicker'

import { ThemedText } from '@/components/themed-text'
import { ThemedView } from '@/components/themed-view'
import { useChildren } from '@/children/children-provider'

function formatYYYYMMDD(date: Date) {
  const y = date.getFullYear()
  const m = `${date.getMonth() + 1}`.padStart(2, '0')
  const d = `${date.getDate()}`.padStart(2, '0')
  return `${y}-${m}-${d}`
}

export default function AddChildScreen() {
  const { addChild } = useChildren()
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [showSurname, setShowSurname] = useState(false)
  const [dobDate, setDobDate] = useState<Date | null>(null)
  const [showIosPicker, setShowIosPicker] = useState(false)
  const [submitting, setSubmitting] = useState(false)

  const canSubmit = useMemo(
    () => firstName.trim().length > 0 && (!showSurname || lastName.trim().length > 0) && !!dobDate,
    [firstName, lastName, showSurname, dobDate],
  )

  async function onSubmit() {
    try {
      setSubmitting(true)
      await addChild({
        firstName,
        lastName: showSurname ? lastName : '',
        dob: formatYYYYMMDD(dobDate!),
      })
      router.back()
    } catch (e: any) {
      Alert.alert('Could not add child', e?.message ?? 'Please try again.')
    } finally {
      setSubmitting(false)
    }
  }

  function onPickDate() {
    const initial = dobDate ?? new Date()
    if (Platform.OS === 'android') {
      DateTimePickerAndroid.open({
        mode: 'date',
        value: initial,
        onChange: (_event: DateTimePickerEvent, date?: Date) => {
          if (date) setDobDate(date)
        },
      })
    } else {
      setShowIosPicker((v) => !v)
    }
  }

  return (
    <ThemedView style={styles.container}>
      <View style={styles.headerRow}>
        <ThemedText type="title">Add Child</ThemedText>
      </View>

      <View style={styles.form}>
        <View style={styles.field}>
          <ThemedText type="defaultSemiBold">First name</ThemedText>
          <TextInput
            value={firstName}
            onChangeText={setFirstName}
            placeholder="First name"
            autoCapitalize="words"
            style={styles.input}
          />
        </View>
        {!showSurname ? (
          <Pressable onPress={() => setShowSurname(true)} accessibilityRole="button">
            <ThemedText type="link">Add surname</ThemedText>
          </Pressable>
        ) : (
          <View style={styles.field}>
            <View style={styles.rowBetween}>
              <ThemedText type="defaultSemiBold">Surname</ThemedText>
              <Pressable onPress={() => setShowSurname(false)}>
                <ThemedText type="link">Remove</ThemedText>
              </Pressable>
            </View>
            <TextInput
              value={lastName}
              onChangeText={setLastName}
              placeholder="Surname"
              autoCapitalize="words"
              style={styles.input}
            />
          </View>
        )}

        <View style={styles.field}>
          <ThemedText type="defaultSemiBold">Date of birth</ThemedText>
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
      </View>

      <View style={styles.footer}>
        <Pressable
          disabled={!canSubmit || submitting}
          onPress={onSubmit}
          accessibilityRole="button"
          accessibilityLabel="Add child"
          style={[styles.addButton, (!canSubmit || submitting) && styles.addButtonDisabled]}
        >
          <ThemedText style={styles.addButtonText}>{submitting ? 'Adding…' : 'Add'}</ThemedText>
        </Pressable>
      </View>
    </ThemedView>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  form: { gap: 12 },
  field: { gap: 6 },
  rowBetween: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  input: {
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: '#e5e7eb',
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
  },
  iosPickerContainer: { marginTop: 8 },
  footer: { position: 'absolute', left: 16, right: 16, bottom: 24 },
  addButton: {
    backgroundColor: '#2563eb',
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
  },
  addButtonDisabled: { opacity: 0.6 },
  addButtonText: { color: '#fff', fontWeight: '600' },
})
