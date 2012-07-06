import unittest

from xapian import QueryParser


class TestQueryParser(unittest.TestCase):
    def test_description(self):
        self.assertEqual(QueryParser().description, 'Xapian::QueryParser()')
