// $Id$
//
// A file system object that SpFile and SpDir inherit from
//

#ifndef _spfsobject_h_
#define _spfsobject_h_

#include <string>
#include "SpTime.h"
#include "SpPath.h"
#include "SpUid.h"
#include "SpGid.h"
#include "SpSize.h"

class SpFsObject
{
	public:
		SpFsObject();
		~SpFsObject();
		SpFsObject(const string &path);
		bool isDir() const;
		bool isFile() const;
		SpTime lastAccess() const;
		SpTime lastModification() const;
		SpTime lastChange() const;
		SpPath path() const;
		SpUid uid() const;
		SpGid gid() const;
		SpSize size() const;
		void setPath(const string &pathString);
		void setPath(const SpPath &path);
	private:
		SpPath p;
};

#endif
