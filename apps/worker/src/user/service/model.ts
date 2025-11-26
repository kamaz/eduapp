import { z } from 'zod'
import { registrationConsentSchema, registrationRequestSchema } from '../endpoint/model'

export const registrationParamsSchema = registrationRequestSchema.extend({
  firebaseUid: z.string().min(1),
  email: z.string().min(1),
  emailVerified: z.boolean(),
  now: z.date(),
})

export type RegistrationParams = z.infer<typeof registrationParamsSchema>

export const registrationResultSchema = z.object({
  userId: z.string().min(1),
  created: z.boolean(),
  email: z.string().min(1),
  consent: registrationConsentSchema,
})

export type RegistrationResult = z.infer<typeof registrationResultSchema>

export interface RegistrationService {
  register: (request: RegistrationParams) => Promise<RegistrationResult>
}
