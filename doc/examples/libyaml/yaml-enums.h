
/** The stream encoding. */
typedef enum {
    /** Let the parser choose the encoding. */
    YAML_ANY_ENCODING,
    /** The default UTF-8 encoding. */
    YAML_UTF8_ENCODING,
    /** The UTF-16-LE encoding with BOM. */
    YAML_UTF16LE_ENCODING,
    /** The UTF-16-BE encoding with BOM. */
    YAML_UTF16BE_ENCODING
} yaml_encoding_t;

/** Line break types. */

typedef enum {
    /** Let the parser choose the break type. */
    YAML_ANY_BREAK,
    /** Use CR for line breaks (Mac style). */
    YAML_CR_BREAK,
    /** Use LN for line breaks (Unix style). */
    YAML_LN_BREAK,
    /** Use CR LN for line breaks (DOS style). */
    YAML_CRLN_BREAK
} yaml_break_t;

/** Many bad things could happen with the parser and emitter. */
typedef enum {
    /** No error is produced. */
    YAML_NO_ERROR,

    /** Cannot allocate or reallocate a block of memory. */
    YAML_MEMORY_ERROR,

    /** Cannot read or decode the input stream. */
    YAML_READER_ERROR,
    /** Cannot scan the input stream. */
    YAML_SCANNER_ERROR,
    /** Cannot parse the input stream. */
    YAML_PARSER_ERROR,
    /** Cannot compose a YAML document. */
    YAML_COMPOSER_ERROR,

    /** Cannot write to the output stream. */
    YAML_WRITER_ERROR,
    /** Cannot emit a YAML stream. */
    YAML_EMITTER_ERROR
} yaml_error_type_t;

/** Scalar styles. */
typedef enum {
    /** Let the emitter choose the style. */
    YAML_ANY_SCALAR_STYLE,

    /** The plain scalar style. */
    YAML_PLAIN_SCALAR_STYLE,

    /** The single-quoted scalar style. */
    YAML_SINGLE_QUOTED_SCALAR_STYLE,
    /** The double-quoted scalar style. */
    YAML_DOUBLE_QUOTED_SCALAR_STYLE,

    /** The literal scalar style. */
    YAML_LITERAL_SCALAR_STYLE,
    /** The folded scalar style. */
    YAML_FOLDED_SCALAR_STYLE
} yaml_scalar_style_t;

/** Sequence styles. */
typedef enum {
    /** Let the emitter choose the style. */
    YAML_ANY_SEQUENCE_STYLE,

    /** The block sequence style. */
    YAML_BLOCK_SEQUENCE_STYLE,
    /** The flow sequence style. */
    YAML_FLOW_SEQUENCE_STYLE
} yaml_sequence_style_t;

/** Mapping styles. */
typedef enum {
    /** Let the emitter choose the style. */
    YAML_ANY_MAPPING_STYLE,

    /** The block mapping style. */
    YAML_BLOCK_MAPPING_STYLE,
    /** The flow mapping style. */
    YAML_FLOW_MAPPING_STYLE
/*    YAML_FLOW_SET_MAPPING_STYLE   */
} yaml_mapping_style_t;

/** @} */

/**
 * @defgroup tokens Tokens
 * @{
 */

