#!/usr/bin/bash -e
#
# Updating repository on Gitea.
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
  -o 'OWNER'                            Repository owner (organization).
  -r 'REPO_1;REPO_2;REPO_3'             Repository name (array).
  -d 'DESCRIPTION'                      Repository description.
  -b 'main'                             Repository default branch.
  -p                                    Whether repository is private.
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts 'x:a:o:r:d:l:b:ph' opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    a)
      api="${OPTARG}"
      ;;
    o)
      org="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    d)
      description="${OPTARG}"
      ;;
    b)
      branch="${OPTARG}"
      ;;
    p)
      private=1
      ;;
    h|*)
      echo "${help}"; exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) && { echo >&2 '[ERROR] Repository name not specified!'; exit 1; }
[[ -z "${token}" ]] && { echo >&2 '[ERROR] Token not specified!'; exit 1; }
[[ -z "${org}" ]] && { echo >&2 '[ERROR] Repository owner (organization) not specified!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_update
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB: UPDATE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_update() {
  [[ -n "${private}" ]] && private='true' || private='false'

  for repo in "${repos[@]}"; do
    echo '' && echo "--- OPEN: '${repo}'"

    ${curl} -X PATCH \
      -H "Authorization: token ${token}" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      "${api}/api/v1/repos/${org}/${repo}" \
      -d @- << EOF
{
  "default_branch": "${branch}",
  "name": "${repo}",
  "description": "${description}",
  "private": ${private}
}
EOF

    echo '' && echo "--- DONE: '${repo}'" && echo ''; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
