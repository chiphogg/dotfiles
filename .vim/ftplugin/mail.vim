if !exists("no_plugin_maps") && !exists("no_mail_maps")
  set autoindent
  map <buffer> g{ ?^\(\s\\|>\)*$<CR>
  map <buffer> g} /^\(\s\\|>\)*$<CR>
  set expandtab
  set textwidth=72
endif
