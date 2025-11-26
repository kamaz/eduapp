import { randomUUID } from 'node:crypto'
import { createClient } from '@supabase/supabase-js'
import {
  registrationParamsSchema,
  registrationResultSchema,
  type RegistrationParams,
  type RegistrationResult,
  type RegistrationService,
} from './model'
import type { AppContext } from '~/lib'
import { registrationConsentSchema } from '../endpoint/model'

export class RegistrationServiceClient implements RegistrationService {
  constructor(private readonly env: AppContext) {}

  async register(request: RegistrationParams): Promise<RegistrationResult> {
    const parsed = registrationParamsSchema.parse(request)
    const supabaseUrl = this.env.SUPABASE_URL
    const supabaseKey = this.env.SUPABASE_KEY
    if (!supabaseUrl || !supabaseKey) {
      throw new Error('SUPABASE_ENV_MISSING')
    }
    const consent = registrationConsentSchema.parse(parsed.consent)
    const supabase = createClient(supabaseUrl, supabaseKey)
    const userPayload = {
      id: randomUUID().toString(),
      firebase_uid: parsed.firebaseUid,
      email: parsed.email,
      display_name: parsed.profile?.displayName,
      created_at: parsed.now.getTime(),
      updated_at: parsed.now.getTime(),
    }

    const {
      data: userRows,
      error: userError,
      status: userStatus,
    } = await supabase
      .from('users')
      .upsert(userPayload, { onConflict: 'firebase_uid', ignoreDuplicates: false })
      .select('id,email')
      .limit(1)
      .maybeSingle()

    if (userError) {
      console.log('error', userError)
      throw new Error(`SUPABASE_USER_UPSERT_FAILED:${userError.code ?? userError.message}`)
    }

    if (!userRows?.id) {
      throw new Error('SUPABASE_USER_MISSING')
    }

    // const { error: consentError } = await supabase.from('user_consents').upsert(
    //   {
    //     user_id: userRows.id,
    //     policy_group_key: consent.groupKey,
    //     policy_version: consent.version,
    //     source: 'registration',
    //     recorded_at: request.now.toISOString(),
    //   },
    //   { onConflict: 'user_id,policy_group_key', ignoreDuplicates: true },
    // )
    //
    // if (consentError) {
    //   throw new Error(`SUPABASE_CONSENT_WRITE_FAILED:${consentError.code ?? consentError.message}`)
    // }

    return {
      userId: userRows.id,
      created: userStatus === 201,
      email: userRows.email,
      consent,
    }

    return registrationResultSchema.parse(result)
  }
}

export const createRegistrationService = (env: WorkerEnv): RegistrationService =>
  new RegistrationServiceClient(env)
