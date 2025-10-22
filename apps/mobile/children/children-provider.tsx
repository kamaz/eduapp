import React, { createContext, useCallback, useContext, useMemo, useState } from 'react'

export type Child = {
  id: string
  firstName: string
  lastName: string
  dob: string // YYYY-MM-DD for now
  createdAt: number
}

type ChildrenContextValue = {
  children: Child[]
  addChild: (input: { firstName: string; lastName: string; dob: string }) => Promise<void>
}

const ChildrenContext = createContext<ChildrenContextValue | undefined>(undefined)

export function ChildrenProvider({ children: node }: { children: React.ReactNode }) {
  const [children, setChildren] = useState<Child[]>([])

  const addChild = useCallback(
    async (input: { firstName: string; lastName: string; dob: string }) => {
      await new Promise((res) => setTimeout(res, 1000))
      setChildren((prev) => [
        {
          id: Math.random().toString(36).slice(2),
          firstName: input.firstName.trim(),
          lastName: input.lastName.trim(),
          dob: input.dob.trim(),
          createdAt: Date.now(),
        },
        ...prev,
      ])
    },
    [],
  )

  const value = useMemo<ChildrenContextValue>(() => ({ children, addChild }), [children, addChild])

  return <ChildrenContext.Provider value={value}>{node}</ChildrenContext.Provider>
}

export function useChildren() {
  const ctx = useContext(ChildrenContext)
  if (!ctx) throw new Error('useChildren must be used within ChildrenProvider')
  return ctx
}
