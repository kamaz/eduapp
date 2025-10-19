import React, { createContext, useContext, useEffect, useMemo, useState } from 'react'
import {
  getAuth,
  FirebaseAuthTypes,
  onAuthStateChanged,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut,
} from '@react-native-firebase/auth'
import { configureFirebaseForDev } from '@/lib/firebase'

type AuthContextValue = {
  user: FirebaseAuthTypes.User | null
  initializing: boolean
  getIdToken: (forceRefresh?: boolean) => Promise<string | null>
  signIn: (email: string, password: string) => Promise<void>
  signUp: (email: string, password: string) => Promise<void>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [initializing, setInitializing] = useState(true)
  const [user, setUser] = useState<FirebaseAuthTypes.User | null>(null)

  useEffect(() => {
    configureFirebaseForDev()
    const sub = onAuthStateChanged(getAuth(), (u) => {
      setUser(u)
      if (initializing) setInitializing(false)
    })
    return () => sub()
  }, [initializing])

  const value = useMemo<AuthContextValue>(
    () => ({
      user,
      initializing,
      async getIdToken(forceRefresh?: boolean) {
        if (!getAuth().currentUser) return null
        return getAuth().currentUser!.getIdToken(!!forceRefresh)
      },
      async signIn(email: string, password: string) {
        await signInWithEmailAndPassword(getAuth(), email, password)
      },
      async signUp(email: string, password: string) {
        await createUserWithEmailAndPassword(getAuth(), email, password)
      },
      async signOut() {
        await signOut(getAuth())
      },
    }),
    [user, initializing],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
