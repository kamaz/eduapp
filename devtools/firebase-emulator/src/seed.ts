/*
  Minimal seeding script for the Firebase Auth Emulator.
  - Creates example users for local development.
  - Requires the Auth emulator to be running (or will connect when you start it next).

  Important: This script uses firebase-admin pointed at the emulator via env var.
  Usage: pnpm seed
*/

import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

const PROJECT_ID = process.env.FB_PROJECT_ID || 'dev-eduapp';

// Point Admin SDK at the emulator without service account by providing minimal credentials.
process.env.FIREBASE_AUTH_EMULATOR_HOST = process.env.FIREBASE_AUTH_EMULATOR_HOST || '127.0.0.1:9099';

// Initialize only once
if (!getApps().length) {
  initializeApp({
    credential: cert({
      clientEmail: 'dev@local',
      privateKey: '-----BEGIN PRIVATE KEY-----\nMIIB...dev\n-----END PRIVATE KEY-----\n',
      projectId: PROJECT_ID,
    }),
    projectId: PROJECT_ID,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  } as any);
}

const auth = getAuth();

async function ensureUser(uid: string, email: string, displayName: string) {
  try {
    await auth.getUser(uid);

    console.log(`User exists: ${uid}`);
  } catch {
    await auth.createUser({ uid, email, emailVerified: true, displayName });

    console.log(`Created user: ${uid}`);
  }
}

async function main() {
  await ensureUser('parent_demo', 'parent@example.com', 'Parent Demo');
  await ensureUser('child_demo', 'child@example.com', 'Child Demo');
}

main().catch((err) => {

  console.error(err);
  process.exit(1);
});

