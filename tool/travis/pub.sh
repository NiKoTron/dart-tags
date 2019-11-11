#!/bin/bash
mkdir -p .pub-cache

cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken":"$accessToken",
  "refreshToken":"$refreshToken",
  "tokenEndpoint":"$tokenEndpoint",
  "scopes":["https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/plus.me"],
  "expiration":$expiration
}
EOF

pub publish -f
