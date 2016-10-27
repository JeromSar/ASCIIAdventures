#include <iostream>
#include <stdio.h>
#include "bass.h"

using std::cout;
using std::endl;

int main() {
	if (!BASS_Init(-1,44100,0,0,NULL)) {
		cout << "Can't initialize device";
	}

	HSAMPLE sam;
	if (sam=BASS_SampleLoad(FALSE,"clank.mp3",0,0,3,BASS_SAMPLE_OVER_POS))
		cout << "sample " << "clank.mp3" << " loaded!" << endl;
	else
	{
		cout << "Can't load sample";
	}

	HCHANNEL ch = BASS_SampleGetChannel(sam, FALSE);
	BASS_ChannelSetAttribute(ch, BASS_ATTRIB_MUSIC_VOL_GLOBAL, 64);
	BASS_ChannelSetAttribute(ch, BASS_ATTRIB_MUSIC_VOL_CHAN, 64);
	BASS_ChannelSetDevice(ch, 2);
	//BASS_ChannelSetAttributes(ch,-1,50,(rand()%201)-100);

	getchar();

	if (!BASS_ChannelPlay(ch,FALSE)) {
		cout << "Can't play sample" << endl;
	}

	getchar();

}
