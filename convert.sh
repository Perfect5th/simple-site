#!/usr/bin/env sh

# A simple-site convertor. Wraps the html produced from markdown in a few tags
# to make it web-servable.

. ./env

FILES=$(find ./markdown -type f -name '*.md')

rm -rf ./_site

convert_file() {
    HTML_PATH=$(echo "$1" | sed -e 's/\.md$/\.html/' | sed -e 's/^\.\/markdown/\.\/_site/')

    mkdir -p "$(dirname "$HTML_PATH")"

    FIRST_LINE=$(head -n 1 "$1")

    if echo "$FIRST_LINE" | grep -q '^# '; then
        PAGE_TITLE=$(echo "$FIRST_LINE" | cut -c3-)
    else
        PAGE_TITLE=$SITE_TITLE
    fi

    echo "Creating $HTML_PATH"
    sed -e "s:{{SITE_ROOT}}:$SITE_ROOT:g" ./templates/base.html | \
        sed -e "s:{{PAGE_TITLE}}:$PAGE_TITLE:g" \
        > "$HTML_PATH"
    markdown --html4tags "$1" >> "$HTML_PATH"
    cat ./templates/close.html >> "$HTML_PATH"
}

for FILE in $FILES; do
    convert_file "$FILE" &
done

wait

mkdir -p ./_site/css
mkdir -p ./_site/js
mkdir -p ./_site/fonts
cp ./css/base.css ./_site/css/base.css
cp ./js/main.js ./_site/js/main.js
cp ./favicon.ico ./_site/favicon.ico
cp ./fonts/* ./_site/fonts/
