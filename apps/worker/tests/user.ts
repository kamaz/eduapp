import {
  getAuth,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  connectAuthEmulator,
  type User,
} from 'firebase/auth'
import { initializeApp } from 'firebase/app'
import { isLocal } from './env'

// Firebase client SDK configuration
const firebaseConfig = {
  apiKey: 'AIzaSyB04eH-wdXTCFqLFw5DcmGUD5PMUQZG5qg',
  authDomain: 'getlifia-app.firebaseapp.com',
  projectId: 'getlifia-app',
  storageBucket: 'getlifia-app.firebasestorage.app',
  messagingSenderId: '275112936350',
  appId: '1:275112936350:web:13e22313af63caeec48c8f',
}

// Initialize Firebase client app
const app = initializeApp(firebaseConfig)
const auth = getAuth(app)

// Connect to auth emulator in development
if (isLocal()) {
  try {
    connectAuthEmulator(auth, 'http://localhost:9099')
    // FIXME: change to debug level
    // console.log("Connected to Firebase Auth Emulator");
  } catch (error) {
    console.error('Failed to connect to Firebase Auth Emulator:', error)
  }
}

export const TEST_USER_1 = 'kamilzuzda+user-1@gmail.com'
export const TEST_USER_2 = 'kamilzuzda+user-2@gmail.com'
export const TEST_PASS = 'SecurePass!1'

export async function createUser(email: string, password: string): Promise<string | undefined> {
  try {
    const userRecord = await createUserWithEmailAndPassword(auth, email, password)
    return userRecord.user.uid
  } catch (error) {
    // auth/email-already-in-use
    if (error.code !== 'auth/email-already-in-use') {
      // we can ignore this error
      console.error('Error creating user with keys', error)
      throw error
    }
  }
}

export async function getIdTokenForTestUser(user: string): Promise<string> {
  try {
    // Sign in user with Firebase client SDK
    const userCredential = await signInWithEmailAndPassword(auth, user, TEST_PASS)

    // const id = userCredential.user.uid
    // Get ID token
    const idToken = await userCredential.user.getIdToken()

    return idToken
  } catch (error) {
    console.error('Error signing in:', error)
    throw error
  }
}

export async function getIdTokenForUser(email: string, password: string): Promise<string> {
  try {
    const userCredential = await signInWithEmailAndPassword(auth, email, password)
    return userCredential.user.getIdToken()
  } catch (error) {
    console.error('Error signing in:', error)
    throw error
  }
}

export async function createUserAndGetToken(email: string, password: string = TEST_PASS) {
  await createUser(email, password)
  return getIdTokenForUser(email, password)
}

async function getUser(email: string): Promise<User> {
  try {
    // Sign in user with Firebase client SDK
    const userCredential = await signInWithEmailAndPassword(auth, email, TEST_PASS)

    // const id = userCredential.user.uid
    // Get ID token
    const user = userCredential.user

    return user
  } catch (error) {
    console.error('Error signing in:', error)
    throw error
  }
}

// TODO: replace with openapi generator
let token1 = ''
export const getTokenUser1 = async () => {
  if (!token1) {
    token1 = await getIdTokenForTestUser(TEST_USER_1)
  }
  return token1
}

export const getUser1 = async () => {
  return await getUser(TEST_USER_1)
}

let token2 = ''
export const getTokenUser2 = async () => {
  if (!token2) {
    token2 = await getIdTokenForTestUser(TEST_USER_2)
  }
  return token2
}

export const getUser2 = async () => {
  return await getUser(TEST_USER_1)
}
