;; extends

;; -------------------------------------
;; Brackets with the color of its parent
;; -------------------------------------

; Structs, Enums and Traits
(struct_item body: (field_declaration_list ["{" "}"] @keyword))
(enum_item body: (enum_variant_list ["{" "}"] @keyword))
(trait_item body: (declaration_list ["{" "}"] @keyword))

; Functions
(function_item body: (block ["{" "}"] @keyword.function))
(impl_item body: (declaration_list ["{" "}"] @keyword))

; Conditions
(if_expression consequence: (block ["{" "}"] @conditional))
(if_expression alternative: (else_clause (block ["{" "}"] @conditional)))

; (if_expression
;   consequence: (block ["{" "}"] @conditional)
;   alternative: (else_clause (block ["{" "}"] @conditional))
; )

(match_block ["{" "}"] @conditional)

; Loops
(for_expression   body: (block ["{" "}"] @repeat))
(while_expression body: (block ["{" "}"] @repeat))
(loop_expression  body: (block ["{" "}"] @repeat))

;; ----------------------
;; Pretty type anotations
;; ----------------------

; Brackets
(type_arguments ["<" ">"] @punctuation.types)
(type_parameters ["<" ">"] @punctuation.types)

; Traits
(trait_item name: (type_identifier) @type.interface)
(trait_bounds ((type_identifier) @type.interface))
(trait_bounds
  (generic_type type: (type_identifier) @type.interface)
)

;; ---------------------
;; Urwraps ane dangerous
;; ---------------------

((field_identifier) @danger (#any-of? @danger "unwrap" "expect"))
