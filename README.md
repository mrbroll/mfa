# MFA

CLI wrapper for [authenticator](https://git.daplie.com/Daplie/authenticator-cli) for integration with GNU Pass.

## Setup

This requires using Pass to store keys given for each mfa issuer. It also relies on a specific structure for these keys in pass. They are expected to be stored in the following format:
```
|-- MFA
|   |-- ISSUER
|   |   `-- USER
```
For Example:
```
|-- MFA
|   |-- AWS
|   |   `-- aws.user@example.com
|   |-- GitHub
|   |   `-- github.user@example.com
```
__NOTE:__ You will want to init a new pass store with a different gpg key, protected by a different password, for the MFA directory.

This also requires storing account aliases in a file under `$HOME/.config/mfa/aliases`. The format of this file is:
```
ALIAS ISSUER ACCOUNT
...
```
For Example:
```
github GitHub github.user@example.com
aws AWS aws.user@example.com
```
