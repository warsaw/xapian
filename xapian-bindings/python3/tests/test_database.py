import os
import tempfile
import unittest

from xapian import Database


class TestDatabase(unittest.TestCase):
    def test_description_type(self):
        self.assertIsInstance(Database().description, bytes)

    def test_database_with_path(self):
        fd, path = tempfile.mkstemp()
        os.close(fd)
        try:
            database = Database(path)
            self.assertEqual(database.description, b'')
        finally:
            os.remove(path)

    def test_empty_description(self):
        self.assertEqual(Database().description, b'Database()')

    def test_empty_str(self):
        self.assertIsInstance(str(Database()), str)
        self.assertEqual(str(Database()), 'Database()')
