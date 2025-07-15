# Contributing to Fuzzlib

Thanks for your interest in contributing to Fuzzlib!

## Development Setup

### Prerequisites

- [Foundry](https://getfoundry.sh/)

### Setup

```bash
git clone https://github.com/your-username/fuzzlib.git
cd fuzzlib
forge install
```

### Testing

```bash
# Run all tests
forge test

# Run tests with increased fuzz runs
forge test --fuzz-runs 10000

# Run Echidna E2E tests
python3 test/e2e/echidna/run-echidna.py
```

## Contributing Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Add tests
5. Ensure all tests pass: `forge test`
6. Format code: `forge fmt`
7. Commit and push
8. Open a Pull Request against the main repository

## Development Guidelines

- Keep code simple and maintainable
- Follow existing code patterns and conventions
- Add comprehensive tests for new functionality
- Update documentation as needed

## Issues

- Check existing issues before creating new ones
- Provide clear reproduction steps
- Include sample code if relevant