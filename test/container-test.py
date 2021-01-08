import unittest
import container

class Test(unittest.TestCase):
    """test class of container.py
    """

    def test_001(self):
        """http status check
        """
        event = {'zip': '1310045'}
        context = ''
        expected = 200
        actual = container.lambda_handler(event, context)
        self.assertEqual(expected, actual['zip']['status'])


if __name__ == "__main__":
    unittest.main()