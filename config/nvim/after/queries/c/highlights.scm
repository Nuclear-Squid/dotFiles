;; extends

;; --------------------------------------
;; Because Treesitter-c is fucking stupid
;; --------------------------------------
((field_identifier) @property (#set! "priority" 150))

; Kind of a hack
; (parameter_declaration declarator: (pointer_declarator) @parameter.reference (#set! "priority" 150))


;; -------------------------------------
;; Brackets with the color of its parent
;; -------------------------------------

; Sructs and Enums
(enum_specifier body: (enumerator_list ["{" "}"] @keyword))
(struct_specifier body: (field_declaration_list ["{" "}"] @keyword))

; Conditions
(if_statement consequence: (compound_statement ["{" "}"] @conditional))
(if_statement alternative: (else_clause (compound_statement ["{" "}"] @conditional)))

; Loops
(for_statement body: (compound_statement ["{" "}"] @repeat))
(while_statement body: (compound_statement ["{" "}"] @repeat))

; Functions (declared using return type, `{}` use `type` group)
(function_definition body: (compound_statement ["{" "}"] @type))

