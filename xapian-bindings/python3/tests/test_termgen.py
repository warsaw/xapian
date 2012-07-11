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

    def test_termpos(self):
        tg = TermGenerator()
        self.assertEqual(tg.termpos, 0)
        tg.termpos = 400
        self.assertEqual(tg.termpos, 400)
        tg.increase_termpos(100)
        self.assertEqual(tg.termpos, 500)

    def test_index(self):
        tg = TermGenerator()
        tg.document = Document()
        self.assertEqual(tg.termpos, 0)
        tg.index_text('hello')
        self.assertEqual(tg.termpos, 1)
        self.assertEqual(tg.description,
                         'Xapian::TermGenerator('
                         'stem=Xapian::Stem(none), '
                         'doc=Document('
                         # See? One term was added.
                         'Xapian::Document::Internal(terms[1])), '
                         'termpos=1)')
        tg.index_text(b'world')
        self.assertEqual(tg.termpos, 2)
        self.assertEqual(tg.description,
                         'Xapian::TermGenerator('
                         'stem=Xapian::Stem(none), '
                         'doc=Document('
                         # See?  A second term was added.
                         'Xapian::Document::Internal(terms[2])), '
                         'termpos=2)')

    def test_index_with_wdf_inc(self):
        # Give something other than the default for wdf_inc argument.
        tg = TermGenerator()
        tg.document = Document()
        # XXX AFAICT, there's no way to test the effects of increasing the
        # wdf_inc, i.e. the term weighting factor.  This is *not* the same as
        # the termcount.
        self.assertEqual(tg.termpos, 0)
        tg.index_text('hello', 10)
        self.assertEqual(tg.termpos, 1)

    def test_index_with_prefix(self):
        tg = TermGenerator()
        tg.document = Document()
        self.assertEqual(tg.termpos, 0)
        tg.index_text('hello', prefix='AA')
        self.assertEqual(tg.termpos, 1)
        self.assertEqual(tg.description,
                         'Xapian::TermGenerator('
                         'stem=Xapian::Stem(none), '
                         'doc=Document('
                         # See?  One term was added.
                         'Xapian::Document::Internal(terms[1])), '
                         'termpos=1)')
        tg.index_text('hello', prefix=b'BB')
        self.assertEqual(tg.termpos, 2)
        self.assertEqual(tg.description,
                         'Xapian::TermGenerator('
                         'stem=Xapian::Stem(none), '
                         'doc=Document('
                         # See?  A second term was added.
                         'Xapian::Document::Internal(terms[2])), '
                         'termpos=2)')

    def test_index_with_wdf_inc_and_prefix(self):
        tg = TermGenerator()
        tg.document = Document()
        self.assertEqual(tg.termpos, 0)
        tg.index_text('hello', 10, 'AA')
        self.assertEqual(tg.termpos, 1)
        tg.index_text('hello', 20, prefix=b'BB')
        self.assertEqual(tg.termpos, 2)
