# CDB Mark I, museum copy

A click-around copy of BEST Zagreb's first company database ("baza kompanija"), a Ruby on Rails 3.0 application written in 2010 and used until it was replaced by [CDB-Mark-I-v2](https://github.com/BEST-Zagreb/CDB-Mark-I-v2) in 2025.

**Every record in here is invented.** The companies, people, projects and collaborations were generated from word lists so the screens look populated; e-mail addresses are on example.com and phone numbers are 555 numbers. The real data lives in the current company database and was never part of this copy.

## What works

Browsing: the project list, each project's collaboration table with its fundraising bar, the company list, company pages with their contacts, and all the new and edit forms as they looked. Column sorting works because it always ran in the browser.

## What does not

It is static HTML, so nothing can be saved. Submitting a form does nothing, delete links go nowhere, and the "Pretraživanje" filter on a project page has no effect. The original required a login; this copy does not need one because there is nothing to protect.

## How it was made

The archived source in the private `CDB-Mark-I` repository was run in a container on Ruby 1.9.3 with a generated SQLite database, crawled with wget, and relinked. Three things were changed on purpose: the fundraising bar used Google's Chart API, which shut down in 2019, and is now drawn inline with the same size and colours; the sort arrows are loaded relative to the page instead of from the server root; and write actions were disarmed as described above. Everything else is the original markup, stylesheets and scripts.
