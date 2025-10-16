syn region kittyKeybind start=' ' end=' ' contains=kittyMod,kittyKey,kittyKeyComb contained nextgroup=kittyActionKW
syn region kittyString start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region kittyString start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline
syn spell notoplevel

" the order here matters
syn match kittySt '.*$' contains=kittyNumber,kittyColor
syn match kittyColor '#\x\{3,8}' contained
syn match kittyNumber '\s[+-]\?\d\+\.\?\d*\(%\|px\|pt\|em\)\?'ms=s+1 contained contains=kittyUnit
syn match kittyUnit '\(px\|pt\|em\)' contained
syn match kittyKW '^\s*\S*' contains=kittyKeyword,kittyInvalidKeyword nextgroup=kittySt
syn match kittyComment /^\s*#.*$/ contains=kittyTodo,@Spell
syn match kittyInclude '^\s*\(env\|glob\)\?include' display
syn match kittyMap '^\s*\(mouse_\)\?map' nextgroup=kittyKeybind
syn match kittyContinue '^\(\s\+\)\?\\'
syn match kittyInvalidKeyword '\S*' contained
syn match kittyActionKW '\s*\S*' contained contains=kittyAction,kittyEvent,kittyInvalidAction
syn match kittyInvalidAction '\S*' contained

hi def link kittyAction Function
hi def link kittyColor Number
hi def link kittyComment Comment
hi def link kittyContinue kittySt
hi def link kittyEvent Function
hi def link kittyInclude Include
hi def link kittyInvalidAction Error
hi def link kittyInvalidKeyword Error
hi def link kittyKeybind Constant
hi def link kittyKeyword Keyword
hi def link kittyMap Keyword
hi def link kittyMod Constant
hi def link kittyNumber Number
hi def link kittyString String
hi def link kittyTodo Todo
hi def link kittyUnit Type

let b:current_syntax = "kitty"

syn keyword kittyMod contained ctrl alt shift cmd super hyper meta kitty_mod
syn keyword kittyTodo contained TODO FIXME XXX contained
syn keyword kittyEvent contained
 \ press release doublepress triplepress click doubleclick
" START GENERATED CODE
syn keyword kittyKeyword contained
 \ action_alias active_border_color active_tab_background active_tab_font_style active_tab_foreground active_tab_title_template allow_cloning allow_hyperlinks
 \ allow_remote_control background background_blur background_image background_image_layout background_image_linear background_opacity background_tint
 \ background_tint_gaps bell_border_color bell_on_tab bell_path bold_font bold_italic_font box_drawing_scale clear_all_mouse_actions
 \ clear_all_shortcuts clear_selection_on_clipboard_loss click_interval clipboard_control clipboard_max_size clone_source_strategies close_on_child_death color0
 \ color1 color10 color100 color101 color102 color103 color104 color105
 \ color106 color107 color108 color109 color11 color110 color111 color112
 \ color113 color114 color115 color116 color117 color118 color119 color12
 \ color120 color121 color122 color123 color124 color125 color126 color127
 \ color128 color129 color13 color130 color131 color132 color133 color134
 \ color135 color136 color137 color138 color139 color14 color140 color141
 \ color142 color143 color144 color145 color146 color147 color148 color149
 \ color15 color150 color151 color152 color153 color154 color155 color156
 \ color157 color158 color159 color16 color160 color161 color162 color163
 \ color164 color165 color166 color167 color168 color169 color17 color170
 \ color171 color172 color173 color174 color175 color176 color177 color178
 \ color179 color18 color180 color181 color182 color183 color184 color185
 \ color186 color187 color188 color189 color19 color190 color191 color192
 \ color193 color194 color195 color196 color197 color198 color199 color2
 \ color20 color200 color201 color202 color203 color204 color205 color206
 \ color207 color208 color209 color21 color210 color211 color212 color213
 \ color214 color215 color216 color217 color218 color219 color22 color220
 \ color221 color222 color223 color224 color225 color226 color227 color228
 \ color229 color23 color230 color231 color232 color233 color234 color235
 \ color236 color237 color238 color239 color24 color240 color241 color242
 \ color243 color244 color245 color246 color247 color248 color249 color25
 \ color250 color251 color252 color253 color254 color255 color26 color27
 \ color28 color29 color3 color30 color31 color32 color33 color34
 \ color35 color36 color37 color38 color39 color4 color40 color41
 \ color42 color43 color44 color45 color46 color47 color48 color49
 \ color5 color50 color51 color52 color53 color54 color55 color56
 \ color57 color58 color59 color6 color60 color61 color62 color63
 \ color64 color65 color66 color67 color68 color69 color7 color70
 \ color71 color72 color73 color74 color75 color76 color77 color78
 \ color79 color8 color80 color81 color82 color83 color84 color85
 \ color86 color87 color88 color89 color9 color90 color91 color92
 \ color93 color94 color95 color96 color97 color98 color99 command_on_bell
 \ confirm_os_window_close copy_on_select cursor cursor_beam_thickness cursor_blink_interval cursor_shape cursor_shape_unfocused cursor_stop_blinking_after
 \ cursor_text_color cursor_trail cursor_trail_decay cursor_trail_start_threshold cursor_underline_thickness default_pointer_shape detect_urls dim_opacity
 \ disable_ligatures draw_minimal_borders dynamic_background_opacity editor enable_audio_bell enabled_layouts env exe_search_path
 \ file_transfer_confirmation_bypass filter_notification focus_follows_mouse font_family font_features font_size force_ltr foreground
 \ forward_stdio hide_window_decorations inactive_border_color inactive_tab_background inactive_tab_font_style inactive_tab_foreground inactive_text_alpha initial_window_height
 \ initial_window_width input_delay italic_font kitten_alias kitty_mod linux_bell_theme linux_display_server listen_on
 \ macos_colorspace macos_custom_beam_cursor macos_hide_from_tasks macos_menubar_title_max_length macos_option_as_alt macos_quit_when_last_window_closed macos_show_window_title_in macos_thicken_font
 \ macos_titlebar_color macos_traditional_fullscreen macos_window_resizable map mark1_background mark1_foreground mark2_background mark2_foreground
 \ mark3_background mark3_foreground menu_map modify_font mouse_hide_wait mouse_map narrow_symbols notify_on_cmd_finish
 \ open_url_with paste_actions placement_strategy pointer_shape_when_dragging pointer_shape_when_grabbed remember_window_position remember_window_size remote_control_password
 \ repaint_delay resize_debounce_time resize_in_steps scrollback_fill_enlarged_window scrollback_indicator_opacity scrollback_lines scrollback_pager scrollback_pager_history_size
 \ select_by_word_characters select_by_word_characters_forward selection_background selection_foreground shell shell_integration show_hyperlink_targets single_window_margin_width
 \ single_window_padding_width startup_session strip_trailing_spaces symbol_map sync_to_monitor tab_activity_symbol tab_bar_align tab_bar_background
 \ tab_bar_edge tab_bar_margin_color tab_bar_margin_height tab_bar_margin_width tab_bar_min_tabs tab_bar_style tab_fade tab_powerline_style
 \ tab_separator tab_switch_strategy tab_title_max_length tab_title_template term terminfo_type text_composition_strategy text_fg_override_threshold
 \ touch_scroll_multiplier transparent_background_colors undercurl_style underline_exclusion underline_hyperlinks update_check_interval url_color url_excluded_characters
 \ url_prefixes url_style visual_bell_color visual_bell_duration visual_window_select_characters watcher wayland_enable_ime wayland_titlebar_color
 \ wheel_scroll_min_lines wheel_scroll_multiplier window_alert_on_bell window_border_width window_logo_alpha window_logo_path window_logo_position window_logo_scale
 \ window_margin_width window_padding_width window_resize_step_cells window_resize_step_lines
