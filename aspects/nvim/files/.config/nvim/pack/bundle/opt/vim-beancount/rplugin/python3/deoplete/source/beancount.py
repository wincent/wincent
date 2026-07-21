import collections
import re

from deoplete.source.base import Base

try:
    from beancount.loader import load_file
    from beancount.core import data
    HAS_BEANCOUNT = True
except ImportError:
    HAS_BEANCOUNT = False

DIRECTIVES = [
    'open', 'close', 'commodity', 'txn', 'balance', 'pad', 'note', 'document',
    'price', 'event', 'query', 'custom'
]


COMPLETE_PATTERN = re.compile(r'\S*$')
DIRECTIVE_PATTERN = re.compile(r'^\d{4}[/-]\d\d[/-]\d\d \w*$')
ACCOUNT_PATTERN = re.compile(r'^(\s)+[\w:]+$')
DIRECTIVE_ACCOUNT_PATTERN = re.compile(
    r'(balance|document|note|open|close|pad(\s[\w:]+)?)\s[\w:]+$')
EVENT_PATTERN = re.compile(r'event "[^"]*$')
COMMODITY_PATTERN = re.compile(r'\s([0-9]+|[0-9][0-9,]+[0-9])(\.[0-9]*)?\s\w+$')

class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.vim = vim

        self.name = 'beancount'
        self.mark = '[bc]'
        self.matchers = ['matcher_full_fuzzy']
        self.filetypes = ['beancount']
        self.rank = 500
        self.min_pattern_length = 0
        self.attributes = collections.defaultdict(list)
        self.beancount_root = None
        self.auto_complete_delay = 10

    def on_init(self, context):
        if not HAS_BEANCOUNT:
            self.error('Importing beancount failed.')
        self.beancount_root = self.vim.eval("beancount#get_root()")

    def on_event(self, context):
        if context['event'] in ('Init', 'BufWritePost'):
            # Make cache on BufNewFile, BufRead, and BufWritePost
            self.__make_cache(context)

    def get_complete_position(self, context):
        m = COMPLETE_PATTERN.search(context['input'])
        return m.start() if m else -1

    def gather_candidates(self, context):
        self.debug("Attributes are {}".format(self.attributes))
        attrs = self.attributes
        if DIRECTIVE_PATTERN.match(context['input']):
            return attrs['directives']
        # line that starts with whitespace (-> accounts)
        if ACCOUNT_PATTERN.match(context['input']):
            return attrs['accounts']
        # directive followed by account
        if DIRECTIVE_ACCOUNT_PATTERN.search(context['input']):
            return attrs['accounts']
        # events
        if EVENT_PATTERN.search(context['input']):
            return attrs['events']
        # commodity after number
        if COMMODITY_PATTERN.search(context['input']):
            return attrs['commodities']
        if not context['complete_str']:
            return []
        first = context['complete_str'][0]
        if first == '#':
            return attrs['tags']
        elif first == '^':
            return attrs['links']
        return []

    def __make_cache(self, context):
        if not HAS_BEANCOUNT:
            return

        entries, _, options = load_file(self.beancount_root)

        accounts = set()
        events = set()
        links = set()
        tags = set()

        for entry in entries:
            if isinstance(entry, data.Open):
                accounts.add(entry.account)
            if hasattr(entry, 'links') and entry.links:
                links.update(entry.links)
            if hasattr(entry, 'tags') and entry.tags:
                tags.update(entry.tags)
            if isinstance(entry, data.Event):
                events.add(entry.type)

        self.attributes = {
            'accounts': [
                {'word': x, 'kind': 'account'} for x in sorted(accounts)],
            'events': [{
                'word': '"{}"'.format(x),
                'kind': 'event'
            } for x in sorted(events)],
            'commodities': [{
                'word': x,
                'kind': 'commodity'
            } for x in options['commodities']],
            'links': [{'word': '^' + w, 'kind': 'link'} for w in sorted(links)],
            'tags': [{'word': '#' + w, 'kind': 'tag'} for w in sorted(tags)],
            'directives': [
                {'word': x, 'kind': 'directive'} for x in DIRECTIVES],
        }