/** Token types. */
typedef enum {
    /** An empty token. */
    YAML_NO_TOKEN,

    /** A STREAM-START token. */
    YAML_STREAM_START_TOKEN,
    /** A STREAM-END token. */
    YAML_STREAM_END_TOKEN,

    /** A VERSION-DIRECTIVE token. */
    YAML_VERSION_DIRECTIVE_TOKEN,
    /** A TAG-DIRECTIVE token. */
    YAML_TAG_DIRECTIVE_TOKEN,
    /** A DOCUMENT-START token. */
    YAML_DOCUMENT_START_TOKEN,
    /** A DOCUMENT-END token. */
    YAML_DOCUMENT_END_TOKEN,

    /** A BLOCK-SEQUENCE-START token. */
    YAML_BLOCK_SEQUENCE_START_TOKEN,
    /** A BLOCK-SEQUENCE-END token. */
    YAML_BLOCK_MAPPING_START_TOKEN,
    /** A BLOCK-END token. */
    YAML_BLOCK_END_TOKEN,

    /** A FLOW-SEQUENCE-START token. */
    YAML_FLOW_SEQUENCE_START_TOKEN,
    /** A FLOW-SEQUENCE-END token. */
    YAML_FLOW_SEQUENCE_END_TOKEN,
    /** A FLOW-MAPPING-START token. */
    YAML_FLOW_MAPPING_START_TOKEN,
    /** A FLOW-MAPPING-END token. */
    YAML_FLOW_MAPPING_END_TOKEN,

    /** A BLOCK-ENTRY token. */
    YAML_BLOCK_ENTRY_TOKEN,
    /** A FLOW-ENTRY token. */
    YAML_FLOW_ENTRY_TOKEN,
    /** A KEY token. */
    YAML_KEY_TOKEN,
    /** A VALUE token. */
    YAML_VALUE_TOKEN,

    /** An ALIAS token. */
    YAML_ALIAS_TOKEN,
    /** An ANCHOR token. */
    YAML_ANCHOR_TOKEN,
    /** A TAG token. */
    YAML_TAG_TOKEN,
    /** A SCALAR token. */
    YAML_SCALAR_TOKEN
} yaml_token_type_t;

/** Event types. */
typedef enum {
    /** An empty event. */
    YAML_NO_EVENT,

    /** A STREAM-START event. */
    YAML_STREAM_START_EVENT,
    /** A STREAM-END event. */
    YAML_STREAM_END_EVENT,

    /** A DOCUMENT-START event. */
    YAML_DOCUMENT_START_EVENT,
    /** A DOCUMENT-END event. */
    YAML_DOCUMENT_END_EVENT,

    /** An ALIAS event. */
    YAML_ALIAS_EVENT,
    /** A SCALAR event. */
    YAML_SCALAR_EVENT,

    /** A SEQUENCE-START event. */
    YAML_SEQUENCE_START_EVENT,
    /** A SEQUENCE-END event. */
    YAML_SEQUENCE_END_EVENT,

    /** A MAPPING-START event. */
    YAML_MAPPING_START_EVENT,
    /** A MAPPING-END event. */
    YAML_MAPPING_END_EVENT
} yaml_event_type_t;

/** Node types. */
typedef enum {
    /** An empty node. */
    YAML_NO_NODE,

    /** A scalar node. */
    YAML_SCALAR_NODE,
    /** A sequence node. */
    YAML_SEQUENCE_NODE,
    /** A mapping node. */
    YAML_MAPPING_NODE
} yaml_node_type_t;

/**
 * The states of the parser.
 */
