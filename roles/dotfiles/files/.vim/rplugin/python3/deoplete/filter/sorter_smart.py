from .base import Base

class Filter(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)
        self.name = 'sorter_smart'
        self.description = 'smart sorter'

    def filter(self, context):
        rank = context['vars']['deoplete#_rank']
        complete_str = context['complete_str']
        input_len = len(complete_str)
        smart_case = complete_str.lower() != complete_str
        return sorted(context['candidates'],
                key=lambda x: self.__score(complete_str, x['word'],
                    smart_case))

    def __score(self, needle, haystack, smart_case):
        if not smart_case:
            needle = needle.lower()
            haystack = haystack.lower()
        last_match = 0
        needle_index = 0
        needle_len = len(needle)
        score = 0
        leader = 0
        seeking = needle[needle_index]
        for index, char in enumerate(haystack):
            if char == seeking:
                if needle_index == 0:
                    leader = index
                else:
                    score += index - last_match
                last_match = index
                needle_index += 1
                if needle_index == needle_len:
                    break
                seeking = needle[needle_index]
        return float('%d.%.4d' % (score, leader))
