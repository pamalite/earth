//  Copyright (C) 2001-2003 Matthew Landauer. All Rights Reserved.
//  
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of version 2 of the GNU General Public License as
//  published by the Free Software Foundation.
//
//  This program is distributed in the hope that it would be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Further, any
//  license provided herein, whether implied or otherwise, is limited to
//  this program in accordance with the express provisions of the GNU
//  General Public License.  Patent licenses, if any, provided herein do not
//  apply to combinations of this program with other product or programs, or
//  any other product whatsoever.  This program is distributed without any
//  warranty that the program is delivered free of the rightful claim of any
//  third person by way of infringement or the like.  See the GNU General
//  Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write the Free Software Foundation, Inc., 59
//  Temple Place - Suite 330, Boston MA 02111-1307, USA.
//
// $Id$

#ifndef _tiffimage_h_
#define _tiffimage_h_

#include "Image.h"
#include "ImageFormat.h"
#include "ImageDim.h"

namespace Sp {

//! Properties of the TIFF image format
/*!
  The Tag Image File Format (TIFF) is a very flexible format that can store
  a wide variety of data types and can store the data in many different forms.
  This flexibility comes at a price. It is often the case that applications do
  not fully support all of the specification.
*/
class TIFFImageFormat: public ImageFormat
{
	public:
		virtual Image* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int getSizeToRecognise() { return 4; };
		virtual std::string getFormatString() { return "TIFF"; }
};

//! Support operations on a TIFF format image
/*!
  For a description of the TIFF format see TIFFImageFormat
*/
class TIFFImage : public Image
{
	public:
		TIFFImage() : headerRead(false), validHeader(false) { };
		~TIFFImage() { };
		ImageDim getDim() const;
		bool valid() const;
	private:
		mutable unsigned int h, w;
		mutable bool headerRead;
		mutable bool validHeader;
		void readHeader() const;
};

}

#endif
