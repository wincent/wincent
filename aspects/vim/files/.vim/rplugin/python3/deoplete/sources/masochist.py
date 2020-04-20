from .base import Base

import deoplete.util as util

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
        self.__redis = redis.StrictRedis()
        self.__cache_breaker = re.compile(r"export const REDIS_CACHE_VERSION = '(\d+)';")
        self.__prefix = re.compile(r"export const REDIS_KEY_PREFIX = '(\w+)';")

    def on_event(self, context):
        self.__cache(context)

    def get_complete_position(self, context):
        position = context['input'].rfind('(')
        return position if position < 0 else position + 1

    def gather_candidates(self, context):
        result = self.__pattern.search(context['input'])
        if result is not None:
            if self.__active(context):
                if not self.__candidates:
                    self.__cache(context)
                return self.__candidates

    def __cache(self, context):
        if self.__active(context):
            config = self.__config(context)
            if not config:
                return
            (prefix, cache_breaker) = config
            wiki_candidates = [(kind, name)
                    for kind in ['wiki']
                    for name in self.__redis.zrevrange(prefix + ':' + cache_breaker + ':wiki-index', 0, 10000)]
            blog_candidates = [(kind, name)
                    for kind in ['blog']
                    for name in self.__redis.zrevrange(prefix + ':' + cache_breaker + ':blog-index', 0, 10000)]
            raw_candidates = wiki_candidates + blog_candidates
            self.__candidates = [
                {'word': '/' + kind + '/' + (name.decode() if kind == 'blog' else name.decode().replace(' ', '_')),
                    'kind': kind}
                    for (kind, name) in raw_candidates ]

    def __active(self, context):
        path = self.vim.call('expand', '%:p') or self.vim.call('getcwd')
        content = util.get_custom(context['custom'], 'masochist', 'content', '')
        return content and path.find(content) == 0

    def __config(self, context):
        config = util.get_custom(context['custom'], 'masochist', 'config', '')
        if config:
            try:
                with open(config) as search:
                    for line in search:
                        result = self.__cache_breaker.search(line)
                        if result is not None:
                            cache_breaker = result[1]
                        result = self.__prefix.search(line)
                        if result is not None:
                            prefix = result[1]
                if prefix and cache_breaker:
                    return (prefix, cache_breaker)
            except:
                pass
