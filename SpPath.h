// $Id$

#ifndef _sppath_h_
#define _sppath_h_

#include <string>

class SpPath
{
	public:
		SpPath(const string &a = "");
		SpPath(char *s);
		~SpPath();
		void set(const string &a);
		string fullName() const;
		string root() const;
		string relative() const;
		void add(const string &a);
	private:
		string pathString;
};

#endif