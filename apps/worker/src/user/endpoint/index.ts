import { Hono } from 'hono'
import type { AppBindings } from '~/lib'
import { register } from './register'

const userApp = new Hono<AppBindings>()

userApp.post('/register/', register)
userApp.post('/register', register)

export { userApp }
