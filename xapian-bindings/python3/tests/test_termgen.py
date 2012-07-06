import unittest


from xapian import TermGenerator


class TestTermGenerator(unittest.TestCase):
    def test_description(self):
        self.assertEqual(TermGenerator().description,
                         'Xapian::TermGenerator(stem=Xapian::Stem(none), '
                         'doc=Document(Xapian::Document::Internal()), '
                         'termpos=0)')

    def test_empty_str(self):
        self.assertEqual(str(TermGenerator()),
                         'Xapian::TermGenerator(stem=Xapian::Stem(none), '
                         'doc=Document(Xapian::Document::Internal()), '
                         'termpos=0)')
