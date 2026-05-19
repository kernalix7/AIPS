# Contributing

**English** | [한국어](docs/CONTRIBUTING.ko.md)

Thanks for your interest in contributing!

## Development Setup

```bash
git clone https://github.com/kernalix7/AIPS.git
cd AIPS
```

No build step — `AI_PROJECT_SETUP.md` is the artifact.

## Workflow

1. Fork the repo and create a feature branch: `git checkout -b feature/my-change`
2. Make your changes to `AI_PROJECT_SETUP.md` and/or `README.md`
3. Bump version: update title `**v5.X**`, `**Last Updated**:` date, and add a row to the Version History table
4. Run verification:
   ```bash
   wc -l AI_PROJECT_SETUP.md
   grep -c "^## Version History" AI_PROJECT_SETUP.md
   ```
5. Commit using conventional prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
6. Open a Pull Request

## Commit Convention

- `feat:` new feature
- `fix:` bug fix
- `refactor:` code restructure without behavior change
- `docs:` documentation only
- `chore:` tooling, build, dependencies

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

By contributing, you agree your contributions are licensed under the [MIT License](LICENSE).
