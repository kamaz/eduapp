import React, { createContext, useCallback, useContext, useMemo, useState } from 'react'

export type UserProfile = {
  firstName: string
  lastName: string
  phone: string
  dob: string // YYYY-MM-DD
}

type ProfileContextValue = {
  profile: UserProfile | null
  setProfile: (p: UserProfile) => void
  clearProfile: () => void
}

const ProfileContext = createContext<ProfileContextValue | undefined>(undefined)

export function ProfileProvider({ children }: { children: React.ReactNode }) {
  const [profile, setProfileState] = useState<UserProfile | null>(null)

  const setProfile = useCallback((p: UserProfile) => setProfileState(p), [])
  const clearProfile = useCallback(() => setProfileState(null), [])

  const value = useMemo<ProfileContextValue>(
    () => ({ profile, setProfile, clearProfile }),
    [profile, setProfile, clearProfile],
  )

  return <ProfileContext.Provider value={value}>{children}</ProfileContext.Provider>
}

export function useProfile() {
  const ctx = useContext(ProfileContext)
  if (!ctx) throw new Error('useProfile must be used within ProfileProvider')
  return ctx
}
