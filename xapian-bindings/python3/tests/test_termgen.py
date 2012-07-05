import unittest


from xapian import TermGenerator


class TestTermGenerator(unittest.TestCase):
    def test_description_type(self):
        self.assertIsInstance(TermGenerator().description, bytes)

    def test_empty_description(self):
        self.assertEqual(TermGenerator().description,
                         b'Xapian::TermGenerator(stem=Xapian::Stem(none), '
                         b'doc=Document(Xapian::Document::Internal()), '
                         b'termpos=0)')

    def test_empty_str(self):
        self.assertIsInstance(str(TermGenerator()), str)
        self.assertEqual(str(TermGenerator()),
                         'Xapian::TermGenerator(stem=Xapian::Stem(none), '
                         'doc=Document(Xapian::Document::Internal()), '
                         'termpos=0)')
