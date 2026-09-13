# CDB Mark I

BEST Zagreb's first company database ("baza kompanija"). A Ruby on Rails 3.0 application written in 2010, run behind a login at old.cdb.best.hr, and used until [CDB-Mark-I-v2](https://github.com/BEST-Zagreb/CDB-Mark-I-v2) replaced it in 2025. The current company database is at <https://cdb.best.hr/>.

This repository holds two things:

- the museum copy: static HTML at the repository root, live at <https://2010.cdb.best.hr/>, filled with invented data so you can click through the application as it looked;
- the source: the real application in `source/`, cleaned of logs, databases and credentials before publication.

Until 2026-09-13 the source sat in a private repository and the museum copy in this public one. They were merged so the code is not lost when nobody remembers the private repository exists.

## The museum copy

**Every record in here is invented.** The companies, people, projects and collaborations were generated from word lists so the screens look populated; e-mail addresses are on example.com and phone numbers are 555 numbers. The real data lives in the current company database and was never part of this copy.

### What works

Browsing: the project list, each project's collaboration table with its fundraising bar, the company list, company pages with their contacts, and all the new and edit forms as they looked. Column sorting works because it always ran in the browser.

### What does not

It is static HTML, so nothing can be saved. Submitting a form does nothing, delete links go nowhere, and the "Pretraživanje" filter on a project page has no effect. The original required a login; this copy does not need one because there is nothing to protect.

### How it was made

The source in `source/` was run in a container on Ruby 1.9.3 with a generated SQLite database, crawled with wget, and relinked. Three things were changed on purpose: the fundraising bar used Google's Chart API, which shut down in 2019, and is now drawn inline with the same size and colours; the sort arrows are loaded relative to the page instead of from the server root; and write actions were disarmed as described above. Everything else is the original markup, stylesheets and scripts.

## The source

`source/` is the application as it was archived in March 2021, minus what is listed under "Removed for publication" below. It contains:

- the Rails 3.0.10 application (`app/`, `config/`, `lib/`, `public/`, `deploy/`), with models written as DataMapper resources on SQLite;
- `app.rb` and `views/`, an earlier Sinatra version of the same database (`app.rb.bak` is the same file);
- `server/`, an empty Rails 2.3 skeleton with its vendored Rails, apparently a first attempt;
- `vendor/bundle`, the gems for Ruby 1.8 that the production server used, including a compiled `do_sqlite3` extension.

The application ran on Ruby Enterprise Edition 1.8.7 (2011.03). The two Ubuntu 10.04 installers used to be committed here; they are 39 MB together and the Google Code archive still serves the identical files, so they were dropped in favour of these links:

- [ruby-enterprise_1.8.7-2011.03_amd64_ubuntu10.04.deb](https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rubyenterpriseedition/ruby-enterprise_1.8.7-2011.03_amd64_ubuntu10.04.deb), sha256 `1c5f5d5ef1efb497ee9aec4b1ce6bc56803f7046c2d75d220c67ae786769cd62`
- [ruby-enterprise_1.8.7-2011.03_i386_ubuntu10.04.deb](https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rubyenterpriseedition/ruby-enterprise_1.8.7-2011.03_i386_ubuntu10.04.deb), sha256 `c9a78784f8915dd3e7e0ff7aa09685564f16b8e6c4e8faaf51a7898476b2a504`

### Before you run it

Two things are missing on purpose.

The database files are not included. The private repository's README listed four of them, kept outside git by the owner: `db/development.sqlite3` (2021-03), `db/development.sqlite3_backup` (2018-07), `development.sqlite3` (2011-05) and `development_backup.sqlite3` (2010-03). The application opens `db/development.sqlite3` (see `config/application.rb`). There are no migrations in `db/`; the tables come from the DataMapper models, so with a fresh database you have to create them with `DataMapper.auto_migrate!` first. That step was not tested during this merge.

The HTTP Basic credentials and the cookie secrets are placeholders. Search `source/` for `CHANGE_ME` and set your own in `app/controllers/application_controller.rb` and `config/initializers/secret_token.rb` (the Rails application), `app.rb` (Sinatra) and `server/config/initializers/` (the skeleton). Production refuses every request until the credentials match.

### Run it in Docker

These are the private repository's instructions from 2024, kept as they were. They use the official `ruby:1.9.3` image, whose Debian jessie repositories have to be pointed at archive.debian.org.

1. Put your database in `source/db/development.sqlite3` (or create an empty one as described above).
2. Create a `Dockerfile` in `source/` with the following:

```
FROM ruby:1.9.3

# Replace sources with Debian archive and fully remove references to http.debian.net and security.debian.org
RUN sed -i 's|http://deb.debian.org/debian/ jessie main|https://archive.debian.org/debian/ jessie main|' /etc/apt/sources.list && \
    sed -i '/http:\/\/http.debian.net\/debian/d' /etc/apt/sources.list && \
    sed -i '/http:\/\/security.debian.org/d' /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian-security jessie/updates main' >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive && \
    echo 'Acquire::AllowInsecureRepositories "true";' >> /etc/apt/apt.conf.d/99archive && \
    echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99archive && \
    apt-get -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true update && \
    apt-get -y -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true upgrade && \
    apt-get install -y --no-install-recommends sqlite3 libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /cdb

# Copy the application code
COPY . /cdb

# Install bundler 1.17.3, which is compatible with Ruby 1.9.3, and run bundle install
RUN gem install bundler -v 1.17.3 && bundle _1.17.3_ install

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
```

3. `cd source && sudo docker build -t cdb-mark-1 .`
4. `sudo docker run -p 3000:3000 cdb-mark-1`, then open <http://localhost:3000/> and log in with the credentials you set.

## Removed for publication

The private repository carried ten years of `log/production.log` (55 MB of request logs with the names, phone numbers and e-mail addresses of real contacts in the request parameters), two smaller logs, a 9 KB `views/development.sqlite3` with six real companies and five contacts from 2011, a hard-coded HTTP Basic username and password in three files, and the Rails session secrets. The logs and the database were dropped; the owner keeps the real database outside GitHub. The credentials and secrets were replaced by `CHANGE_ME` placeholders with a one-line comment at each spot. The private repository's history was not carried over, so none of this exists in any commit here; the source arrived in one commit.

## Hosting

Live at <https://2010.cdb.best.hr/>, served by Cloudflare Workers as static files straight from this repository. `source/` is listed in `.assetsignore`, so the Worker never serves it; the source is only on GitHub.
This repository is archived and read-only: the site it holds is finished. If something must change, unarchive it, push to `main`, and Workers Builds redeploys within a minute or two. Every page carries a museum notice and a noindex header, added at the edge by `banner.js`; the archived files themselves are untouched.

## Wayback Machine

The application ran at <https://old.cdb.best.hr/>. The Internet Archive's calendar for it is <https://web.archive.org/web/*/https://old.cdb.best.hr/*>.
Checked on 2026-09-11: the archive holds nothing for old.cdb.best.hr, and the four URLs it holds for cdb.best.hr are all 401 login walls. Nothing of the application was ever preserved there, and because the original sat behind a login no capture was requested.
This repository is therefore the only copy of what the application looked like; there is no second copy in the archive.
