#!/usr/bin/env -S bash -e
#
# Transferring repository on Gitea.
#
# @package    Bash
# @author     Kai Kimera <mail@kai.kim>
# @copyright  2023 iHub TO
# @license    MIT
# @version    0.0.1
# @link       https://lib.onl
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID == 0 )) && { echo >&2 'This script should not be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

curl="$( command -v curl )"
sleep='2'

# Help.
read -r -d '' help <<- EOF
Options:
  -x 'TOKEN'                            Gitea user token.
  -a 'https://gitea.com'                Gitea API URL.
  -o 'OWNER_OLD'                        OLD repository owner (organization).
  -n 'OWNER_NEW'                        NEW repository owner (organization).
  -r 'REPO_1;REPO_2;REPO_3'             Repository name (array).
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts 'x:a:o:n:r:h' opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    a)
      api="${OPTARG}"
      ;;
    o)
      owner_old="${OPTARG}"
      ;;
    n)
      owner_new="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    h|*)
      echo "${help}"; exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) && { echo >&2 '[ERROR] Repository name not specified!'; exit 1; }
[[ -z "${token}" ]] && { echo >&2 '[ERROR] Token not specified!'; exit 1; }
[[ -z "${owner_old}" ]] && { echo >&2 '[ERROR] OLD repository owner (organization) not specified!'; exit 1; }
[[ -z "${owner_new}" ]] && { echo >&2 '[ERROR] NEW repository owner (organization) not specified!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_transfer
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB: TRANSFER REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_transfer() {
  for repo in "${repos[@]}"; do
    echo '' && echo "--- OPEN: '${repo}'"

    ${curl} -X POST \
      -H "Authorization: token ${token}" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      "${api}/api/v1/repos/${owner_old}/${repo}/transfer" \
      -d @- << EOF
{
  "new_owner": "${owner_new}"
}
EOF

    echo '' && echo "--- DONE: '${repo}'" && echo ''; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
