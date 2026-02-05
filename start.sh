#!/bin/bash  
set -euo pipefail  
: "${OPENAI_API_KEY:?Missing OPENAI_API_KEY}"  
: "${TELEGRAM_BOT_TOKEN:?Missing TELEGRAM_BOT_TOKEN}"  
mkdir -p /root/.openclaw/agents/main/agent  
# Create openclaw.json  
cat > /root/.openclaw/openclaw.json << 'JSONEOF'  
{  
  "agents": {  
    "defaults": {  
      "models": {  
        "openai/gpt-4o-mini": { "alias": "default" }  
      }  
    }  
  },  
  "channels": {  
    "telegram": {  
      "enabled": true,  
      "groupPolicy": "allowlist",  
      "dmPolicy": "pairing",  
      "streamMode": "partial"  
    }  
  }  
}  
JSONEOF  
# Update telegram bot token  
node -e "const fs=require('fs');const p='/root/.openclaw/openclaw.json';const j=JSON.parse(fs.readFileSync(p,'utf8'));j.channels.telegram.botToken=process.env.TELEGRAM_BOT_TOKEN;fs.writeFileSync(p,JSON.stringify(j,null,2));"  
# Create auth-profiles.json  
cat > /root/.openclaw/agents/main/agent/auth-profiles.json << 'JSONEOF'  
{  
  "openai": { "mode": "env" }  
}  
JSONEOF  
chmod 600 /root/.openclaw/agents/main/agent/auth-profiles.json  
openclaw cron &  
PORT=8080  
node -e "require('http').createServer((req,res)=>res.end('ok')).listen(PORT,'0.0.0.0')"
