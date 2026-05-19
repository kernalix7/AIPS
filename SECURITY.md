# Security Policy

**English** | [한국어](docs/SECURITY.ko.md)

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| latest  | :white_check_mark: |

Security updates apply to the latest version on the `main` branch.

## Reporting a Vulnerability

**Do NOT report security vulnerabilities through public GitHub issues.**

Report via [GitHub Security Advisories](https://github.com/kernalix7/AIPS/security/advisories/new).

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Affected versions
- Potential impact

### Response Time

We aim to acknowledge reports within 7 days and provide a status update within 30 days.

## Scope

This project is a single-file bootstrap prompt (`AI_PROJECT_SETUP.md`). Security concerns include:
- Shell injection in `tmp-igbkp/` toolkit scripts
- Encryption defaults (AES-256-CBC, PBKDF2 600k iterations)
- Self-update URL integrity
- Secret-leak prevention in `secret-guard.sh` patterns
