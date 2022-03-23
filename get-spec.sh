#!/usr/bin/env bash 

BRANCH=${BRANCH:-'main'}

rm -rf docs/spec   
rm -rf direktiv

if [ -z "$DIR" ];
then
    echo "Cloning branch $BRANCH"
    git clone -b $BRANCH https://github.com/direktiv/direktiv.git
    cp -r direktiv/specification docs/spec
    rm -rf direktiv
else
    echo "Copying directory $DIR"
    cp -r $DIR docs/spec
fi

echo "Scanning docs..."

for f in $(find docs/spec -type d);
do 
    # echo "$f"
    f="$f/index.yml"
    path=${f#"docs/spec"}
    path=${path#"/"}
    echo "${path}"
done

cat docs/spec/index.yml config/nav-template.yml | yq -o j '.' | jq '.index = [.index[] | walk(if type == "string" then ("spec/" + .) else . end) ]' | jq '.nav = [{index:.index, nav:.nav[]} | if .nav."Specification"? then .nav."Specification"=.index else . end | .nav] | del(.index)' | yq -P '.' > config/nav.yml
