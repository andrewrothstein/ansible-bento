#!/usr/bin/env sh
set -e
DIR=~/Downloads

dl() {
    local mirror=$1
    local semver=$2
    local lchecksums=$3
    local app=$4
    local os=$5
    local arch=$6
    local archive_type=${7:-tar.gz}
    local platform="${os}_${arch}"
    local file="${app}_${semver}_${platform}.${archive_type}"
    local url="${mirror}/v${semver}/${file}"
    # example https://github.com/go-task/task/releases/download/v3.18.0/task_darwin_amd64.tar.gz
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local mirror=$1
    local semver=$2
    local app=$3
    local url="${mirror}/v${semver}/${app}_${semver}_checksums.txt"
    # https://github.com/go-task/task/releases/download/v3.18.0/task_checksums.txt
    local lchecksums="$DIR/${app}_${semver}_checksums.txt"
    # ~/Downloads/task_3.18.0_checksums.txt
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $semver

    dl ${mirror} ${semver} ${lchecksums} ${app} darwin amd64
    dl ${mirror} ${semver} ${lchecksums} ${app} darwin arm64
    dl ${mirror} ${semver} ${lchecksums} ${app} freebsd amd64
    dl ${mirror} ${semver} ${lchecksums} ${app} freebsd arm64
    dl ${mirror} ${semver} ${lchecksums} ${app} freebsd armv6
    dl ${mirror} ${semver} ${lchecksums} ${app} freebsd armv7
    dl ${mirror} ${semver} ${lchecksums} ${app} linux amd64
    dl ${mirror} ${semver} ${lchecksums} ${app} linux arm64
    dl ${mirror} ${semver} ${lchecksums} ${app} linux armv6
    dl ${mirror} ${semver} ${lchecksums} ${app} linux armv7
    dl ${mirror} ${semver} ${lchecksums} ${app} openbsd amd64
    dl ${mirror} ${semver} ${lchecksums} ${app} openbsd arm64
    dl ${mirror} ${semver} ${lchecksums} ${app} openbsd armv6
    dl ${mirror} ${semver} ${lchecksums} ${app} openbsd armv7
    dl ${mirror} ${semver} ${lchecksums} ${app} windows amd64
    dl ${mirror} ${semver} ${lchecksums} ${app} windows arm64
}

mirror() {
    local github_org=$1
    local github_project=$2
    echo "https://github.com/${github_org}/${github_project}/releases/download"
}

dl_ver \
    "$(mirror "warpstreamlabs" "bento")" \
    "${1:-1.0.1}" \
    "bento"
