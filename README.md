# Linux Server Lab

Hands-on Linux server setup and debugging on a VPS (Ubuntu).

## What I Did
- Set up Nginx with SSL, caching and basic security
- Deployed WordPress manually (no cPanel)
- Configured PHP-FPM and MySQL
- Applied basic server hardening (SSH, UFW, Fail2Ban)

## Issues Faced and Fixed

**502 Bad Gateway**
- PHP-FPM was not running / wrong socket path
- Fixed by restarting service and correcting config

**504 Gateway Timeout**
- PHP response was too slow for Nginx timeout
- Fixed by adjusting timeout settings

**403 Forbidden**
- Missing index file and incorrect permissions
- Fixed by correcting file path and permissions

## Stack
Ubuntu · Nginx · PHP 8.3 FPM · MySQL · Let's Encrypt

## Notes
Practice project where I reproduced and fixed real server issues on a VPS.
