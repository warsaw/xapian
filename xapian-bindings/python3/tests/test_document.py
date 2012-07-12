import unittest

from xapian import Document


class TestDocument(unittest.TestCase):
    def test_empty_description(self):
        self.assertEqual(Document().description,
                         'Document(Xapian::Document::Internal())')

    def test_empty_str(self):
        self.assertEqual(str(Document()),
                         'Document(Xapian::Document::Internal())')

    def test_docid(self):
        doc_1 = Document()
        doc_2 = Document()
        self.assertIsInstance(doc_1.docid, int)
        self.assertIsInstance(doc_2.docid, int)

    def test_serialise(self):
        doc = Document()
        self.assertEqual(doc.serialise, b'')

    def test_add_term(self):
        doc = Document()
        # termlist_count can be gotten via len()
        self.assertEqual(len(doc), 0)
        doc.add_term('hello')
        self.assertEqual(len(doc), 1)

    def test_iterator(self):
        doc = Document()
        doc.add_term('hello')
        doc.add_term(b'world')
        termiter = iter(doc)
        for term in doc:
            print(term)
        self.assertEqual(termiter.description, '')
        self.assertEqual(str(termiter), '')

    def test_iteration_loop(self):
        doc = Document()
        doc.add_term('hello')
        doc.add_term(b'world')
        all_terms = [term.decode('utf-8') for term in doc]
        self.assertListEqual(all_terms, ['hello', 'world'])
