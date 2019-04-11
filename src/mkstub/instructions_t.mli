(** Instructions

Basically an instruction is like:
Target = Instructions

More precisely an instruction has the form:

REFTAG:element_name = do_something()
REFTAG:parent_element_name:element_name = do_something(); do_something_else()

REFTAG indicates the kind of element this instruction refers to.

Existing REFTAG's are:
- STRUCT: give instructions for wrapping a C struct
- ENUM: give instructions for wrapping a C enum
- FUNC: give instructions for wrapping a function
- PARAM: give instructions for the parameter of a function
- TYPE: give instructions for translating a given type
- TEST: make some unit tests on the resulting bindings

A target may contain zero, one or more instructions
(separated with ';').
*)

type instruction_ref =
  | ENUM_name of string
  | ENUM_val of (string * string)

  | STRUCT_name of string
  | STRUCT_field of (string * string)

  | FUNC of string
  | PARAM of (string * string)

  | TYPE of string

  | TEST of (string * string)

type instruction_content = string * string list

type instruction =
  instruction_ref * instruction_content list

