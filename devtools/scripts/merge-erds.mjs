/* global process console */
import { promises as fs } from 'node:fs'
import path from 'node:path'

// Combine domain ERD .mmd files into a single docs/erd/erd.mmd
// - Keeps domain files as-is
// - Writes a single erDiagram block with domain sections appended

const repoRoot = path.resolve(process.cwd())
const erdDir = path.join(repoRoot, 'docs', 'erd')
const outputFile = path.join(erdDir, 'erd.mmd')

// Preferred merge order for readability
const preferredOrder = [
  'erd-onboarding.mmd',
  'erd-tasks-lessons.mmd',
  'erd-progress.mmd',
  'erd-generation.mmd',
]

function stripToDiagramBody(text) {
  const lines = text.replaceAll('\r\n', '\n').split('\n')
  const idx = lines.findIndex((l) => l.trim().toLowerCase() === 'erdiagram')
  if (idx === -1) return text // fallback, unexpected
  return (
    lines
      .slice(idx + 1)
      .join('\n')
      .trim() + '\n'
  )
}

async function main() {
  const entries = await fs.readdir(erdDir, { withFileTypes: true })
  const domainFiles = entries
    .filter((e) => e.isFile() && e.name.startsWith('erd-') && e.name.endsWith('.mmd'))
    .map((e) => e.name)

  if (domainFiles.length === 0) {
    console.error('No domain ERD files found at docs/erd/*.mmd matching erd-*.mmd')
    process.exitCode = 1
    return
  }

  const ordered = [
    ...preferredOrder.filter((n) => domainFiles.includes(n)),
    ...domainFiles.filter((n) => !preferredOrder.includes(n)).sort(),
  ]

  let combined = 'erDiagram\n'

  for (const name of ordered) {
    const filePath = path.join(erdDir, name)
    const raw = await fs.readFile(filePath, 'utf8')
    const body = stripToDiagramBody(raw)
    combined += `\n%% ---- Begin ${name} ----\n` + body + `%% ---- End ${name} ----\n`
  }

  // Ensure output directory exists (it should), then write
  await fs.mkdir(erdDir, { recursive: true })
  await fs.writeFile(outputFile, combined, 'utf8')
  console.log(`Combined ERD written to ${path.relative(repoRoot, outputFile)}`)
}

main().catch((err) => {
  console.error('Failed to combine ERDs:', err)
  process.exitCode = 1
})
