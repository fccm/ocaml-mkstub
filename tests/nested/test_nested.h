#include <string.h>
#include <stdio.h>

union {
    struct {
        unsigned char *buffer;
        size_t size;
        size_t *size_written;
    } string;

    FILE *file;
} output;

typedef struct {
    unsigned int type;
    union {
        struct {
            char *value;
            size_t length;
        } scalar;
        struct {
            int major;
            int minor;
        } version;
    } data;
} token;
