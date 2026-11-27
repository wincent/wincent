from kitty.fast_data_types import add_timer, get_boss, monotonic

try:
    from kitty.program_status import State
except ImportError:
    State = None

FRAMES = '\uee06\uee07\uee08\uee09\uee0a\uee0b'
INTERVAL = 0.1
_timer_id = None


def _tick(_timer_id_arg):
    global _timer_id
    _timer_id = None
    boss = get_boss()
    if boss is None or State is None:
        return
    for tm in boss.all_tab_managers:
        if any(
            (r := w.program_status.most_urgent()) is not None and r.state is State.working
            for tab in tm
            for w in tab
        ):
            tm.mark_tab_bar_dirty()


def draw_title(data):
    global _timer_id
    status = getattr(data['tab'], 'program_status', '')
    if '\uf110' in status:
        frame = FRAMES[int(monotonic() / INTERVAL) % len(FRAMES)]
        status = status.replace('\uf110  ', f'{frame} ', 1)
        if _timer_id is None:
            _timer_id = add_timer(_tick, INTERVAL, False)
    return status
