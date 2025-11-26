import { createUser, TEST_PASS, TEST_USER_1, TEST_USER_2 } from './user'

export default async function setup() {
  // project.onTestsRerun(async () => {
  //   await restartDb()
  // })
  await createUser(TEST_USER_1, TEST_PASS)
  await createUser(TEST_USER_2, TEST_PASS)
}