syn keyword kittyAction contained
 \ change_font_size clear_selection clear_terminal close_os_window close_other_os_windows close_other_tabs_in_os_window close_other_windows_in_tab close_shared_ssh_connections
 \ close_tab close_window close_window_with_confirmation combine copy_and_clear_or_interrupt copy_ansi_to_clipboard copy_or_interrupt copy_to_buffer
 \ copy_to_clipboard create_marker debug_config detach_tab detach_window disable_ligatures_in discard_event dump_lines_with_attrs
 \ edit_config_file eighth_window fifth_window first_window focus_visible_window fourth_window goto_layout goto_tab
 \ hide_macos_app hide_macos_other_apps input_unicode_character kitten kitty_shell last_used_layout launch layout_action
 \ load_config_file minimize_macos_window mouse_click_url mouse_click_url_or_select mouse_handle_click mouse_select_command_output mouse_selection mouse_show_command_output
 \ move_tab_backward move_tab_forward move_window move_window_backward move_window_forward move_window_to_top neighboring_window new_os_window
 \ new_os_window_with_cwd new_tab new_tab_with_cwd new_window new_window_with_cwd next_layout next_tab next_window
 \ ninth_window no_op nth_os_window nth_window open_url open_url_with_hints pass_selection_to_program paste
 \ paste_from_buffer paste_from_clipboard paste_from_selection paste_selection paste_selection_or_clipboard pop_keyboard_mode previous_tab previous_window
 \ push_keyboard_mode quit remote_control remote_control_script remove_marker reset_window_sizes resize_window scroll_end
 \ scroll_home scroll_line_down scroll_line_up scroll_page_down scroll_page_up scroll_prompt_to_bottom scroll_prompt_to_top scroll_to_mark
 \ scroll_to_prompt second_window select_tab send_key send_text set_background_opacity set_colors set_tab_title
 \ set_window_title seventh_window show_error show_first_command_output_on_screen show_kitty_doc show_kitty_env_vars show_last_command_output show_last_non_empty_command_output
 \ show_last_visited_command_output show_scrollback signal_child simulate_color_scheme_preference_change sixth_window sleep start_resizing_window swap_with_window
 \ tenth_window third_window toggle_fullscreen toggle_layout toggle_macos_secure_keyboard_entry toggle_marker toggle_maximized toggle_tab
