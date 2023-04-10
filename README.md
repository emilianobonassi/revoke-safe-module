# 🔏 Revoke Safe Module 🧯
A Gnosis Safe Module to delegate to an another account to revoke on your behalf token allowances for an exploited address.

## How it works

You delegate your hot wallet or a 3rd party to be able to revoke permissions on your behalf.

They can call `revokeERC20`, `revokeERC721` and `revokeERC1155` to reset allowances for a `token` on a specific `operator` or `spender` which may be exploited.

It's a Safe module, so to use, you have to deploy and enable in your Safe.

## Security

It's a PoC and not audited. Experiment at your own risk.