# Fuzzlib
Fuzzlib is an unopinionated Solidity library designed for both stateful and stateless fuzzing of smart contracts. It provides a collection of useful functions and libraries designed to streamline fuzzing harness development with Echidna, Medusa, and Foundry, making the process easier and more efficient.

**Fuzzlib is still in alpha and under active development with potential future breaking changes!**

## Branches
* `main`: Latest `fl.` namespace
* `v0_2`: Old namespace version for backwards compatibility


## Known limitations
- Clamping close to `type(uint256).max`, `type(int256).min`, and `type(int256).max` can cause overflow errors


