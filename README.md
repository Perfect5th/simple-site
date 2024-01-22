# simple-site
A simple, markdown-based website.

This is a place for me to test out a very simple method of deploying a static HTML site with pages written in markdown. Think like Jekyll or Hugo but much "dumber".

The demo site can be found [here][demo site] and is completely unstyled and has no javascript.

For my actual website source see [this repo][1].

## How it works

1. Fork this repo
2. Make sure github pages is turned on and the source is set to "Github Actions"
3. Put your markdown files in `./markdown`, make sure they end with `.md`
4. Replace the `favicon.ico` of my face with your own, or delete it
5. Change `SITE_ROOT` in `./env` to match where your site will be served
6. Commit and push

If you don't want the generated breadcrumbs, change (or delete) `CRUMBS` in `./env`.

**Note**: If your markdown file starts with a H1 header, That header will also be used as the title of the page.

## Custom CSS and Javascript

For those of you who really want to feel the pain, put your css in `./css/base.css` and your javascript in `./js/main.js`.
Both will get deployed with your static site and loaded for every page. Similarly, make sure they end with `.css` and `.js`,
respectively.

If you need more than one file, either get clever or edit `./templates/base.html` or `./templates/close.html`.

## Testing locally

Make sure you have `markdown` installed. You can get it from [the Markdown Homepage][2] or your favourite package manager probably.
Make sure you have a POSIX shell of some kind.

Execute `./convert.sh`, which builds your site in `_site`. You can then serve this directory however you see fit – use the `file://`
protocol in your browser or a simple server like `python3 -m http.server`.

Things I may or may not do:
  * templates, or at least a bit more customization
  * github pages serving (DONE)
  * javascript (gasp) (DONE)
  * css (DONE)
  * tbd

   [1]: https://github.com/Perfect5th/perfect5th.github.io "Perfect5th's Personal Site Repo"
   [2]: https://daringfireball.net/projects/markdown/ "Daring Fireball Markdown Project Page"
   [demo site]: https://mitchellburton.ca/simple-site "Demo Site"
