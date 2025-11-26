import { z } from 'zod'

export const registrationConsentSchema = z.object({
  groupKey: z.string().min(1, 'consent.groupKey is required'),
  version: z.string().min(1, 'consent.version is required'),
})

export const registrationProfileSchema = z
  .object({
    displayName: z.string().min(1).max(120).optional(),
    locale: z.string().min(2).max(10).optional(),
    timeZone: z.string().min(2).max(60).optional(),
  })
  .default({})

export const registrationRequestSchema = z.object({
  idempotencyKey: z.string().min(1, 'idempotencyKey is required'),
  consent: registrationConsentSchema,
  profile: registrationProfileSchema,
})

export const registrationResponseSchema = z.object({
  user_id: z.string().min(1),
  email: z.string().min(1),
  consent: registrationConsentSchema,
})

export type RegistrationRequest = z.infer<typeof registrationRequestSchema>
export type RegistrationResponse = z.infer<typeof registrationResponseSchema>
