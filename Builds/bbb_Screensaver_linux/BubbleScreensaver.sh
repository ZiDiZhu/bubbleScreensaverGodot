#!/bin/sh
echo -ne '\033c\033]0;BubbleBlissScreensaver\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/BubbleScreensaver.x86_64" "$@"
