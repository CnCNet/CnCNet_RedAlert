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

#ifdef WOLAPI_INTEGRATION

/***************************************************************************
 * PassEditClass -- Derived from WOLEditClass, includes changes I wanted for
 *                 wolapi integration stuff.
 *					Note: An editbox of this class cannot be made read-only. See comment below.
 * HISTORY:    07/17/1998 ajw : Created.
 *=========================================================================*/

#include "PassEdit.h"

//***********************************************************************************************
void PassEditClass::Draw_Text( char const * text )
{
	//	Only difference between this and EditClass: cursor shows up when
	//	string is at MaxLength, and characters are replaced with '*'.

	TextPrintType flags;

	if (Has_Focus()) {
		flags = TPF_BRIGHT_COLOR;
	} else {
		flags = (TextPrintType)0;
	}
    
	int textlen = strlen(text);
	char *passbuf = new char[textlen + 1];
	memset(passbuf, '*', textlen);
	passbuf[textlen] = '\0';

	Conquer_Clip_Text_Print(text, X+1, Y+1, Color, TBLACK, TextFlags | flags, Width-2);

	if (Has_Focus() &&		//	strlen(passbuf) < MaxLength &&
		(String_Pixel_Width(passbuf) + String_Pixel_Width ("_") < Width-2) ) {
		Conquer_Clip_Text_Print( "_", X+1+String_Pixel_Width(passbuf), Y+1, Color, TBLACK, TextFlags | flags);
	}
    
	delete [] passbuf;
}

void PassEditClass::Set_Focus(void)
{
	if (bClearOnNextSetFocus) {
		String[0] = '\0';
		bClearOnNextSetFocus = false;
	}

	EditClass::Set_Focus();
}

//***********************************************************************************************
//	Override of EditClass::Handle_Key, to handle the masking of characters when the user types.
//	Again, I'm not about to change the base class directly, as I'm trying to have as minimal an affect as possible on
//	the current game code. -ajw
bool PassEditClass::Handle_Key(KeyASCIIType ascii)
{
	int passlen;
	char *passbuf;

	switch (ascii) {
		/*
		**	Handle the special case of a non-keyboard event. It is possible that this
		**	key code might be passed to this routine if this routine has been overridden
		**	and the key event was consumed.
		*/
		case 0:
			break;

		/*
		**	If the return key is pressed, then remove the focus from this edit
		**	gadget but otherwise let the normal gadget processing proceed. This
		**	causes the gadget ID number to be returned from the Input() function
		**	so that the controlling program will know that the text can be
		**	processed.
		*/
		case KA_RETURN:
			Clear_Focus();
			return(false);

		/*
		**	When the BACKSPACE key is pressed, remove the last character in the edit string.
		*/
		case KA_BACKSPACE:
			if (Length) {
				Length--;
				String[Length] = '\0';
				Flag_To_Redraw();
			}
			break;

		/*
		**	If the keyboard event was not a recognized special key, then examine to see
		**	if it can legally be added to the edit string and do so if possible.
		*/
		default:
			passlen = strlen(String);
			passbuf = new char[passlen + 1];
			memset(passbuf, '*', passlen);
			passbuf[passlen] = '\0';

			/*
			**	Don't add a character if the length is greater than edit width.
			*/
			if ((String_Pixel_Width(passbuf) + Char_Pixel_Width(ascii) ) >= (Width-2)) {
				delete [] passbuf;
				break;
			}

			delete [] passbuf;

			/*
			**	Don't add a character if the length is already at maximum.
			*/
			if (Length >= MaxLength) break;

			/*
			**	Invisible characters are never added to the string. This is
			**	especially true for spaces at the beginning of the string.
			*/
			if (!isgraph(ascii) && ascii != ' ') break;
			if (ascii == ' ' && Length == 0) break;

			/*
			**	If this is an upper case only edit gadget, then force the alphabetic
			**	character to upper case.
			*/
			if ((EditFlags & UPPERCASE) && isalpha(ascii)) {
				ascii = (KeyASCIIType)toupper(ascii);
			}

			if ((!(EditFlags & NUMERIC) || !isdigit(ascii)) &&
				(!(EditFlags & ALPHA) || !isalpha(ascii)) &&
				(!(EditFlags & MISC) || isalnum(ascii)) &&
				ascii != ' ') {
					break;
			}

			/*
			**	The character passed all legality checks, so add it to the edit string
			**	and flag this gadget to be redrawn. The manual flag to redraw is needed
			**	because the event flag has been cleared. This prevents the gadget's ID
			**	number from being returned just because the gadget has been edited.
			*/
			String[Length++] = ascii;
			String[Length] = '\0';
			Flag_To_Redraw();
			break;
	}
	return(true);
}

#endif
