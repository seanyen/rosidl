@# Included from rosidl_generator_c/resource/idl__bounds.h.em
@{
from rosidl_parser.definition import Array
from rosidl_parser.definition import BasicType
from rosidl_parser.definition import BaseString
from rosidl_parser.definition import NamespacedType
from rosidl_parser.definition import NestedType
from rosidl_parser.definition import Sequence
from rosidl_parser.definition import UnboundedSequence
from rosidl_parser.definition import String
from rosidl_parser.definition import WString
from rosidl_generator_c import basetype_to_c
from rosidl_generator_c import idl_structure_type_sequence_to_c_typename
from rosidl_generator_c import idl_structure_type_to_c_include_prefix
from rosidl_generator_c import idl_structure_type_to_c_typename
from rosidl_generator_c import idl_type_to_c
from rosidl_generator_c import interface_path_to_string
from rosidl_generator_c import value_to_c

message_typename = idl_structure_type_to_c_typename(message.structure.type)
array_typename = idl_structure_type_sequence_to_c_typename(
    message.structure.type)
}@

@#######################################################################
@# include message dependencies
@#######################################################################
@{
from collections import OrderedDict
includes = OrderedDict()
for member in message.structure.members:
    if isinstance(member.type, BasicType):
        if isinstance(member.type, String) or isinstance(member.type, WString):
            member_names = includes.setdefault('rosidl_generator_c/string_bounds.h', [])
            member_names.append(member.name)
}@
@
@[if includes]@

// include message dependencies
@[  for header_file, field_names in includes.items()]@
@[        for member_name in member_names]@
// Member `@(member_name)`
@[        end for]@
@[        if header_file in include_directives]@
// already included above
// @
@[        else]@
@{include_directives.add(header_file)}@
@[        end if]@
#include "@(header_file)"
@[    end for]@
@[end if]@
@

@#######################################################################
@# Struct of message bounds
@#######################################################################
/// Struct of message bounds @(message_typename)
typedef struct @(message_typename)__bounds
{
@[for member in message.structure.members]@
@[ if isinstance(member.type, UnboundedSequence)]@
@[  if isinstance(member.type.basetype, String)]@
  size_t @(member.name)__length;
  rosidl_generator_c__String__bounds @(member.name)__bounds;
@[  elif isinstance(member.type.basetype, BasicType)]@
  size_t @(member.name)__length;
@[  else]@
  size_t @(member.name)__length;
  @('%s__bounds' % (message_typename)) @(member.name)__bounds;
@[  end if]@
@[ end if]@
@[end for]@
} @(message_typename)__bounds;
