# vim-ansible-yaml

### Maintainer wanted!
I don't have time to maintain this and haven't used Ansible in quite some time. If anyone would like to come in as a collaborater and maintain it, feel free to open up an issue!

*Also, if you feel like this bundle isn't quite what you'd want, check out [ansible-vim](https://github.com/pearofducks/ansible-vim) by @pearofducks!*

---

Adds additional syntax highlighting and fixes indentation for Ansible's dialect of YAML.

Allows a user-specified mapping in normal mode to search the ansible docs for the keyword underneath the current
cursor position. See below for configuration.

Ansible YAML files are detected based on the presence of a modeline or a
[structure following Ansible's Playbook Best Practices](http://docs.ansible.com/ansible/latest/playbooks_best_practices.html#directory-layout).
For details, see the Detection section below.

## Install

### Using [Vundle](https://github.com/gmarik/vundle)

1. Add the following to your `.vimrc` where other bundles are located:
       
		Bundle 'chase/vim-ansible-yaml'

2. Run from command line:

		$ vim +BundleInstall

### Using [pathogen](https://github.com/tpope/vim-pathogen)

1. Check out the repository into your bundle path:

        $ cd ~/.vim/bundle
        $ git clone git://github.com/chase/vim-ansible-yaml.git

2. Install the help file. (Repeat this step if you get an updated version.) From inside vim,

	:Helptags

### Normal

1. Check out the repository and copy the following to `.vim/` directory or any
   other run time path, keeping their directory structure intact:

		doc/ansible.txt
		ftdetect/ansible.vim
		syntax/ansible.vim
		syntax/include/jinja.vim
		syntax/include/yaml.vim
		indent/ansible.vim

2. Install the help file.  From inside vim,  `:helptags ~/.vim/doc`.

## Detection

You can tell vim to recognize a file as Ansible by adding a modeline near the top or bottom of the file:
```
# vim:ft=ansible:
```

A file is recognized as an Ansible YAML file, and its filetype is set to `ansible`, if

1. The file extension is `.yml` or `.yaml`
2. AND one of the following conditions holds:
  1. The file is somewhere under a directory named `roles`.
  2. The file is in the same directory as a directory (or file) named `group_vars`, `host_vars`, or `roles`.

## Configuration

All configuration options will live under `g:ansible_options`.

### ignore_blank_lines

If you define

    let g:ansible_options = {'ignore_blank_lines': 0}

in your vimrc file, then the indent function will remove all indent after a blank line. The default behavior is to ignore blank lines when calculating the indent of the current line. This is helpful if your style is to insert blank lines, as in

```
tasks:
  - name: Say hello.
    command: echo Hello, world.

  - name: Say good night, Dick.
    command: echo Good night, Dick.
```

If `g:ansible_options` is not defined, or if the `ignore_blank_lines` key is not present, or the value is not `0`, then the indent function uses the default behavior.

### documentation_mapping

The documentation_mapping option enables setting a custom mapping to search the Ansible documentation for the word under the cursor.

It can be enabled as such: `let g:ansible_options = {'documentation_mapping': '<C-K>'}` - which would bind Control-K to perform the search.

## Thanks
[Benji Fisher](https://github.com/benjifisher) helped out a great amount as a maintainer, thanks a ton!

A huge thanks to [Igor Vergeichik](mailto:iverg@mail.ru) and [Nikolai Weibull](https://github.com/now) for their work on the YAML syntax that this bundle uses.

Also, thank you, [Armin Ronacher](https://github.com/mitsuhiko), for the
simple and effective Jinja syntax file.
