#!/usr/bin/env bash
# What the README promises, checked from inside the lab's own network: run by check.sh.
set -euo pipefail
: "${NET:?run through test/check.sh}"
probe() { docker run --rm --network "$NET" lab-check-probe bash -c "$1"; }
echo "- the root address sends on to /WebGoat/ through the proxy"
probe 'curl -s -i http://web/' | head -1 | grep -q ' 302'
probe 'curl -s -i http://web/' | grep -qi '^location: /WebGoat/'
probe 'curl -fs http://web/WebGoat/login' | grep -q 'Login Page'

echo "- an account can be registered and signed in to"
probe '
set -eu
j=/tmp/j
curl -s -i -c $j -b $j -d "username=student1&password=password1&matchingPassword=password1&agree=agree" http://web/WebGoat/register.mvc | grep -qi "^location: .*/WebGoat/attack"
curl -s -i -c $j -b $j -d "username=student1&password=password1" http://web/WebGoat/login | grep -qi "^location: .*/WebGoat/welcome.mvc"
'

echo "- WebWolf answers on its own port"
probe 'curl -s -i http://web:9090/' | grep -qi '^location: /WebWolf/'
[ "$(probe 'curl -s -o /dev/null -w "%{http_code}" http://web:9090/WebWolf/login')" = 200 ]
echo "  ok"
