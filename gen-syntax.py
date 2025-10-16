# to run the script, cd into the repo and run kitty +launch gen-syntax.py
# debugging:
#   print actions:
#     kitty +runpy 'from kitty.actions import get_all_actions; actions =
#     sorted(list({a.name for _, act_list in get_all_actions().items() for a in
#     act_list})); print(actions)'
#
#   print options:
#     kitty +runpy 'from kitty.config import
#     option_names_for_completion;all_opts =
#     sorted(list(set(option_names_for_completion()))); print(all_opts)'

from kitty.actions import get_all_actions
from kitty.config import option_names_for_completion

all_opts = sorted(list(set(option_names_for_completion())))
all_actions = sorted(list({
  a.name for _, act_list in get_all_actions().items() for a in act_list
}))


def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

kittyKeyword = ['syn keyword kittyKeyword contained\n'] + [
    " \\ " + " ".join(i) + "\n" for i in chunks(all_opts, 8)
    ]

kittyAction = ['syn keyword kittyAction contained\n'] + [
    " \\ " + " ".join(i) + "\n" for i in chunks(all_actions, 8)
    ]
    
with open("syntax/kitty.vim") as f:
  infile = list(f)

non_generated = infile.index('" START GENERATED CODE\n') + 1
updated_file = infile[0:non_generated] + kittyKeyword + kittyAction

with open("syntax/kitty.vim", 'w') as f:
  f.writelines(updated_file)
