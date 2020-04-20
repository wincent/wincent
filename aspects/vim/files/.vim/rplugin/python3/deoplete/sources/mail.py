from .base import Base

import re
from subprocess import PIPE, Popen

class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)

        self.filetypes = ['mail']
        self.name = 'mail'
        self.mark = '[@]'
        self.matchers = ['matcher_length', 'matcher_full_fuzzy']
        self.sorters = ['sorter_smart']
        self.min_pattern_length = 0
        self.limit = 1000000

        self.__pattern = re.compile('^(Bcc|Cc|From|Reply-To|To):(.*, ?| ?)')
        self.__binary = self.__find_lbdbq_binary()
        self.__candidates = None

    def on_event(self, context):
        self.__cache()

    def gather_candidates(self, context):
        result = self.__pattern.search(context['input'])
        if result is not None:
            if not self.__candidates:
                self.__cache()
            return self.__candidates

    def get_complete_position(self, context):
        colon = re.search(r': ?', context['input'])
        comma = re.search(r'.+, ?', context['input'])
        return max(colon.end() if colon else -1,
                comma.end() if comma else -1)

    def __cache(self):
        self.__candidates = []
        data = self.__lbdbq('.')
        if data:
            for line in data:
                try:
                    address, name, source = line.strip().split('\t')
                    if name:
                        address = name + ' <' + address + '>'
                    self.__candidates.append({'word': address, 'kind': source})
                except:
                    pass

    def __find_lbdbq_binary(self):
        return self.vim.call('exepath', 'lbdbq')

    def __lbdbq(self, query):
        if not self.__binary:
            return None
        command = [self.__binary, query]
        try:
            process = Popen(command, stderr = PIPE, stdout = PIPE)
            out, err = process.communicate()
            if not process.returncode:
                lines = out.decode().split('\n')
                if len(lines) > 1:
                    lines.pop(0)
                    return lines
        except:
            pass
