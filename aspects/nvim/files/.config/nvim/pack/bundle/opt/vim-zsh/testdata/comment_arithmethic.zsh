function h(){
  (( # == 0 )) && cd ~ && return
  (( $# == 0 )) && cd ~ && return
  $(( #1 == 1 ))
}
