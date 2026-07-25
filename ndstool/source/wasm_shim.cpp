// wasm_shim.cpp — (1) supply the missing `uniquefilename` definition,
//                 (2) expose a global-state reset so one WASM instance can
//                     service multiple callMain() invocations.
#include "ndstool.h"
#include <string.h>

// ndstool.h declares this extern but ndstool.cpp has the definition
// commented out -> link error without this.
char *uniquefilename = 0;

// Defined in ndscreate.cpp, never declared in the public header.
extern unsigned int overlay_files;

extern "C" void ndstool_reset(void)
{
    verbose = 0;
    memset(&header, 0, sizeof(header));
    fNDS = 0;

    romlistfilename = 0;
    for (int i = 0; i < MAX_FILEMASKS; i++) filemasks[i] = 0;
    filemask_num = 0;

    ndsfilename          = 0;
    arm7filename         = 0;
    arm9filename         = 0;
    filerootdir          = 0;
    overlaydir           = 0;
    arm7ovltablefilename = 0;
    arm9ovltablefilename = 0;
    bannerfilename       = 0;
    bannertext           = 0;
    headerfilename_or_size = 0;
    uniquefilename       = 0;
    logofilename         = 0;
    title                = 0;
    makercode            = 0;
    gamecode             = 0;

    bannertype = 0;
    bannersize = 0x840;
    latency1   = 0x1FFF;
    latency2   = 0x3F;
    romversion = 0;

    arm9RamAddress = 0;
    arm7RamAddress = 0;
    arm9Entry      = 0;
    arm7Entry      = 0;

    titleidHigh           = 0x00030000;
    scfgExtMask           = 0x80040407;
    accessControl         = 0x00000138;
    mbkArm7WramMapAddress = 0;
    appFlags              = 0x01;
    deviceListRamAddress  = 0x03800000;

    // these are the ones that silently accumulate across runs
    overlay_files   = 0;
    file_end        = 0;
    free_dir_id     = 0xF000;
    directory_count = 0;
    file_count      = 0;
    total_name_size = 0;
    free_file_id    = 0;
    _entry_start    = 0;
    file_top        = 0;

    overlay_fat_entries.clear();
}
