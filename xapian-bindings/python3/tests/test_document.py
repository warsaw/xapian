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
