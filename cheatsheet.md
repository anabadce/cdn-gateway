# Cheatsheet and useful commands

```bash
# top country code
docker compose logs | cut -d ' ' -f 6 | grep -E "\""| sort | uniq -c | sort

# Errors from given country code
docker compose logs | grep -E "(400|403|405|418)\ b_out" | grep '"AU"'

# top country/IP/user-agent of requests excluding errors
docker compose logs | grep -vE "(400|403|405|418)\ b_out" | grep -vE '(warn|notice|well-known|docker-entrypoint)' \
  | awk '{print $5" "$4" "$7" "$16" "$17" "$18" "$19" "$20}' | sort | uniq -c | sort
```
