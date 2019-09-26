simple port pkg_cutleaves from freebsd

1. edit pkg_cutleaves.conf as plain text
2. add package name as exclude
3. run ./pkg_cutleaves.sh

packages not (optionally) required by any package will display and call with pacman -Rsn
