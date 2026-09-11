# CDB Mark I, museum copy

A click-around copy of BEST Zagreb's first company database ("baza kompanija"), a Ruby on Rails 3.0 application written in 2010 and used until it was replaced by [CDB-Mark-I-v2](https://github.com/BEST-Zagreb/CDB-Mark-I-v2) in 2025.

**Every record in here is invented.** The companies, people, projects and collaborations were generated from word lists so the screens look populated; e-mail addresses are on example.com and phone numbers are 555 numbers. The real data lives in the current company database and was never part of this copy.

## What works

Browsing: the project list, each project's collaboration table with its fundraising bar, the company list, company pages with their contacts, and all the new and edit forms as they looked. Column sorting works because it always ran in the browser.

## What does not

It is static HTML, so nothing can be saved. Submitting a form does nothing, delete links go nowhere, and the "Pretraživanje" filter on a project page has no effect. The original required a login; this copy does not need one because there is nothing to protect.

## How it was made

The archived source in the private `CDB-Mark-I` repository was run in a container on Ruby 1.9.3 with a generated SQLite database, crawled with wget, and relinked. Three things were changed on purpose: the fundraising bar used Google's Chart API, which shut down in 2019, and is now drawn inline with the same size and colours; the sort arrows are loaded relative to the page instead of from the server root; and write actions were disarmed as described above. Everything else is the original markup, stylesheets and scripts.

## Hosting

Live at <https://cdb-2010.best.hr/>, served by Cloudflare Workers as static files straight from this repository.
This repository is archived and read-only: the site it holds is finished. If something must change, unarchive it, push to `main`, and Workers Builds redeploys within a minute or two. Every page carries a museum notice and a noindex header, added at the edge by `banner.js`; the archived files themselves are untouched.

## Wayback Machine

The application ran at <https://old.cdb.best.hr/>. The Internet Archive's calendar for it is <https://web.archive.org/web/*/https://old.cdb.best.hr/*>.
Checked on 2026-09-11: the archive holds nothing for old.cdb.best.hr, and the four URLs it holds for cdb.best.hr are all 401 login walls. Nothing of the application was ever preserved there, and because the original sat behind a login no capture was requested.
This repository is therefore the only copy of what the application looked like; there is no second copy in the archive.
