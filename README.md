# Fuzzlib
Fuzzlib is an unopinionated Solidity library designed for both stateful and stateless fuzzing of smart contracts. It provides a collection of useful functions and libraries designed to streamline fuzzing harness development with Echidna, Medusa, and Foundry, making the process easier and more efficient.

**Fuzzlib is still in alpha and under active development with potential future breaking changes!**

## Branches
* `main`: Latest `fl.` namespace
* `v0_2`: Old namespace version for backwards compatibility


## Known limitations
- Signed integer clamping is limited to int128 range to avoid overflow issues in range calculations


