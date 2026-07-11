# Tailscale policy GitOps

The source of truth for this tailnet policy is [`../tailscale/policy.hujson`](../tailscale/policy.hujson).

## Intentional access model

| Path | Reason |
|---|---|
| Any tailnet member → `tag:server:443` | Hermes dashboard over Tailscale Serve HTTPS |
| Any tailnet member → `tag:server:80` | Existing private HTTP services |
| `tag:server` → Ali-owned device port `2222` | Normal OpenSSH from the tagged server to the untagged work laptop |
| Members → their own devices via Tailscale SSH | Personal-device administration |
| Members → `tag:server` via Tailscale SSH | Server administration |

The work laptop remains **untagged and user-owned**. This is required for phone ↔ work Taildrop; do not add `tag:work` to it merely to make remote administration easier.

## GitHub Actions setup — one-time admin step

The workflow uses Tailscale workload identity, not a long-lived API key.

1. In the Tailscale admin console, create a GitHub Actions federated identity with the `policy_file` scope. Restrict its trust policy to this repository: `ali-aljufairi/dotfiles`.
2. In the GitHub repository settings for `ali-aljufairi/dotfiles`, add these Actions secrets:
   - `TS_OAUTH_ID` — the generated Tailscale client ID
   - `TS_AUDIENCE` — the generated audience value
   - `TS_TAILNET` — the exact tailnet name shown in the Tailscale admin console
3. Push or merge the policy to `main`. Pull requests run `test`; merges to `main` run `apply`.

Do not commit credentials, API keys, OAuth secrets, or tailnet auth keys.

## Safe change workflow

1. Edit `tailscale/policy.hujson` on a branch.
2. Open a pull request.
3. Require the **Tailscale policy** GitHub check to pass.
4. Merge to `main`; the workflow validates again and applies the policy.
5. Verify expected paths using Tailscale-connected devices.

## Current policy tests

- A member can reach the tagged server on ports 80 and 443.
- A member cannot reach the tagged server on port 8080.
- A tagged server can reach Ali-owned devices on port 2222.
