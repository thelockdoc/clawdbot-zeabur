#!/bin/bash
set -euo pipefail
: "${OPENAI_API_KEY:?Missing OPENAI_API_KEY}"
: "${TELEGRAM_BOT_TOKEN:?Missing TELEGRAM_BOT_TOKEN}"
mkdir -p /root/.openclaw/agents/main/agent
# Create openclaw.json using echo
echo '{' > /root/.openclaw/openclaw.json
echo '  "agents": {' >> /root/.openclaw/openclaw.json
echo '    "defaults": {' >> /root/.openclaw/openclaw.json
echo '      "models": {' >> /root/.openclaw/openclaw.json
echo '        "openai/gpt-4o-mini": { "alias": "default" }' >> /root/.openclaw/openclaw.json
echo '      }' >> /root/.openclaw/openclaw.json
echo '    }' >> /root/.openclaw/openclaw.json
echo '  },' >> /root/.openclaw/openclaw.json
echo '  "channels": {' >> /root/.openclaw/openclaw.json
echo '    "telegram": {' >> /root/.openclaw/openclaw.json
echo '      "enabled": true,' >> /root/.openclaw/openclaw.json
echo '      "groupPolicy": "allowlist",' >> /root/.openclaw/openclaw.json
echo '      "dmPolicy": "pairing",' >> /root/.openclaw/openclaw.json
echo '      "streamMode": "partial"' >> /root/.openclaw/openclaw.json
echo '    }' >> /root/.openclaw/openclaw.json
echo '  }' >> /root/.openclaw/openclaw.json
echo '}' >> /root/.openclaw/openclaw.json
# Update telegram bot token
node -e "const fs=require('fs');const p='/root/.openclaw/openclaw.json';const j=JSON.parse(fs.readFileSync(p,'utf8'));j.channels.telegram.botToken=process.env.TELEGRAM_BOT_TOKEN;fs.writeFileSync(p,JSON.stringify(j,null,2));"
# Create auth-profiles.json
echo '{' > /root/.openclaw/agents/main/agent/auth-profiles.json
echo '  "openai": { "mode": "env" }' >> /root/.openclaw/agents/main/agent/auth-profiles.json
echo '}' >> /root/.openclaw/agents/main/agent/auth-profiles.json
chmod 600 /root/.openclaw/agents/main/agent/auth-profiles.json
openclaw cron &
PORT=8080
node -e "require('http').createServer((req,res)=>res.end('ok')).listen(PORT,'0.0.0.0')"
