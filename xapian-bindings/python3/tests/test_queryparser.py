import os
import shutil
import tempfile
import unittest

from xapian import Database, WritableDatabase, QueryParser


class TestQueryParser(unittest.TestCase):
    def test_description(self):
        self.assertEqual(QueryParser().description, 'Xapian::QueryParser()')

    def test_set_database(self):
        # The effects of .set_database() cannot be tested because Xapian
        # doesn't expose the internal db pointer in any evident way, including
        # in the description.  Best we can do is make sure it doesn't crash.
        tempdir = tempfile.mkdtemp()
        try:
            # First try a writable database.
            dbfile = os.path.join(tempdir, 'test.db')
            wdb = WritableDatabase(dbfile)
            qp = QueryParser()
            qp.set_database(wdb)
            # Now try a read-only database.
            rdb = Database(dbfile)
            qp.set_database(rdb)
        finally:
            shutil.rmtree(tempdir)
