#!/bin/bash

start=$(awk '/- Examples:/{ print NR; exit }' config/nav.yml)
end=$(awk '/- Events:/{ print NR; exit }' config/nav.yml)
num=$(($end - 1))

sed -i "${start}, ${num}d" config/nav.yml

nav=$(cat direktiv-examples/out/nav.out)

echo $nav
ed -v config/nav.yml <<END
${start}i
${nav}
.
w
q
END