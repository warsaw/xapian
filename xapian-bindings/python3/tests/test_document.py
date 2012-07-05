import unittest

from xapian import Document


class TestDocument(unittest.TestCase):
    def test_description_type(self):
        self.assertIsInstance(Document().description, bytes)

    def test_empty_description(self):
        self.assertEqual(Document().description,
                         b'Document(Xapian::Document::Internal())')

    def test_empty_str(self):
        self.assertIsInstance(str(Document()), str)
        self.assertEqual(str(Document()),
                         'Document(Xapian::Document::Internal())')
