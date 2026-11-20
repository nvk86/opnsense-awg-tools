#include "type.h"
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

bool u32_range_from_string(u32_range_t *range, const char *str) {
    uint32_t bounds[2] = { 0, 0 };
    const char *p = str;

    if (!range || !p || !*p)
        return false;

    for (int part = 0; part < 2; ++part) {
        uint32_t number = 0;
        const char *start = p;

        while (*p >= '0' && *p <= '9') {
            uint32_t digit = (uint32_t)(*p - '0');

            if (number > (UINT32_MAX - digit) / 10)
                return false;

            number = number * 10 + digit;
            ++p;
        }

        if (p == start)
            return false;

        bounds[part] = number;

        if (part == 0 && *p == '-') {
            ++p;
            continue;
        }

        if (*p != '\0')
            return false;

        if (part == 0)
            bounds[1] = bounds[0];

        break;
    }

    if (bounds[0] > bounds[1])
        return false;

    *range = u32_range_init(bounds[0], bounds[1]);
    return true;
}

const char *u32_range_to_string(u32_range_t range) {
    static char buf[22];

    if (u32_range_lo(range) == u32_range_hi(range))
        sprintf(buf, "%u", u32_range_lo(range));
    else
        sprintf(buf, "%u-%u", u32_range_lo(range), u32_range_hi(range));

    return buf;
}

int u16_range_from_string(u16_range_t *range, const char *str) {
    unsigned long lo, hi;
    char *end;

    lo = strtoul(str, &end, 10);
    if (end == str || lo > UINT32_MAX)
        return false;

    if (*end) {
        if (*end != '-')
            return false;
        hi = strtoul(end + 1, &end, 10);
        if (*end || hi > UINT32_MAX || hi < lo)
            return false;
    } else {
        hi = lo;
    }

    *range = u16_range_init(lo, hi);
    return true;
}

const char *u16_range_to_string(u16_range_t range) {
    static char buf[12];

    if (u16_range_lo(range) == u16_range_hi(range))
        sprintf(buf, "%u", u16_range_lo(range));
    else
        sprintf(buf, "%u-%u", u16_range_lo(range), u16_range_hi(range));

    return buf;
}
