import unittest

from xapian import Xapian


class TestGlobals(unittest.TestCase):
    def test_major_version(self):
        self.assertIsInstance(Xapian.major_version, int)

    def test_minor_version(self):
        self.assertIsInstance(Xapian.minor_version, int)

    def test_revision(self):
        self.assertIsInstance(Xapian.revision, int)

    def test_version_string(self):
        self.assertIsInstance(Xapian.version_string, str)
        self.assertEqual(
            [int(v) for v in Xapian.version_string.split('.')][:2],
            [Xapian.major_version, Xapian.minor_version])
