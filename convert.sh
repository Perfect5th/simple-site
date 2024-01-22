#!/usr/bin/env sh

# A simple-site convertor. Wraps the html produced from markdown in a few tags
# to make it web-servable.

. ./env

FILES=$(find ./markdown -type f -name '*.md')

rm -rf ./_site

generate_crumbs() {
    HTML_PATH="$1"
    ROOT="/"
    [ -n "$SITE_ROOT" ] && ROOT="$SITE_ROOT"
    PARTS=$(echo "$HTML_PATH" |  sed -e 's/\(\/index\)\?\.html$//' | cut -d'/' -f3- | sed -e 's/\// /g')

    echo '<nav class="crumbs"><ol>' >> "$HTML_PATH"

    FULL_PATH="$ROOT"
    printf '<li class="crumb"><a href="%s">Home</a></li>' "$ROOT" >> "$HTML_PATH"
    for PART in $PARTS; do
        FULL_PATH="$FULL_PATH/$PART"
        printf '<li class="crumb"><a href="%s">%s</a></li>' "$FULL_PATH" "$PART" >> "$HTML_PATH"
    done

    echo "</ol></nav>" >> "$HTML_PATH"
}

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

    if [ "$CRUMBS" = "YES" ]; then
        generate_crumbs "$HTML_PATH"
    fi

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
sed -e "s:{{SITE_ROOT}}:$SITE_ROOT:g" ./css/base.css > ./_site/css/base.css
sed -e "s:{{SITE_ROOT}}:$SITE_ROOT:g" ./js/main.js > ./_site/js/main.js
cp ./fonts/* ./_site/fonts/ || true
