import unittest

from xapian import Stem


class TestStemmer(unittest.TestCase):
    def test_description(self):
        self.assertEqual(Stem().description, 'Xapian::Stem(none)')

    def test_description_with_language(self):
        self.assertEqual(Stem('en').description, 'Xapian::Stem(english)')
