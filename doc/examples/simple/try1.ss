(enum "blendMode"
  (e_val "BLENDMODE_MOD" 4)
  (e_val "BLENDMODE_ADD" 2)
  (e_val "BLENDMODE_BLEND" 1)
  (e_val "BLENDMODE_NONE" 0)
)

(struct "floatRect"
  (field "float" "left" ())
  (field "float" "top" ())
  (field "float" "width" ())
  (field "float" "height" ("ignore"))
)

(fun "myfunc" "void"
  ()
)

(fun "myfunc_add" "int"
  ()
  (param "int" "p2" ())
  (param "int" "p1" ())
)

(fun "myfunc_c" "int"
  ()
)

(fun "myfunc_wei" "void"
  ("export")
  (param "PTR_int" "ret" ("out"))
  (param "int" "p" ("in"))
)

(fun "myfunc_arr" "int"
  ()
  (param "PTR_int" "arr" ("len_p0"))
  (param "int" "n" ("len"))
)

(fun "myfunc_ii" "int"
  ()
  (param "int" "" ())
)

(fun "myfunc_io" "void"
  ()
  (param "PTR_int" "p" ("out" "in"))
)

(fun "myfunc_st" "float"
  ()
  (param "floatRect" "" ())
)

(fun "myfunc_blend" "int"
  ()
  (param "blendMode" "" ())
)

