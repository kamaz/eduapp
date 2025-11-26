import { Hono } from 'hono'
import { userApp } from './user'
import { logMiddleware } from './middleware/log'
import { firebaseAuth } from './middleware/firebase-auth'

const app = new Hono()

app.use('*', logMiddleware)
app.use('*', firebaseAuth)

app.route('/api/user', userApp)

export default app
