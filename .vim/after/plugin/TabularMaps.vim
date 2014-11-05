if exists(':Tabularize')
  AddTabularPattern commas /,\zs
  AddTabularPattern hash /:\zs
  AddTabularPattern hash_rocket /=>
  AddTabularPattern json /:
  AddTabularPattern symbol /:/l1c0
  AddTabularPattern equals /=
endif
