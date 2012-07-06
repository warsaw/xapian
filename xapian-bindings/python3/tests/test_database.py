import os
import shutil
import tempfile
import unittest

from xapian import Database, DatabaseOpenError, WritableDatabase


class TestDatabase(unittest.TestCase):
    def test_database_with_existing_path(self):
        fd, path = tempfile.mkstemp()
        os.close(fd)
        try:
            database = Database(path)
            self.assertEqual(database.description, 'Database()')
        finally:
            os.remove(path)

    def test_database_with_nonexisting_path(self):
        dirname = tempfile.mkdtemp()
        try:
            self.assertRaises(DatabaseOpenError,
                              Database, os.path.join(dirname, 'test.db'))
        finally:
            shutil.rmtree(dirname)

    def test_description(self):
        self.assertEqual(Database().description, 'Database()')

    def test_str(self):
        self.assertEqual(str(Database()), 'Database()')


class TestWritableDatabase(unittest.TestCase):
    def test_database_with_existing_path_nondatabase(self):
        fd, path = tempfile.mkstemp()
        os.close(fd)
        try:
            self.assertRaises(DatabaseOpenError, WritableDatabase, path)
        finally:
            os.remove(path)

    def test_database_with_nonexisting_path(self):
        dirname = tempfile.mkdtemp()
        try:
            database = WritableDatabase(os.path.join(dirname, 'test.db'))
            self.assertEqual(database.description, 'WritableDatabase()')
        finally:
            shutil.rmtree(dirname)

    def test_description(self):
        self.assertEqual(WritableDatabase().description, 'WritableDatabase()')

    def test_str(self):
        self.assertEqual(str(WritableDatabase()), 'WritableDatabase()')
