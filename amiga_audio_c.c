#include <exec/types.h>
#include <devices/audio.h>
#include <proto/exec.h>

static BYTE channels = 0;

int audio_open() { 
    return 1; 
}

void audio_close() { 
}

int audio_alloc(WORD ch) {
    channels |= ch;
    return 1;
}

void audio_free(WORD ch) {
    channels &= ~ch;
}

void audio_play(WORD ch, APTR data, ULONG len, UWORD period) {
    /* Stub minimo: requiere IORequest real para audio.device */
    /* Implementacion completa en version futura */
}
