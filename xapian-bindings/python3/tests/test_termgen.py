import unittest


from xapian import TermGenerator


class TestTermGenerator(unittest.TestCase):
    def test_description_type(self):
        self.assertIsInstance(TermGenerator().description, str)

    def test_empty_term_generator(self):
        self.assertEqual(TermGenerator().description, '')
