# Fig: A configuration "framework"

## Philosophy

Fig was born out of frustration with heavyweight frameworks like [Ansible](https://github.com/ansible/ansible) that involve a huge dependency footprint and present a mere illusion of "declarative" configuration around something that is an inherently imperative/procedural process.

### On Ansible's size

At the time of writing, a `git clone --recursive https://github.com/ansible/ansible.git` creates a 224 megabyte directory containing 4,697 files. This is in addition to the Python language runtime itself and the additional modules and [supporting infrastructure](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) that may be involved, such as [pip](pip) and [virtualenv](https://virtualenv.pypa.io/).

[pip]: https://en.wikipedia.org/wiki/Pip_(package_manager)

### On Ansible's "declarative" configuration

Ansible configuration exists in YAML files which look static but are deceptively dynamic: values in these files get parsed as static values, Python expressions, or Jinja2 templates that may themselves contain Jinja2 filters and Python snippets. This mish-mash of conceptual models leads to awkward syntax that requires careful quoting and a constant mental effort to separate each of the three layers (static YAML, Jinja2 interpolation/filtering, and Python evaluation).

For example, consider [this configuration that moves items into a `~/.backups` directory](https://github.com/wincent/wincent/blob/f080ecb98d2f762c7314864c2247e75036ebc81a/roles/dotfiles/tasks/main.yml#L39-L48):

```yaml
- name: dotfiles | backup originals
  command: mv ~/{{ item.0 }} ~/.backups/
      creates=~/.backups/{{ item.0 }}
      removes=~/{{ item.0 }}
  loop: '{{ (dotfile_files + dotfile_templates) | zip(original_check.results) | list }}'
  when: item.1.stat.exists and not item.1.stat.islnk
  loop_control:
      label: '{{item.0}}'
```

Note:

-   The context-dependent need to quote Jinja2 syntax interpolation (`{{ ... }}`) in some places but not others, due to conflict with YAML syntax rules.
-   Undifferentiated mixing of Python evaluation (eg. list concatenation with `+`) and Jinja2 filtering/transformtion (eg. `| zip` and `| list`) in a single value.
-   Awkward encoding of imperative programming patterns using YAML keys (eg. `loop` and `loop_control` to describe a loop; `when` to describe a conditional).
-   Context-specific embedding of Python expressions (eg. raw Python code being passed as a string in the `when` property, but elsewhere being interpolated in Jinja2 interpolation).
-   Implicit/magical variable naming conventions (eg. use of `loop` implies the existence of an `item` variable).
-   No obvious scoping rules eg. variables like `dotfile_files` and `dotfile_templates` are magically available with no obvious source (they are defined [in another file](https://github.com/wincent/wincent/blob/f080ecb98d2f762c7314864c2247e75036ebc81a/roles/dotfiles/defaults/main.yml#L2-L45)); others like `original_check` are also magically available, but [defined in a prior task](https://github.com/wincent/wincent/blob/f080ecb98d2f762c7314864c2247e75036ebc81a/roles/dotfiles/tasks/main.yml#L30)).

Given all this convolution, Fig proposes that it is simpler to just embody this imperative, procedural work in an actual programming language. By using [TypeScript](https://www.typescriptlang.org/), we can obtain a comparable (or superior) level of static verification to what we would get with Ansible's YAML, as well as enjoying the benefits that come with using a "real" programming language in terms of tooling (eg. editor autocompletion, code formatting etc). By providing a [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) (Domain-specific language) (eg. implemented in [Fig's DSL](https://github.com/wincent/wincent/tree/master/fig/dsl)), we can conserve and arguably improve on the ergonomic properties of writing Ansible's YAML.

## Overall structure

-   Configuration is divided into ["aspects"](../aspects) that contain:
    -   A TypeScript `index.ts` that defines tasks to be executed.
    -   An `aspect.json` file contain metadata, such as a `description` and (optional) `variables`.
    -   An (optional) `files` directory containing resources to be copied or otherwise manipulated.
    -   An (optional) `templates` directory containing templates to be dynamically generated (and then copied, installed etc).
    -   An (optional) `support` directory to contain any other useful resources (eg. helper scripts etc).
-   The Fig source itself lives in [the `fig` directory](https://github.com/wincent/wincent/tree/master/fig).
-   All interaction occurs via [the top-level `install` script](https://github.com/wincent/wincent/blob/master/install), which invokes Fig via a set of helper scripts [in the `bin` directory](https://github.com/wincent/wincent/tree/master/bin).

## Variables

Because Fig tasks are defined using TypeScript, you can define and use variables just like you would in any TypeScript program. As built-in language features, these follow the lexical scoping rules that you would expect to apply to `const` and `let`.

Additionally, there is a higher-level representation of variables that can be accessed by the DSL. This enables variables to be defined at various levels of abstraction (for example, as a project-wide default, or an aspect-specific one), with a well-defined precedence that ensures that the "most local" definition wins. Variable access is always explict, either by a call to to [the `variable()` API](https://github.com/wincent/wincent/blob/827d5d75d5213414e54b858e89c6e624d22d1e21/fig/dsl/variable.ts) (eg. [example from the "dotfiles" aspect](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/aspects/dotfiles/index.ts#L25)), or by accessing the `variables` object from inside templates (eg. [example from the "launchd" aspect](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/aspects/launchd/templates/run.plist.erb#L6-L12)).

The levels are, from lowest to highest precedence:

| Kind             | Description                                                                                                                                                                                                                                                                                                                                                                                |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Base             | Currently just one of these, `profile`, which is set to either `'personal'`, `'work'` or `null`                                                                                                                                                                                                                                                                                            |
| Attributes       | Derived from system using [the `Attributes` class](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/fig/Attributes.ts) (eg. `home`, `platform`, `username`)                                                                                                                                                                                                |
| Defaults         | Defined in the [top-level project.json](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json) [here](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json#L44-L78)                                                                                                                                       |
| Profile          | Defined in the [top-level project.json](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json) for each profile (eg. [personal](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json#L35-L37), [work](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json#L41)) |
| Platform         | Defined in the [top-level project.json](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json) for each platform (eg. [darwin](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json#L23), [linux](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/project.json#L27-L29)) |
| Dynamic          | Calculated [in `variables.ts` at the top-level](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/variables.ts) (eg. `identity`)                                                                                                                                                                                                                            |
| Aspect (static)  | Defined in `aspects/*/aspect.json` files (eg. [`aspects/dotfiles/aspect.json`](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/aspects/dotfiles/aspect.json#L3-L37))                                                                                                                                                                                      |
| Aspect (derived) | Derived using [the `variables()` API](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/fig/dsl/variables.ts) (eg. [dotfiles `variables()` example](https://github.com/wincent/wincent/blob/796ee1c02ad257fd565569ab6082b7685a52b83f/aspects/dotfiles/index.ts#L18-L22))                                                                                    |

Most of these are static, arising from JSON files, but two of the later levels ("Dynamic" and "Aspect (derived)") proved the means to dynamically set or derive the value of a variable at runtime.

### How this repo works

0. **2009**: Originally, the repo was just a [collection of files](https://github.com/wincent/wincent/tree/61a7e2a830edb757c59e542039131e671da8b154) with no installation script.
1. **2011-2015**: I [created a `bootstrap.rb` script](https://github.com/wincent/wincent/commit/e29b2818c487529eb4e7662a23df56445b448fe3) ([final version here](https://github.com/wincent/wincent/blob/94fb4d50243b97cd0c92a5691ac430353a5299a0/bootstrap.rb)) for performing set-up.
1. **2015**: I [briefly experimented](https://github.com/wincent/wincent/commit/4efdb1f97685bf735b068835adced059cd721096) with using a `Makefile` ([final version here](https://github.com/wincent/wincent/blob/01b37a546b92f60e659a8153067353d58805a009/Makefile)).
1. **2015-2020**: I [switched to Ansible](https://github.com/wincent/wincent/commit/375f27a6ea6fdd78fcf6614d3af5335da7a9f5ef) (completing the transition in [cd98e9aaab](https://github.com/wincent/wincent/commit/cd98e9aaab82b1983aeab839d4f28260d6e19919)).
1. **2020-present**: I started [feeling misgivings about the size of the dependency graph](https://github.com/wincent/wincent/issues/82) and in truth I was probably using less than 1% of Ansible's functionality, so moved to the current set-up, which is described below.

The goal was to replace Ansible with some handmade scripts using the smallest dependency graph possible. I original [tried](https://github.com/wincent/wincent/commit/8809a1681cfd8fd02eb40113d2485d7cadc10e4c) out [Deno](https://deno.land/) because that would enable me to use TypeScript with no dependencies outside of Deno itself, however I [gave up on that](https://github.com/wincent/wincent/commit/a213ddf69d3213882808b5c5ff0e000bcd83fe98) when I saw that editor integration was still very nascent. So I went with the following:

-   [n](https://github.com/tj/n) ([as a submodule](https://github.com/wincent/wincent/tree/master/vendor)) and some [hand-rolled Bash scripts](https://github.com/wincent/wincent/tree/master/bin) to replace [virtualenv](https://virtualenv.pypa.io/) and friends ([Python](https://www.python.org/), [pip](https://pypi.org/project/pip/)).
-   [Yarn](https://github.com/yarnpkg/yarn/) ([vendored](https://github.com/wincent/wincent/commit/26adf86d4c742390537be4dc1572f93a97bc3e68)) to install [TypeScript](https://www.typescriptlang.org/).

Beyond that, there are no dependencies outside of the [Node.js](https://nodejs.org/en/) standard library. I use [Prettier](https://prettier.io/) to format code, but I invoke it via `npx` which means the [yarn.lock](https://github.com/wincent/wincent/blob/master/yarn.lock) remains basically empty. Ansible itself is replaced by [a set of self-contained TypeScript scripts](https://github.com/wincent/wincent/tree/master/fig). Instead of YAML configuration files containing "declarative" configuration peppered with Jinja template snippets containing Python and filters, we just use TypeScript for everything. Instead of [Jinja template files](https://jinja.palletsprojects.com/), we use ERB/JSP-like templates that use embedded JavaScript when necessary.

Because I need a name to refer to this "set of scripts", it's called Fig (a play on "Config"). Overall structure remains similar to Ansible, but I made some changes to better reflect the use case here. While Ansible is made to orchestrate multiple (likely remote) hosts, Fig is for configuring one local machine at a time.

| Ansible                                                                                                                         | Fig                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Hosts:** Machines to be configured (possibly remote)                                                                          | n/a (always the current, local machine)                                                                         |
| **Groups:** Collections of hosts, so you can conveniently target multiple hosts without having to address each one individually | **Profiles:** An abstract category indicating the kind of a host (eg. "work" or "personal")                     |
| **Inventory:** A list of hosts (or groups of hosts) to be managed                                                               | n/a ("project.json" file contains map from hostname to profile to be applied)                                   |
| **Roles:** Capabilities that a host can have (eg. webserver, file-server etc)                                                   | **Aspects:** Logical groups of functionality to be configured (eg. dotfiles, terminfo etc)                      |
| **Tasks:** Operations to perform (eg. installing a package, writing a file                                                      | **Tasks:** Same as Ansible.                                                                                     |
| **Plays:** A mapping between hosts (or groups) and the tasks to be performed on them                                            | n/a (it's just a file containing tasks)                                                                         |
| **Playbooks:** Lists of plays                                                                                                   | n/a ("project.json" file contains a map from platform to the aspects that should be set up on a given platform) |
| **Tags:** Keywords that can be applied to tasks and roles, useful for selecting them to be run                                  | n/a (not needed)                                                                                                |
| **Facts:** (Inferred) attributes of hosts                                                                                       | **Attributes:** Same as Ansible, but with a better name                                                         |
| **Vars:** (Declared) values that can be assigned to groups, hosts or roles                                                      | **Vars:** Same as Ansible, but belong to profiles and aspects                                                   |
| **Modules:** Units of code that implement operations (ie. these are what tasks use to actually do the work)                     | **Operations:** Code for performing operations                                                                  |
| **Templates:** Jinja templates with embedded Python and "filters"                                                               | **Templates:** ERB templates with embedded JavaScript                                                           |
| **Files:** Raw files that can be copied using modules                                                                           | **Files:** Raw files that can be copied using operations                                                        |
| **Syntax:** YAML with interpolated Jinja syntax containing Python and variables                                                 | **Syntax:** TypeScript and (plain) JSON                                                                         |
