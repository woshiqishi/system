#!/bin/bash

_requirements() {
    _apps=(
        'python3'
        'python3-pip'
        'python3-venv'
    )

    for _app in "${_apps[@]}"; do
        if ! command -v "$_app" &>/dev/null; then
            sudo apt install -qqy "$_app"
        fi
    done
}

_dir="$HOME/.sgpt"

_create_dir() {
    if ! [ -d "$_dir" ]; then
        if ! mkdir "$_dir"; then
            echo 'ERROR: _create_dir()'; exit 1
        fi
    fi
}

_create_venv() {
    if ! python3 -m venv "$_dir"; then
        echo 'ERROR: _create_venv()'; exit 1
    fi
}

_install_sgpt() {
    if ! "$_dir"/bin/pip install shell-gpt; then
        echo 'ERROR: _install_sgpt()'; exit 1
    fi
}

_main() {
    if [[ "$1" == "-x" ]]; then
        set -x
    fi

    _requirements
    _create_dir
    _create_venv
    _install_sgpt
}

_main "$@"
