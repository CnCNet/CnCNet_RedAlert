/*
**	Command & Conquer Red Alert(tm)
**	Copyright 2025 Electronic Arts Inc.
**
**	This program is free software: you can redistribute it and/or modify
**	it under the terms of the GNU General Public License as published by
**	the Free Software Foundation, either version 3 of the License, or
**	(at your option) any later version.
**
**	This program is distributed in the hope that it will be useful,
**	but WITHOUT ANY WARRANTY; without even the implied warranty of
**	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**	GNU General Public License for more details.
**
**	You should have received a copy of the GNU General Public License
**	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "function.h"

extern "C" {
#include "soscomp.h"
#include "itable.cpp"
#include "dtable.cpp"


void sosCODECInitStream(_SOS_COMPRESS_INFO* info)
{
	info->dwSampleIndex = 0;
	info->dwPredicted = 0;
}


unsigned long sosCODECDecompressData(_SOS_COMPRESS_INFO* info, unsigned long numbytes)
{
	unsigned long token;
	long sample;
	unsigned int fastindex;
	unsigned char *inbuff;
	unsigned short *outbuff;

	inbuff = (unsigned char *)info->lpSource;
	outbuff = (unsigned short *)info->lpDest;

	// Preload variables before the big loop
	fastindex = (unsigned int)info->dwSampleIndex;
	sample = info->dwPredicted;

	if (!numbytes)
		goto SkipLoop;

	do {
		// First nibble
		token = *inbuff++;
		fastindex += token & 0x0f;
		sample += DiffTable[fastindex];
		fastindex = IndexTable[fastindex];
		if (sample > 32767L)
			sample = 32767L;
		if (sample < -32768L)
			sample = -32768L;
		*outbuff++ = (unsigned short)sample;

		// Second nibble
		fastindex += token >> 4;
		sample += DiffTable[fastindex];
		fastindex = IndexTable[fastindex];
		if (sample > 32767L)
			sample = 32767L;
		if (sample < -32768L)
			sample = -32768L;
		*outbuff++ = (unsigned short)sample;
	} while(--numbytes);

SkipLoop:

	// Put local vars back
	info->dwSampleIndex = (unsigned long)fastindex;
	info->dwPredicted = sample;
	return(numbytes << 2);
}

}
