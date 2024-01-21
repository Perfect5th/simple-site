#!/usr/bin/env sh

# A simple-site converted. Wraps the html produced from markdown in a few tags
# to make it web-servable.

FILES=$(find ./markdown -type f -name '*.md')

rm -rf ./_site
mkdir -p ./_site

for FILE in $FILES; do
    HTML_PATH=$(echo "$FILE" | sed -e 's/\.md$/\.html/' | sed -e 's/^\.\/markdown/\.\/_site/')
    echo "Creating $HTML_PATH"
    cat ./templates/base.html > "$HTML_PATH"
    markdown --html4tags "$FILE" >> "$HTML_PATH"
    cat ./templates/close.html >> "$HTML_PATH"
done

mkdir -p ./_site/css
mkdir -p ./_site/js
cp ./css/base.css ./_site/css/base.css
cp ./js/main.js ./_site/js/main.js
cp ./favicon.ico ./_site/favicon.ico
