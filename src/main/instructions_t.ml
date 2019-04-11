(** Instructions *)

(**
Basically an instruction is like:
  [Target = Operations]

More precisely an instruction has the form:

  [REFTAG:element_name = do_something()]
  [REFTAG:parent_name:element_name = do_something(); do_something_else()]

REFTAG indicates the kind of element this instruction refers to.

Existing REFTAG's are:
- STRUCT: give instructions for wrapping a C struct
- ENUM: give instructions for wrapping a C enum
- FUNC: give instructions for wrapping a function
- ARG: give instructions for an argument of a function
- TYPE: give instructions for translating a given type
- TEST: make some unit tests on the resulting bindings

A target may contain zero, one or more instructions
(separated with ';').

Examples: {[
ENUM:theEnumName = wrap_as_poly_var
ENUM:anotherEnum = wrap_as_variant
ENUM:someEnum:enumVal = ignore

STRUCT:stName = wrap_as_pointer
STRUCT:stName = finalizer_is(some_other_func)
STRUCT:someStc:someField = ignore

FUNC:bazFunc = ignore
FUNC:bazFunc = clear

ARG:someFunc:arg3 = default_value_is(42)
ARG:otherFunc:arg2 = is_bit_field
ARG:fooFunc:arg0 = is_optional_c(NULL)
ARG:fooFunc:arg1 = is_optional_ml(-1)
ARG:barFunc:arg2 = dont_wrap_put(0)

TYPE:someT = \
   ml_conv(map_t_func); \
   c_conv(conv_t_macro); \
   ml_name(some_t)

TEST:exFunc = args(2,3); return(5); label(tells)

TEST:barFunc:W = args(1,2); return(3)
TEST:barFunc:C = args(1,2,0); return(3)

TEST:barFunc = \
   w_args(1,2); \
   c_args(1,2,0); \
   return(3)
]}
*)

type target =
  | ENUM_name of string
  | ENUM_val of (string * string)

  | STRUCT_name of string
  | STRUCT_field of (string * string)

  | FUNC of string
  | ARG of (string * string)

  | TYPE of string

  | TEST of (string * string)

type operation = {
  op_name : string;
  op_args : string list;
}

type instruction =
  target * operation list
