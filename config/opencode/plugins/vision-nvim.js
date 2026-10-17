// Original plugin supports only opencode v1. This rewrite is for opencode v2.
// Managed by vision.nvim. Re-run :VisionInstall opencode to refresh this file.
import { spawnSync } from "node:child_process"

const VISIONCTL = "/Users/kirillvakalov/.local/share/nvim/site/pack/core/opt/vision.nvim/bin/visionctl"

function extractContext(stdout) {
  const text = typeof stdout === "string" ? stdout.trim() : ""
  if (!text) return ""
  try {
    const payload = JSON.parse(text)
    if (typeof payload?.context === "string") return payload.context
    const hookOutput = payload?.hookSpecificOutput
    if (typeof hookOutput?.additionalContext === "string") return hookOutput.additionalContext
  } catch {
  }
  return ""
}

function visionContext(cwd, prompt) {
  const result = spawnSync(VISIONCTL, ["hook", "opencode"], {
    cwd,
    input: JSON.stringify({ prompt, cwd }),
    encoding: "utf8",
    maxBuffer: 1024 * 1024,
  })
  if (result.error || result.status !== 0) return ""
  return extractContext(result.stdout)
}

export const VisionNvim = {
  id: "vision-nvim",
  async setup(ctx) {
    await ctx.session.hook("prompt", (event) => {
      try {
        const cwd = typeof ctx.location?.directory === "string" ? ctx.location.directory : process.cwd()
        const text = typeof event?.prompt?.text === "string" ? event.prompt.text : ""
        const context = visionContext(cwd, text)
        if (!context) return
        event.prompt.text = text ? text + "\n\n" + context : context
      } catch {
      }
    })
  },
}

export default VisionNvim
