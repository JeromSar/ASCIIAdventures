#include <stddef.h>
#include <stdio.h>
#include "bass.h"

void main () {
	HMUSIC hm;
	BASS_Init (-1, 44100, 0, 0, NULL);
	hm=BASS_MusicLoad(FALSE,"clank.mp3",0,0,BASS_SAMPLE_LOOP,0);
	BASS_ChannelPlay(hm,FALSE);

	getchar();
}
