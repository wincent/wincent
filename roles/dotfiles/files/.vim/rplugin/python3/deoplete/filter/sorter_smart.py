from .base import Base

import score

class Filter(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)
        self.name = 'sorter_smart'
        self.description = 'smart sorter'

    def filter(self, context):
        rank = context['vars']['deoplete#_rank']
        complete_str = context['complete_str']
        input_len = len(complete_str)
        smart_case = int(complete_str.lower() != complete_str)
        return sorted(context['candidates'],
                key=lambda x: -1 * score.calc(complete_str, x['word'],
                    smart_case))
