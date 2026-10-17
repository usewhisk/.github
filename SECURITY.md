# Security policy

Whisk moves real money. We treat every report as urgent.

## Reporting a vulnerability

Do not open a public issue. Report privately through GitHub's private vulnerability
reporting on the affected repository, for example
[usewhisk/whisk](https://github.com/usewhisk/whisk/security/advisories/new).

Include:

- the affected package, version or URL;
- the chain pair and route, if a transfer is involved;
- steps to reproduce, and a transaction hash on testnet if you have one;
- the impact you expect: loss of funds, wrong amount, stuck transfer, data exposure.

Never test against mainnet funds that are not yours.

## What to expect

| Step                                             | Target                                           |
| ------------------------------------------------ | ------------------------------------------------ |
| Acknowledgement                                  | 2 business days                                  |
| Initial assessment                               | 5 business days                                  |
| Fix for a critical issue (loss or lock of funds) | As fast as possible, with a coordinated advisory |

We credit reporters in the advisory unless you ask us not to.

## Scope

- In scope: `@usewhisk/*` packages, `*.usewhisk.xyz`, and the APIs behind them.
- Out of scope: Circle's CCTP contracts and Iris, chain clients, and wallets. Report
  those to their owners.

## Supported versions

The latest minor release of each published package receives security fixes.
