from .base import Base

import re
import redis

class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)

        self.filetypes = ['markdown']
        self.name = 'masochist'
        self.mark = '[masochist]'
        self.matchers = ['matcher_length', 'matcher_full_fuzzy']
        self.sorters = ['sorter_smart']
        self.min_pattern_length = 0
        self.limit = 1000000

        self.__pattern = re.compile('\]\(')
        self.__candidates = None
        self.__prefix = 'masochist'
        self.__cache_breaker = '6'
        self.__redis = redis.StrictRedis()

    def on_event(self, context):
        self.__cache()

    def gather_candidates(self, context):
        result = self.__pattern.search(context['input'])
        if result is not None:
            if not self.__candidates:
                self.__cache()
            return self.__candidates

    def __cache(self):
        wiki_candidates = [(kind, name)
                for kind in ['wiki']
                for name in self.__redis.zrevrange(self.__prefix + ':' + self.__cache_breaker + ':wiki-index', 0, 10000)]
        blog_candidates = [(kind, name)
                for kind in ['blog']
                for name in self.__redis.zrevrange(self.__prefix + ':' + self.__cache_breaker + ':blog-index', 0, 10000)]
        raw_candidates = wiki_candidates + blog_candidates

        self.__candidates = [
               {'word': '/' + kind + '/' + (name.decode() if kind == 'blog' else name.decode().replace(' ', '_')),
                'kind': kind}
                for (kind, name) in raw_candidates ]
