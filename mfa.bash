#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MFA_HOME=$HOME/.config/mfa
ALIAS_FILE=$MFA_HOME/aliases

USAGE="Get tokens for mfa or qr codes to sync mfa devices.
Usage: mfa CMD ALIAS

where CMD is one of:

token     : Get an MFA token.
qr        : Print a qr code to sync with mobile mfa applications like google authenticator.
-h --help : Print this help documentation.

ALIAS is a user-defined ALIAS to an issuer (GitHub, AWS, etc..), and account (typically email or username).
Aliases are stored in $HOME/.mfa/aliases, each on their own line in the form of: \"alias_name issuer account\".
"

CMD=$1
shift

if [ "$CMD" = "" ]; then
    echo "$USAGE"
    exit 0
fi

ALIAS=$1

if [ "$ALIAS" = "" ]; then
    echo "no alias provided"
    exit 1
fi


declare -A ALIASES
# load aliases config
while read -r line; do
    KEY="$(awk '{print $1}' <(echo "$line"))"
    VALUE="$(awk '{print $2 " " $3}' <(echo "$line"))"
    ALIASES["$KEY"]="$VALUE"
done <"$ALIAS_FILE"

ISSUER=$(echo ${ALIASES["$ALIAS"]} | awk '{print $1}')
ACCT=$(echo ${ALIASES["$ALIAS"]} | awk '{print $2}')

if [[ "$ISSUER" = "" || "$ACCT" = "" ]]; then
    echo "Invalid alias: \"$ALIAS\""
    exit 1
fi

KEY="$(pass show MFA/${ISSUER}/${ACCT})"

case "$CMD" in
    token)
    authenticator --key "$KEY" --issuer "$ISSUER" --account "$ACCT" | grep 'Token' | awk '{print $2}'
    ;;
    qr)
    authenticator --key "$KEY" --issuer "$ISSUER" --account "$ACCT" --qr
    ;;
    -h | --help)
    echo "$USAGE"
    ;;
    *)
    echo "Unknown command: \"$CMD\""
    echo "See mfa --help for usage"
    exit 1
    ;;
esac
