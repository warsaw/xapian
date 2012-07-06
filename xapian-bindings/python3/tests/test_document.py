import unittest

from xapian import Document


class TestDocument(unittest.TestCase):
    def test_empty_description(self):
        self.assertEqual(Document().description,
                         'Document(Xapian::Document::Internal())')

    def test_empty_str(self):
        self.assertEqual(str(Document()),
                         'Document(Xapian::Document::Internal())')
