import unittest


from xapian import Document, Stem, TermGenerator


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

    def test_set_stemmer(self):
        tg = TermGenerator()
        tg.set_stemmer(Stem('en'))
        self.assertEqual(tg.description,
                         'Xapian::TermGenerator(stem=Xapian::Stem(english), '
                         'doc=Document(Xapian::Document::Internal()), '
                         'termpos=0)')

    def test_set_document(self):
        tg = TermGenerator()
        doc = Document()
        tg.document = doc
        self.assertEqual(tg.description,
                         'Xapian::TermGenerator(stem=Xapian::Stem(none), '
                         'doc=Document(Xapian::Document::Internal()), '
                         'termpos=0)')

    def test_get_set_data(self):
        doc = Document()
        doc.data = b'xyz123'
        self.assertEqual(doc.data, b'xyz123')
        self.assertNotEqual(doc.data, 'xyz123')
        with self.assertRaises(TypeError):
            doc.data = 'not bytes'

    def test_get_document(self):
        # Since documents can't be compared, we'll set some data on the stored
        # document and ensure that data exists on the retrieved one.
        tg = TermGenerator()
        doc = Document()
        doc.data = b'document'
        tg.document = doc
        self.assertEqual(tg.document.data, b'document')
