easydir.vim
===========

A simple way to create, edit and save files and directories.

What does it do?
----------------

Ever wanted to save a file and create its parent directories at the same time?

Well, now you can!

Here are some examples:

* New directory and file...

```
:new new_directory/new_file.txt

# Write some stuff to new_file.txt

:w

# new_directory/ is now created
```

* Create child directories inside...

```
:e existing_directory/new_directory/new_file.txt
```

* Works with horizontal and vertical splits...

```
:sp new/directory/file.txt

:vsp another/new/directory/file.txt
```

Installation
------------

I highly recommend checking out Vundle or Pathogen for managing plugins.

* [Vundle](https://github.com/gmarik/vundle):

```
# ~/.vimrc

Plugin 'duggiefresh/vim-easydir'

# Then run ':PluginInstall'
```

* [Pathogen](https://github.com/tpope/vim-pathogen)

```
$ cd ~/.vim/bundle
$ git clone https://github.com/duggiefresh/vim-easydir.git
```

* [Vim Script](https://vim.sourceforge.io/scripts/script.php?script_id=4793)
