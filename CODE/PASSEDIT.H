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
 * WOLEditClass -- Derived from EditClass, includes changes I wanted for
 *                 wolapi integration stuff.
 *
 * HISTORY:    07/17/1998 ajw : Created.
 *=========================================================================*/

#include "Function.h"

class WOLEditClass : public EditClass
{
public:
	WOLEditClass(int id, char * text, int max_len, TextPrintType flags, int x, int y, int w, int h, EditStyle style) :
		EditClass( id, text, max_len, flags, x, y, w, h, style )	{}
		
	virtual int Action (unsigned flags, KeyNumType &key);		//	Override of base

protected:
	virtual void Draw_Text( char const * text );				//	Override of base

};

#endif