typedef enum {
    /** Expect STREAM-START. */
    YAML_PARSE_STREAM_START_STATE,
    /** Expect the beginning of an implicit document. */
    YAML_PARSE_IMPLICIT_DOCUMENT_START_STATE,
    /** Expect DOCUMENT-START. */
    YAML_PARSE_DOCUMENT_START_STATE,
    /** Expect the content of a document. */
    YAML_PARSE_DOCUMENT_CONTENT_STATE,
    /** Expect DOCUMENT-END. */
    YAML_PARSE_DOCUMENT_END_STATE,
    /** Expect a block node. */
    YAML_PARSE_BLOCK_NODE_STATE,
    /** Expect a block node or indentless sequence. */
    YAML_PARSE_BLOCK_NODE_OR_INDENTLESS_SEQUENCE_STATE,
    /** Expect a flow node. */
    YAML_PARSE_FLOW_NODE_STATE,
    /** Expect the first entry of a block sequence. */
    YAML_PARSE_BLOCK_SEQUENCE_FIRST_ENTRY_STATE,
    /** Expect an entry of a block sequence. */
    YAML_PARSE_BLOCK_SEQUENCE_ENTRY_STATE,
    /** Expect an entry of an indentless sequence. */
    YAML_PARSE_INDENTLESS_SEQUENCE_ENTRY_STATE,
    /** Expect the first key of a block mapping. */
    YAML_PARSE_BLOCK_MAPPING_FIRST_KEY_STATE,
    /** Expect a block mapping key. */
    YAML_PARSE_BLOCK_MAPPING_KEY_STATE,
    /** Expect a block mapping value. */
    YAML_PARSE_BLOCK_MAPPING_VALUE_STATE,
    /** Expect the first entry of a flow sequence. */
    YAML_PARSE_FLOW_SEQUENCE_FIRST_ENTRY_STATE,
    /** Expect an entry of a flow sequence. */
    YAML_PARSE_FLOW_SEQUENCE_ENTRY_STATE,
    /** Expect a key of an ordered mapping. */
    YAML_PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_KEY_STATE,
    /** Expect a value of an ordered mapping. */
    YAML_PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_VALUE_STATE,
    /** Expect the and of an ordered mapping entry. */
    YAML_PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_END_STATE,
    /** Expect the first key of a flow mapping. */
    YAML_PARSE_FLOW_MAPPING_FIRST_KEY_STATE,
    /** Expect a key of a flow mapping. */
    YAML_PARSE_FLOW_MAPPING_KEY_STATE,
    /** Expect a value of a flow mapping. */
    YAML_PARSE_FLOW_MAPPING_VALUE_STATE,
    /** Expect an empty value of a flow mapping. */
    YAML_PARSE_FLOW_MAPPING_EMPTY_VALUE_STATE,
    /** Expect nothing. */
    YAML_PARSE_END_STATE
} yaml_parser_state_t;

/** The emitter states. */
typedef enum {
    /** Expect STREAM-START. */
    YAML_EMIT_STREAM_START_STATE,
    /** Expect the first DOCUMENT-START or STREAM-END. */
    YAML_EMIT_FIRST_DOCUMENT_START_STATE,
    /** Expect DOCUMENT-START or STREAM-END. */
    YAML_EMIT_DOCUMENT_START_STATE,
    /** Expect the content of a document. */
    YAML_EMIT_DOCUMENT_CONTENT_STATE,
    /** Expect DOCUMENT-END. */
    YAML_EMIT_DOCUMENT_END_STATE,
    /** Expect the first item of a flow sequence. */
    YAML_EMIT_FLOW_SEQUENCE_FIRST_ITEM_STATE,
    /** Expect an item of a flow sequence. */
    YAML_EMIT_FLOW_SEQUENCE_ITEM_STATE,
    /** Expect the first key of a flow mapping. */
    YAML_EMIT_FLOW_MAPPING_FIRST_KEY_STATE,
    /** Expect a key of a flow mapping. */
    YAML_EMIT_FLOW_MAPPING_KEY_STATE,
    /** Expect a value for a simple key of a flow mapping. */
    YAML_EMIT_FLOW_MAPPING_SIMPLE_VALUE_STATE,
    /** Expect a value of a flow mapping. */
    YAML_EMIT_FLOW_MAPPING_VALUE_STATE,
    /** Expect the first item of a block sequence. */
    YAML_EMIT_BLOCK_SEQUENCE_FIRST_ITEM_STATE,
    /** Expect an item of a block sequence. */
    YAML_EMIT_BLOCK_SEQUENCE_ITEM_STATE,
    /** Expect the first key of a block mapping. */
    YAML_EMIT_BLOCK_MAPPING_FIRST_KEY_STATE,
    /** Expect the key of a block mapping. */
    YAML_EMIT_BLOCK_MAPPING_KEY_STATE,
    /** Expect a value for a simple key of a block mapping. */
    YAML_EMIT_BLOCK_MAPPING_SIMPLE_VALUE_STATE,
    /** Expect a value of a block mapping. */
    YAML_EMIT_BLOCK_MAPPING_VALUE_STATE,
    /** Expect nothing. */
    YAML_EMIT_END_STATE
} yaml_emitter_state_t;

