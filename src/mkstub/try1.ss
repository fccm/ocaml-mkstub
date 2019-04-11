(struct "floatRect"
  (field "float" "left" ())
  (field "float" "top" ())
  (field "float" "width" ())
  (field "float" "height" ("ignore"))
)

(enum "blendMode"
  (e_val "BLENDMODE_NONE" 0)
  (e_val "BLENDMODE_BLEND" 1)
  (e_val "BLENDMODE_ADD" 2)
  (e_val "BLENDMODE_MOD" 4)
)

(fun "myfunc_blend" "int"
  ()
  (param "blendMode" "" ())
)

(fun "myfunc_st" "float"
  ()
  (param "floatRect" "" ())
)

(fun "myfunc_ii" "int"
  ()
  (param "int" "" ())
)

(fun "myfunc_arr" "int"
  ()
  (param "int" "n" ("len"))
  (param "PTR_int" "arr" ("len_p0"))
)

(fun "myfunc_wei" "void"
  ("export")
  (param "int" "p" ("in"))
  (param "PTR_int" "ret" ("out"))
)

(fun "myfunc_c" "int"
  ()
)

(fun "myfunc_add" "int"
  ()
  (param "int" "p1" ())
  (param "int" "p2" ())
)

(fun "myfunc" "void"
  ()
)

