/* https://github.com/urob/zmk-config/blob/main/readme.md#timeless-homerow-mods */

/* use helper macros to define left and right hand keys */
/* #include "zmk-helpers/key-labels/36.h"                                      // key-position labels */
/* #define KEYS_L LT0 LT1 LT2 LT3 LT4 LM0 LM1 LM2 LM3 LM4 LB0 LB1 LB2 LB3 LB4  // left-hand keys */
/* #define KEYS_R RT0 RT1 RT2 RT3 RT4 RM0 RM1 RM2 RM3 RM4 RB0 RB1 RB2 RB3 RB4  // right-hand keys */
/* #define THUMBS LH2 LH1 LH0 RH0 RH1 RH2                                      // thumb keys */

#include "zmk-helpers/key-labels/sofle.h"		// key-position labels
#define KEYS_L LN5 LN4 LN3 LN2 LN1 LN0 LT5 LT4 LT3 LT2 LT1 LT0 LM5 LM4 LM3 LM2 LM1 LM0 LB5 LB4 LB3 LB2 LB1 LB0
#define KEYS_R RN5 RN4 RN3 RN2 RN1 RN0 RT5 RT4 RT3 RT2 RT1 RT0 RM5 RM4 RM3 RM2 RM1 RM0 RB5 RB4 RB3 RB2 RB1 RB0
#define THUMBS LH4 LH3 LH2 LH1 LH0 LH2 LH1 LH0 RH0 RH1 RH2 RH0 RH1 RH2 RH3 RH4

#include "zmk-helpers/helper.h"


/* left-hand HRMs */
ZMK_HOLD_TAP(hml,
    flavor = "balanced";
    tapping-term-ms = <280>;
    quick-tap-ms = <175>;                // repeat on tap-into-hold
    require-prior-idle-ms = <150>;
    bindings = <&kp>, <&kp>;
    hold-trigger-key-positions = <KEYS_R THUMBS>;
    hold-trigger-on-release;             // delay positional check until key-release
)

/* right-hand HRMs */
ZMK_HOLD_TAP(hmr,
    flavor = "balanced";
    tapping-term-ms = <280>;
    quick-tap-ms = <175>;                // repeat on tap-into-hold
    require-prior-idle-ms = <150>;
    bindings = <&kp>, <&kp>;
    hold-trigger-key-positions = <KEYS_L THUMBS>;
    hold-trigger-on-release;             // delay positional check until key-release
)

/* Caps-word, num-word and smart-mouse */

// tap: sticky-shift | shift + tap/ double-tap: caps-word | hold: shift
ZMK_MOD_MORPH(smart_shft,
    bindings = <&sk LSHFT>, <&caps_word>;
    mods = <(MOD_LSFT)>;
)
&caps_word {  // mods deactivate caps-word, requires PR #1451
    /delete-property/ ignore-modifiers;
};
